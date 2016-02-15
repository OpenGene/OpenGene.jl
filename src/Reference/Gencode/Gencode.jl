const GENCODE_INDEX_VER = 1
immutable GencodeExon
    number::Int32
    start_pos::Int64
    end_pos::Int64
end

type GencodeTranscript
    id::ASCIIString
    start_pos::Int64
    end_pos::Int64
    attributes::OrderedDict{ASCIIString, ASCIIString}
    exons::Array{GencodeExon, 1}
end

type GencodeGene
    name::ASCIIString
    id::ASCIIString
    start_pos::Int64
    end_pos::Int64
    strand::ASCIIString
    attributes::OrderedDict{ASCIIString, ASCIIString}
    transcripts::Array{GencodeTranscript, 1}
end

"""
reference->chromosome dict->gene list->transcript list->exon list
"""
function gencode_load(filename::AbstractString)
    cache_path = "$filename.v$GENCODE_INDEX_VER.idx"
    loaded = false
    # load the index from a cache file
    if isfile(cache_path)
        try
        io = open(cache_path)
        index = deserialize(io)
        if !isa(index, Dict)
            error("invalid index file, index should be a serialized Dict")
        end
        loaded = true
        return index
        catch(e)
            warn(e)
            warn("Failed to load the pre-built index ($cache_path), maybe it is not completed when saving it. Attemping to delete it now!")
            try
                rm(cache_path)
            catch(e)
                warn(e)
                warn("Failed to delete $cache_path, please do it manually")
            end
        end
    end

    if !loaded
        index = parse_gencode(filename)
        # save the index to a cache file
        try
            io = open(cache_path, "w")
            serialize(io, index)
        catch(e)
            warn("Unable to save index to $cache_path. Please check if the folder is writable for current user, if the index is not cached, it will be built every time you run FusionDirect, which is slow.")
        end
        return index
    end
end

function parse_gencode(filename::AbstractString)
    index = Dict()
    gtf, stream = gtf_read(filename, loaddata = false)
    gene = nothing
    transcript = nothing
    while (row = gtf_read_row(stream)) != false
        if row.feature == "gene"
            gene_id = strip(row.attributes["gene_id"], '"')
            gene_name = strip(row.attributes["gene_name"], '"')
            gene = GencodeGene(gene_name, gene_id, row.start_pos, row.end_pos, row.strand, row.attributes, Array{GencodeTranscript, 1}())
            if !haskey(index, row.seqname)
                index[row.seqname] = []
            end
            push!(index[row.seqname], gene)
        elseif row.feature == "transcript"
            transcript_id = strip(row.attributes["transcript_id"], '"')
            transcript = GencodeTranscript(transcript_id, row.start_pos, row.end_pos, row.attributes, Array{GencodeExon, 1}())
            if gene == nothing
                error("wrong format")
            end
            push!(gene.transcripts, transcript)
        elseif row.feature == "exon"
            exon_number = strip(row.attributes["exon_number"], '"')
            exon = GencodeExon(parse(Int32, exon_number), row.start_pos, row.end_pos)
            if transcript == nothing
                error("wrong format")
            end
            push!(transcript.exons, exon)
        end
    end
    return index
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
        range = 1:length(t.exons)
        if gene.strand == "-"
            range = length(t.exons):-1:1
        end
        for i in range
            exon = t.exons[i]
            if exon.start_pos<=pos && exon.end_pos>=pos
                return Dict("gene"=>gene.name, "transcript"=>t.id, "type"=>"exon", "number"=>exon.number)
            elseif exon.start_pos>pos
                return Dict("gene"=>gene.name, "transcript"=>t.id, "type"=>"intron", "number"=>exon.number - 1)
            end
        end
    end
    return false
end
