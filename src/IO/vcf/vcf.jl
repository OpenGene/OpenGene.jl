include("vcf_parser.jl")

# open a vcf stream, mode should be either r or w
function vcf_open(filename::AbstractString, mode::AbstractString="r")
    return opengene_open(filename, mode)
end

function vcf_read_header(stream::BufferedInputStream)
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