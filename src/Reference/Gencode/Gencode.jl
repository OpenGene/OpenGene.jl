
export parse_gencode

"""
reference->chromosome dict->gene list->transcript list->exon list
"""
function parse_gencode(filename::AbstractString)
    index = Dict()
    gtf, stream = gtf_read(filename, loaddata = false)
    while (row = gtf_read_row(stream)) != false
        if row.feature == "gene"
            gene_id = strip(row.attributes["gene_id"], '"')
            gene = Dict()
            gene["name"] = strip(row.attributes["gene_name"], '"')
            gene["start"] = row.start_pos
            gene["end"] = row.end_pos
            if !haskey(index, row.seqname)
                index[row.seqname] = []
            end
            push!(index[row.seqname], gene)
        end
    end
    return index
end