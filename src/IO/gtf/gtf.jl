include("gtf_parser.jl")

# open a gtf stream, mode should be either r or w
function gtf_open(filename::AbstractString, mode::AbstractString="r")
    return opengene_open(filename, mode)
end

gtf_close(stream) = close(stream)

"""
Write a Gtf object into a file
Gtf data field is tab-separated
"""
function gtf_write(filename::AbstractString, obj::Gtf)
    stream = gtf_open(filename, "w")
    if stream == false
        return false
    end
    gtf_write_header(stream, obj.header)
    gtf_write_data(stream, obj.data)
    close(stream)
end

"""
Load a GTF file as a DataFrame
"""
function gtf_read(filename::AbstractString; loaddata = true)
    stream = gtf_open(filename)
    if stream == false
        return false
    end
    hd = gtf_read_header(stream)
    hd_rows = length(hd)

    # reopen the file
    # and skip the header to read contents
    stream = gtf_open(filename)
    skipped = 0
    while skipped < hd_rows
        readline(stream)
        skipped += 1
    end

    # if loaddata is set true, then only return the gtf object
    # else also return the stream
    if loaddata
        data = gtf_read_data(stream)
        return return Gtf(hd, data)
    else
        data = GtfData()
        return Gtf(hd, data), stream
    end
end

# read a row from a gtf stream, and just return it
function gtf_read_row(stream)
    if eof(stream)
        return false
    end
    line = readline(stream)
    gtfitem = make_gtf_row(line)
    return gtfitem
end

# read a row from a gtf stream, and write it into the gtf struct
function gtf_read_row!(gtf::Gtf, stream)
    if eof(stream)
        return false
    end
    line = readline(stream)
    gtfitem = make_gtf_row(line)
    if gtfitem != false
        push!(gtf.data, gtfitem)
    end
    return gtfitem
end

function gtf_read_data(stream)
    data = GtfData()
    while true
        if eof(stream)
            return data
        end
        line = readline(stream)
        gtfitem = make_gtf_row(line)
        if gtfitem != false
            push!(data, gtfitem)
        end
    end
    return data
end

function make_gtf_row(line)
    line = rstrip(line, '\n')
    items = split(line, "\t")
    if length(items) < 9
        return false
    end
    seqname = items[1]
    source = items[2]
    feature = items[3]
    start_pos = parse(Int64,items[4])
    end_pos = parse(Int64,items[5])
    score = items[6]
    strand = items[7]
    frame = items[8]
    attributes = gtf_parse_attributes(ASCIIString(items[9]))
    gtfitem = GtfItem(seqname, source, feature, start_pos, end_pos, score, strand, frame, attributes)
    return gtfitem
end

function gtf_read_header(stream)
    header = GtfHeader()
    while true
        if eof(stream)
            return header
        end
        line = readline(stream)
        if startswith(line, "##")
            line = lstrip(rstrip(line, '\n'), '#')
            items = split(line, ":")
            if length(items) < 2
                continue
            end
            key = strip(items[1], ' ')
            value = strip(items[2], ' ')
            header[key] = value
        else
            break
        end
    end
    return header
end

# write a gtf header to a file
function gtf_write_header(stream, header::GtfHeader)
    try
        for (k, v) in header
            print(stream, "##", k, ": ", v, "\n")
        end
    catch e
        warn(e)
        return false
    end
end

# write gtf data field into stream
function gtf_write_data(stream, data::GtfData)
    for item in data
        print(stream, item.seqname, "\t")
        print(stream, item.source, "\t")
        print(stream, item.feature, "\t")
        print(stream, item.start_pos, "\t")
        print(stream, item.end_pos, "\t")
        print(stream, item.score, "\t")
        print(stream, item.strand, "\t")
        print(stream, item.frame, "\t")
        gtf_print_attributes(item.attributes, stream)
        print(stream, "\n")
    end
end

function gtf_print_attributes(attributes, stream)
    i = 0
    for (key, value) in attributes
        vars = split(value, "/")
        for v in 1:length(vars)
            var = vars[v]
            print(stream, "$key $var;")
            if v < length(vars)
                print(stream, "  ")
            end
        end
        i += 1
        if i < length(attributes)
            print(stream, "  ")
        end
    end
end
