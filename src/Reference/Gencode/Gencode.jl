
immutable GencodeExon
    number::Int32
    start_pos::Int64
    end_pos::Int64
end

type GencodeTranscript
    id::ASCIIString
    start_pos::Int64
    end_pos::Int64
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
            transcript = GencodeTranscript(transcript_id, row.start_pos, row.end_pos, Array{GencodeExon, 1}())
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