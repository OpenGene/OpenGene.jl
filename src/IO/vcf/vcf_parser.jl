
import DataStructures:OrderedDict

"""
A column line is TAB separated, and is started with a single '#CHROM'
#CHROM  POS ID  REF ALT QUAL    FILTER  INFO    FORMAT  A   B   C   D
"""
function vcf_add_column_line(header::VcfHeader, columnline::ASCIIString)
    if !startswith(columnline, "#CHROM")
        error("column line should start with #CHROM: $columnline")
        return false
    end
    columnline = rstrip(columnline)
    columns = split(columnline, "\t")
    for col in columns
        vcf_add_column(header, ASCIIString(col))
    end
end

vcf_add_column(header::VcfHeader, column::ASCIIString) = push!(header.columns, column)

function vcf_write_columns(stream::BufferedOutputStream, header::VcfHeader)
    write(stream, join(header.columns, "\t"), "\n")
end

"""
A meta information line of a VCF file is started with ##
##reference=file:///seq/references/1000GenomesPilot-NCBI36.fasta
##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">
"""
function vcf_add_meta_line(header::VcfHeader, metaline::ASCIIString)
    if !startswith(metaline, "##")
        error("metaline should start with ##: $metaline")
        return false
    end
    metaline = rstrip(metaline)
    pos = search(metaline, '=')
    if pos <= 0
        error("not a valid meta line: $metaline")
        return false
    end
    key = lstrip(metaline[1:pos-1], '#')
    meta = metaline[pos+1:length(metaline)]
    vcf_add_meta(header, key, meta)
end

function vcf_add_meta(header::VcfHeader, key::ASCIIString, meta::ASCIIString)
    props = vcf_parse_meta(meta)
    if key in keys(header.metas)
        push!(header.metas[key], props)
    else
        header.metas[key] = Array{Any, 1}()
        push!(header.metas[key], props)
    end
end


# parse: <ID=DP,Number=1,Type=Integer,Description="Read Depth">
function vcf_parse_meta(meta::ASCIIString)
    inner = rstrip(lstrip(meta, '<'), '>')
    if !startswith(meta, '<')
        return inner
    end
    propstrs = split(inner, ",")
    props = OrderedDict{ASCIIString, Any}()
    for p in propstrs
        k, v = vcf_parse_prop(ASCIIString(p))
        if v!= false
            props[k] = v
        end
    end
    return props
end

# parse ID=DP
function vcf_parse_prop(prop::ASCIIString)
    if !contains(prop, "=")
        return (false, false)
    end
    key, value = split(prop, "=")
    return (ASCIIString(key), ASCIIString(value))
end

function vcf_write_metas(stream::BufferedOutputStream, header::VcfHeader)
    for (key, meta) in header.metas
        println(key)
        println(meta)
        for meta_props in meta
            line = vcf_make_line(key, meta_props)
            write(stream, line)
        end
    end
end

function vcf_make_line(key::ASCIIString, meta_props)
    # single value line
    # like: ##fileformat=VCFv4.0
    if typeof(meta_props)<:AbstractString
        return "##$key=$meta_props\n"
    end

    line = "##$key=<"
    for (k,v) in meta_props
        line *= "$k=$v,"
    end
    line = rstrip(line,',') * ">\n"
    return line
end
