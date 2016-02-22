# get the transcript by Ensembl transcript id
function gencode_transcript(index, tid)
    for (chr, genelist) in index
        for gene in genelist
            for transcript in gene.transcripts
                if transcript.id == tid
                    return transcript
                end
            end
        end
    end
    return nothing
end

# get gene details by gene name, return a gene list
# for most cases, it will return a array with one record
function gencode_genes(index, genename)
    genes = []
    for (chr, genelist) in index
        for gene in genelist
            if gene.name == genename
                push!(genes, gene)
            end
        end
    end
    return genes
end

# find which gene and which exon chr::pos locates in 
function gencode_locate(index, chr, pos)
    if !haskey(index, chr)
        return false
    end
    # largest gene found in nature is about 2.4M bp
    const LARGEST_GENE_SIZE = 2_600_000
    # we search all genes with its start_pos in [pos - LARGEST_GENE_SIZE, pos]
    genes = index[chr]
    len = length(genes)

    # binary search for pos - LARGEST_GENE_SIZE
    left = 1
    right = len
    while left < right
        cur = div(left+right, 2)
        gene = genes[cur]
        if gene.start_pos == pos - LARGEST_GENE_SIZE
            left = cur
            break
        elseif gene.start_pos > pos - LARGEST_GENE_SIZE
            right = cur - 1
        else
            left = cur + 1
        end
    end
    search_left = left

    # binary search for pos
    right = len
    while left < right
        cur = div(left+right, 2)
        gene = genes[cur]
        if gene.start_pos == pos
            right = cur
            break
        elseif gene.start_pos > pos
            right = cur - 1
        else
            left = cur + 1
        end
    end
    search_right = right

    matches = []
    for s in search_left:search_right
        gene = genes[s]
        if gene.start_pos <= pos && gene.end_pos >= pos
            result = search_in_gene(gene, pos)
            if result != false
                push!(matches, result)
            end
        end
    end
    return matches
end

function search_in_gene(gene, pos)
    for t in gene.transcripts
        if t.start_pos>pos || t.end_pos < pos
            continue
        end
        if !haskey(t.attributes, "tag") || !contains(t.attributes["tag"], "basic")
            continue
        end
        for exon in t.exons
            # strand is -, then exons are aligned big coord -> small coord
            if gene.strand == "-"
                if exon.start_pos<=pos && exon.end_pos>=pos
                    return Dict("gene"=>gene.name, "transcript"=>t.id, "type"=>"exon", "number"=>exon.number)
                elseif exon.end_pos<pos
                    return Dict("gene"=>gene.name, "transcript"=>t.id, "type"=>"intron", "number"=>exon.number - 1)
                end
            else
                if exon.start_pos<=pos && exon.end_pos>=pos
                    return Dict("gene"=>gene.name, "transcript"=>t.id, "type"=>"exon", "number"=>exon.number)
                elseif exon.start_pos>pos
                    return Dict("gene"=>gene.name, "transcript"=>t.id, "type"=>"intron", "number"=>exon.number - 1)
                end
            end
        end
    end
    return false
end