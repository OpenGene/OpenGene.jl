include("vcf_parser.jl")
include("vcf_operation.jl")

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
    df = readtable(stream, separator = '\t', header=false)

    # update names of the dataframe
    colnames = [symbol(col) for col in hd.columns]
    names!(df, colnames)
    return Vcf(hd, df)
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
vcf_write_data(stream, data::DataFrame) = write_dataframe(stream, data)
