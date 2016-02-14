
export parse_gencode

"""
reference->chromosome dict->gene list->transcript list->exon list
"""
function parse_gencode(filename::AbstractString)
    index = Dict()
    gtf, stream = gtf_read(filename, loaddata = false)
    gene = Dict()
    transcript = Dict()
    while (row = gtf_read_row(stream)) != false
        if row.feature == "gene"
            gene = Dict()
            gene_id = strip(row.attributes["gene_id"], '"')
            gene["name"] = strip(row.attributes["gene_name"], '"')
            gene["id"] = gene_id
            gene["start"] = row.start_pos
            gene["end"] = row.end_pos
            gene["transcripts"] = []
            if !haskey(index, row.seqname)
                index[row.seqname] = []
            end
            push!(index[row.seqname], gene)
        elseif row.feature == "transcript"
            transcript = Dict()
            transcript_id = strip(row.attributes["transcript_id"], '"')
            transcript["id"] = transcript_id
            transcript["start"] = row.start_pos
            transcript["end"] = row.end_pos
            transcript["exons"] = []
            if !haskey(gene, "transcripts")
                println(gene)
                error("wrong format")
            end
            push!(gene["transcripts"], transcript)
        elseif row.feature == "exon"
            exon = Dict()
            exon_number = strip(row.attributes["exon_number"], '"')
            exon["name"] = strip(row.attributes["gene_name"], '"')
            exon["number"] = exon_number
            exon["start"] = row.start_pos
            exon["end"] = row.end_pos
            if !haskey(transcript, "exons")
                error("wrong format")
            end
            push!(transcript["exons"], exon)
        end
    end
    return index
end