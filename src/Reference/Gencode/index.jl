const GENCODE_INDEX_VER = 2

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
    chr::ASCIIString
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
function gencode_load(ref::ASCIIString)
    ref = lowercase(ref)
    if !haskey(gencode_releases, ref)
        error("$ref is not supported in current gencode releases, please use one of grch37/grch38, or hg19:")
    end
    source = gencode_releases[ref]["source"]
    localfile = gencode_releases[ref]["localfile"]
    if !isfile(localfile)
        println("# gencode dataset is not downloaded, download it now...")
        try
            download(source, localfile * ".part")
            mv(localfile * ".part", localfile)
        catch(e)
            error("Failed to download gencode reference from $source, please manually download it and put it at $localfile")
        end
    end
    return gencode_load_file(localfile)
end

function gencode_load_file(filename::AbstractString)
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
            gene = GencodeGene(gene_name, row.seqname, gene_id, row.start_pos, row.end_pos, row.strand, row.attributes, Array{GencodeTranscript, 1}())
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
