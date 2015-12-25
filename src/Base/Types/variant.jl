
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
    data::DataFrame
end
