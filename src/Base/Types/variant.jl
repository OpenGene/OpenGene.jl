
import DataStructures:OrderedDict

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

type VcfHeader
    metas::OrderedDict{ASCIIString, Array{Any, 1}}
    columns::Array{ASCIIString, 1}
    VcfHeader() = new(OrderedDict{ASCIIString, Array{Any, 1}}(), Array{ASCIIString, 1}())
end

type Vcf
    header::VcfHeader
    data::Array{Variant, 1}
end

function version(vcf::Vcf)
    if "fileformat" in keys(vcf.header.metas)
        vstr = replace(vcf.header.metas["fileformat"][1], "VCFv", "")
        return VersionNumber(vstr)
    else
        return VersionNumber(0)
    end
end

function var_lt(v1::Variant, v2::Variant)
    if v1.chrom < v2.chrom || (v1.chrom == v2.chrom && v1.pos < v2.pos)
        return true
    end
    return false
end

function var_gt(v1::Variant, v2::Variant)
    if v1.chrom > v2.chrom || (v1.chrom == v2.chrom && v1.pos > v2.pos)
        return true
    end
    return false
end

<(v1::Variant, v2::Variant) = var_lt(v1, v2)
>(v1::Variant, v2::Variant) = var_gt(v1, v2)
