
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
    if v1.chrom < v2.chrom || (v1.chrom == v2.chrom && v1.pos < v2.pos) || (v1.chrom == v2.chrom && v1.pos == v2.pos && v1.id < v2.id)
        return true
    end
    return false
end

function var_gt(v1::Variant, v2::Variant)
    if v1.chrom > v2.chrom || (v1.chrom == v2.chrom && v1.pos == v2.pos && v1.id > v2.id)
        return true
    end
    return false
end

<(v1::Variant, v2::Variant) = var_lt(v1, v2)
>(v1::Variant, v2::Variant) = var_gt(v1, v2)

function sort!(obj::Vcf)
    data = sort(obj.data, lt = <)
    obj.data = data
    return obj
end

function sort(obj::Vcf)
    data = sort(obj.data, lt=var_comp)
    header = deepcopy(obj.header)
    return Vcf(header, data)
end

function vcf_issorted(obj::Vcf)
    data = obj.data
    for i in 1:length(data)-1
        v1 = data[i]
        v2 = data[i+1]
        if v1 > v2
            return false
        end
    end
    return true
end

function vcf_merge(v1::Vcf, v2::Vcf)
    if !issorted(v1)
        info("The first vcf is not sorted, sort it now")
        sort!(v1)
    end
    if !issorted(v2)
        info("The second vcf is not sorted, sort it now")
        sort!(v2)
    end
    result = Array{Variant, 1}()
    i = 1
    j = 1
    last_push = nothing
    while i<=length(v1.data) || j<=length(v2.data)
        take_v1 = true
        if i>length(v1.data)
            take_v1 = false
        elseif j>length(v2.data)
            take_v1 = true
        else
            if v1.data[i] < v2.data[j]
                take_v1 = true
            elseif v1.data[i] > v2.data[j]
                take_v1 = false
            else
                # same position, check if they are identical
                if v1.data[i].ref != v2.data[j].ref || v1.data[i].alt != v2.data[j].alt
                    warn("mismatch discarded at ", v1.data[i].chrom, ":", v1.data[i].pos, " ", v1.data[i].ref, "-->", v1.data[i].alt, " vs ", v2.data[j].ref, "-->", v2.data[j].alt)
                    i += 1
                    j += 1
                    continue
                else
                    # if identical, only take the one from v1, and skip this one from v2
                    take_v1 = true
                    j += 1
                end
            end
        end
        if take_v1
            if last_push == nothing || last_push < v1.data[i]
                push!(result, v1.data[i])
                last_push = v1.data[i]
            end
            i += 1
        else
            if last_push == nothing || last_push < v2.data[j]
                push!(result, v2.data[j])
                last_push = v2.data[j]
            end
            j += 1
        end
    end
    # use header only from v1
    header = deepcopy(v1.header)
    return Vcf(header, result)
end

+(v1::Vcf, v2::Vcf) = vcf_merge(v1, v2)

Base.issorted(obj::Vcf) = vcf_issorted(obj)
Base.merge(v1::Vcf, v2::Vcf) = vcf_merge(v1, v2)

