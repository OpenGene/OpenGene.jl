# open a gtf stream, mode should be either r or w
function gtf_open(filename::AbstractString, mode::AbstractString="r")
    return opengene_open(filename, mode)
end

gtf_close(stream::BufferedOutputStream) = close(stream)

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
function gtf_read(filename::AbstractString)
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

    df = readtable(stream, separator = '\t', header=false)

    return Gtf(hd, df)
end

function gtf_read_header(stream::BufferedInputStream)
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
function gtf_write_header(stream::BufferedOutputStream, header::GtfHeader)
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
gtf_write_data(stream::BufferedOutputStream, data::DataFrame) = write_dataframe(stream, data)