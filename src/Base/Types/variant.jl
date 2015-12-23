
"""
Variant type is typically used to represent a record of VCF
See VCF spec:
VCF 4.1 http://samtools.github.io/hts-specs/VCFv4.1.pdf
VCF 4.2 http://samtools.github.io/hts-specs/VCFv4.2.pdf
"""
type Variant
    chrom::ASCIIString
    pos::Int64
    id::ASCIIString
    ref::ASCIIString
    alt::ASCIIString
    qual::ASCIIString
    filter::ASCIIString
    info::ASCIIString
    format::ASCIIString
end

"""
Initialize a variant
requires: #CHROM, POS, ID, REF, ALT
optionals: QUAL, FILTER, INFO, FORMAT
"""
function Variant(chrom::ASCIIString,pos::Int64,id::ASCIIString= ".",ref::ASCIIString=".",alt::ASCIIString=".";
        qual::ASCIIString="",filter::ASCIIString="",info::ASCIIString="",format::ASCIIString="")
    return Variant(chrom, pos, id, ref, alt, qual, filter, info, format)
end

"""
A meta information line of a VCF file
##reference=file:///seq/references/1000GenomesPilot-NCBI36.fasta
##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">
"""

function VcfHeader()
    return Dict{ASCIIString, Array{Any, 1}}()
end

function vcf_parse_prop(prop::ASCIIString)
    if !contains(prop, "=")
        return (false, false)
    end
    key, value = split(prop, "=")
    return (key.string, value.string)
end

function vcf_parse_meta(meta::ASCIIString)
    inner = rstrip(lstrip(meta, '<'), '>')
    if !startswith(meta, '<')
        return inner
    end
    propstrs = split(inner, ",")
    props = Dict{ASCIIString, Any}()
    for p in propstrs
        k, v = vcf_parse_prop(p.string)
        if v!= false
            props[k] = v
        end
    end
    return props
end

function vcf_add_meta(header, key::ASCIIString, meta::ASCIIString)
    props = vcf_parse_meta(meta)
    if key in keys(header)
        push!(header[key], props)
    else
        header[key] = Array{Any, 1}()
        push!(header[key], props)
    end
end


function vcf_add_meta_line(header, metaline::ASCIIString)
    if !startswith(metaline, "##")
        error("metaline should start with ##: $metaline")
        return false
    end
    pos = search(metaline, '=')
    if pos <= 0
        error("not a valid meta line: $metaline")
        return false
    end
    key = lstrip(metaline[1:pos-1], '#')
    meta = metaline[pos+1:length(metaline)]
    vcf_add_meta(header, key, meta)
end
