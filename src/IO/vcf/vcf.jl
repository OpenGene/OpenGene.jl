include("vcf_parser.jl")

"""
Load a VCF file into a Vcf object
A Vcf object has .header and a .data field
.data field is stored as a DataFrame
"""
function vcf_read(filename::AbstractString)
    stream = vcf_open(filename)
    if stream == false
        return false
    end
    hd = vcf_read_header(stream)
    data = vcf_read_data(stream, vcf_has_format_column(hd), '\t')

    return Vcf(hd, data)
end

"""
Write a Vcf object into a file
Vcf data field is tab-separated
"""
function vcf_write(filename::AbstractString, obj::Vcf)
    stream = vcf_open(filename, "w")
    if stream == false
        return false
    end
    vcf_write_header(stream, obj.header)
    vcf_write_data(stream, obj.data)
    close(stream)
end

function vcf_read_data(stream, has_format, separator = '\t')
    data = Variant[]
    while(true)
        try
            if eof(stream)
                return data
            end
            line = rstrip(readline(stream),'\n')
            var = vcf_parse_data_line(line, has_format, separator)
            if var == false
                continue
            end
            push!(data, var)
        catch e
            println(e)
            return data
        end
    end
end

# open a vcf stream, mode should be either r or w
function vcf_open(filename::AbstractString, mode::AbstractString="r")
    return opengene_open(filename, mode)
end

vcf_close(stream) = close(stream)

function vcf_read_header(stream)
    header = VcfHeader()
    while true
        if eof(stream)
            return header
        end
        line = readline(stream)
        if startswith(line, "##")
            vcf_add_meta_line(header, line)
        elseif startswith(line, "#CHROM")
            vcf_add_column_line(header, line)
            return header
        else
            error("VCF column header is not found, column header line is started with #CHROM")
            return false
        end
    end
end

# write a vcf header to a file
function vcf_write_header(stream, header::VcfHeader)
    try
        vcf_write_metas(stream, header)
        vcf_write_columns(stream, header)
    catch e
        println(e)
        return false
    end
end

# write vcf data field into stream
function vcf_write_data(stream, data)
    has_format = false
    for d in data
        if d.format != ""
            has_format = true
            break
        end
    end
    for d in data
        write(stream, d.chrom)
        write(stream, '\t', string(d.pos))
        write(stream, '\t', d.id)
        write(stream, '\t', d.ref)
        write(stream, '\t', d.alt)
        write(stream, '\t', d.qual)
        write(stream, '\t', d.filter)
        write(stream, '\t', d.info)
        if has_format
            write(stream, '\t', d.format)
        end
        for s in d.samples
            write(stream, '\t', s)
        end
        write(stream, '\n')
    end
end

