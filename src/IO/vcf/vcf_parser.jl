
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
    columnline = lstrip(rstrip(columnline), '#')
    columns = split(columnline, "\t")
    for col in columns
        vcf_add_column(header, ASCIIString(col))
    end
end

vcf_add_column(header::VcfHeader, column::ASCIIString) = push!(header.columns, column)

function vcf_write_columns(stream, header::VcfHeader)
    write(stream, "#", join(header.columns, "\t"), "\n")
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
    start = 1
    inquote = false
    afterslash = false
    for i in 1:length(inner)
        if inner[i] == '\\'
            afterslash = true
            continue
        else
            afterslash = false
        end
        if inner[i]=='"' && !afterslash
            inquote = !inquote
        end
        if inner[i]==',' && !inquote
            k, v = vcf_parse_prop(inner[start:i-1])
            start = i + 1
            if v != false
                props[k] = v
            end
        end
    end
    # the last prop
    if start < length(inner)
        k, v = vcf_parse_prop(inner[start:length(inner)])
        if v != false
            props[k] = v
        end
    end
    return props
end

# parse ID=DP
function vcf_parse_prop(prop::ASCIIString)
    prop = strip(prop)
    if !contains(prop, "=")
        return (false, false)
    end
    key, value = split(prop, "=")
    return (ASCIIString(key), ASCIIString(value))
end

function vcf_write_metas(stream, header::VcfHeader)
    for (key, meta) in header.metas
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

function vcf_parse_data_line(line, has_format, separator='\t')
    items = split(line, separator)
    if length(items) < 8
        return false
    end
    chrom = items[1]
    pos = parse(Int64, items[2])
    id = items[3]
    ref = items[4]
    alt = items[5]
    qual = items[6]
    filter = items[7]
    info = items[8]
    format = ""
    if length(items) >= 9
        if has_format
            format = items[9]
            samples_start = 10
        end
    end
    samples = ASCIIString[]
    for s = samples_start:length(items)
        push!(samples, items[s])
    end
    return Variant(chrom, pos, id, ref, alt, qual, filter, info, format, samples)
end
