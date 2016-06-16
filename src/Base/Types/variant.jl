
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
    samples::Array{ASCIIString, 1}
end

"""
Initialize a variant
requires: #CHROM, POS, ID, REF, ALT
optionals: QUAL, FILTER, INFO, FORMAT
"""
function Variant(chrom::ASCIIString,pos::Int64,id::ASCIIString= ".",ref::ASCIIString=".",alt::ASCIIString=".";
        qual::ASCIIString="",filter::ASCIIString="",info::ASCIIString="",format::ASCIIString="", samples::Array{ASCIIString, 1}=Array{ASCIIString, 1}())
    return Variant(chrom, pos, id, ref, alt, qual, filter, info, format, samples)
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

function vcf_has_format_column(hd::VcfHeader)
    return haskey(hd.metas, "FORMAT")
end

function vcf_has_format_column(vcf::Vcf)
    return vcf_has_format_column(vcf.header)
end

function vcf_samples(vcf::Vcf)
    samples = Array{ASCIIString, 1}()
    columns = vcf.header.columns
    const tags = [ "CHROM", "CHROM", "POS", "ID","REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT"]
    for c in columns
        if !(c in tags)
            push!(samples, c)
        end
    end
    return samples
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
    if v1.chrom < v2.chrom || (v1.chrom == v2.chrom && v1.pos < v2.pos)# || (v1.chrom == v2.chrom && v1.pos == v2.pos && v1.id < v2.id)
        return true
    end
    return false
end

function var_gt(v1::Variant, v2::Variant)
    if v1.chrom > v2.chrom || (v1.chrom == v2.chrom && v1.pos > v2.pos)# || (v1.chrom == v2.chrom && v1.pos == v2.pos && v1.id > v2.id)
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
        #info("The first vcf is not sorted, sort it now")
        sort!(v1)
    end
    if !issorted(v2)
        #info("The second vcf is not sorted, sort it now")
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

function vcf_intersect(v1::Vcf, v2::Vcf)
    if !issorted(v1)
        #info("The first vcf is not sorted, sort it now")
        sort!(v1)
    end
    if !issorted(v2)
        #info("The second vcf is not sorted, sort it now")
        sort!(v2)
    end
    result = Array{Variant, 1}()
    i = 1
    j = 1
    while i<=length(v1.data) && j<=length(v2.data)
        if v1.data[i] < v2.data[j]
            i += 1
        elseif v1.data[i] > v2.data[j]
            j += 1
        else
            if v1.data[i].ref == v2.data[j].ref && v1.data[i].alt == v2.data[j].alt
                push!(result, v1.data[i])
            end
            i += 1
            j += 1
        end
    end
    # use header only from v1
    header = deepcopy(v1.header)
    return Vcf(header, result)
end

function vcf_minus(v1::Vcf, v2::Vcf)
    common = v1 * v2
    result = Array{Variant, 1}()
    i = 1
    j = 1
    while i<=length(v1.data)
        if j > length(common.data)
            push!(result, v1.data[i])
            i += 1
            continue
        end
        if v1.data[i] < common.data[j]
            push!(result, v1.data[i])
            i += 1
        elseif v1.data[i] > common.data[j]
            j += 1
        else
            if v1.data[i].ref != common.data[j].ref || v1.data[i].alt != common.data[j].alt
                push!(result, v1.data[i])
            end
            i += 1
        end
    end
    # use header only from v1
    header = deepcopy(v1.header)
    return Vcf(header, result)
end

function parse_genotype(sample_str::ASCIIString, format::ASCIIString)
    metas = split(format, ":")
    gt_pos = -1
    ad_pos = -1
    rd_pos = -1
    for i in 1:length(metas)
        if metas[i] == "GT"
            gt_pos = i
        elseif metas[i] == "AD"
            ad_pos = i
        elseif metas[i] == "RD"
            rd_pos = i
        end
    end
    if gt_pos == -1 || ad_pos == -1
        error("GT or AD is not present in FORMAT")
    end
    values = split(sample_str, ":")
    gt = values[gt_pos]
    if gt == "./."
        return gt, -1, -1
    end
    ad = split(values[ad_pos], ",")
    ref_num = 0
    alt_num = 0
    if length(ad)<2
        # GT:GQ:DP:RD:AD:FREQ:DP4
        if rd_pos == -1
            error("ref depth is not given neithger by AD nor RD")
        end
        ref_num = parse(Int64, strip(values[rd_pos]))
        alt_num = parse(Int64, strip(ad[1]))
    else
        # "GT:AD:DP:GQ:PL"
        ref_num = parse(Int64, strip(ad[1]))
        alt_num = parse(Int64, strip(ad[2]))
    end
    return gt, ref_num, alt_num
end

function vcf_filter(vcf::Vcf; total_depth=0, allele_depth=0, allele_freq=0.0, sample="")
    if !vcf_has_format_column(vcf)
        error("This VCF doesn't have a FORMAT column")
    end
    all_samples = vcf_samples(vcf)
    if length(all_samples)==0
        error("This VCF doesn't have any sample column")
    end
    if sample==""
        sample=all_samples[1]
    elseif !(sample in all_samples)
        error("This VCF doesn't have sample $sample")
    end
    # sample index
    s = 1
    for i=1:length(all_samples)
        if all_samples[i] == sample
            s = i
            break
        end
    end
    good = Variant[]
    bad = Variant[]
    # GT:AD:DP:GQ:PL    0/1:37,14:51:99:111,0,614
    ad_pos = 2
    for v in vcf.data
        gt, ref_num, alt_num = parse_genotype(v.samples[s], v.format)
        total_num = ref_num + alt_num
        alt_freq = float(alt_num)/float(total_num)
        if total_num >= total_depth && alt_num >= allele_depth && alt_freq >= allele_freq
            push!(good, deepcopy(v))
        else
            push!(bad, deepcopy(v))
        end
    end
    good_vcf = Vcf(deepcopy(vcf.header), good)
    bad_vcf = Vcf(deepcopy(vcf.header), bad)
    return good_vcf, bad_vcf
end

# a region is a string like chr1:13579-2312332
function vcf_filter_region(vcf::Vcf, regions::Array{ASCIIString, 1})
    parsed_regions = []
    for r in regions
        items = split(r, ":")
        if length(items) != 2
            warn("error format of region, should be like chr1:13579-2312332")
            continue
        end
        chr = items[1]
        pos = split(items[2], "-")
        start_pos = parse(Int, pos[1])
        end_pos = start_pos
        if length(pos) > 1
            end_pos = parse(Int, pos[2])
        end
        push!(parsed_regions, (chr, start_pos, end_pos))
    end
    good = Variant[]
    bad = Variant[]
    for v in vcf.data
        found = false
        for (chr, start_pos, end_pos) in parsed_regions
            if v.chrom == chr && v.pos >= start_pos && v.pos <= end_pos
                found = true
                break
            end
        end
        new_var = deepcopy(v)
        if found
            push!(good, new_var)
        else
            push!(bad, new_var)
        end
    end
    good_vcf = Vcf(deepcopy(vcf.header), good)
    bad_vcf = Vcf(deepcopy(vcf.header), bad)
    return good_vcf, bad_vcf
end

# a region is like chr1:13579-2312332;chr3:132229-4533233
function vcf_filter_region(vcf::Vcf, regions::ASCIIString)
    splitted_regions = ASCIIString[]
    for r in split(regions, ";")
        push!(splitted_regions, ASCIIString(r))
    end
    return vcf_filter_region(vcf, splitted_regions)
end

function vcf_diff_genotype(v1::Vcf, v2::Vcf, v1_sample_id = 1, v2_sample_id = 1)
    if !issorted(v1)
        #info("The first vcf is not sorted, sort it now")
        sort!(v1)
    end
    if !issorted(v2)
        #info("The second vcf is not sorted, sort it now")
        sort!(v2)
    end
    if v1_sample_id > length(vcf_samples(v1))
        error("Wrong v1_sample_id")
    elseif v2_sample_id > length(vcf_samples(v2))
        error("Wrong v2_sample_id")
    end
    v1_diff = Variant[]
    v2_diff = Variant[]
    common = v1 * v2
    v1_common = v1 * common
    v2_common = v2 * common
    if length(v1_common) != length(v2_common)
        error("length(v1_common) != length(v2_common)")
    end
    for i in 1:length(v1_common)
        gt1, ref_num1, alt_num1 = parse_genotype(v1_common.data[i].samples[v1_sample_id], v1_common.data[i].format)
        gt2, ref_num2, alt_num2 = parse_genotype(v2_common.data[i].samples[v2_sample_id], v2_common.data[i].format)
        if gt1 != gt2
            push!(v1_diff, deepcopy(v1_common.data[i]))
            push!(v2_diff, deepcopy(v2_common.data[i]))
        end
    end
    return Vcf(deepcopy(v1.header), v1_diff), Vcf(deepcopy(v2.header), v2_diff)
end

function vcf_split_sample(vcf::Vcf)
    samples = vcf_samples(vcf)
    const tags = [ "CHROM", "CHROM", "POS", "ID","REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT"]
    columns_without_sample = ASCIIString[]
    for c in vcf.header.columns
        if (c in tags)
            push!(columns_without_sample, c)
        end
    end
    splitted = Vcf[]
    for s in samples
        header = deepcopy(vcf.header)
        columns = deepcopy(columns_without_sample)
        push!(columns, s)
        header.columns = columns
        data = Variant[]
        push!(splitted, Vcf(header, data))
    end
    for v in vcf.data
        for s in 1:length(samples)
            gt, ref_num, alt_num = parse_genotype(v.samples[s], v.format)
            if gt != "./." && gt != "0/0"
                var = deepcopy(v)
                var.samples = ASCIIString[]
                push!(var.samples, v.samples[s])
                push!(splitted[s].data, var)
            end
        end
    end
    return splitted
end

+(v1::Vcf, v2::Vcf) = vcf_merge(v1, v2)
-(v1::Vcf, v2::Vcf) = vcf_minus(v1, v2)
*(v1::Vcf, v2::Vcf) = vcf_intersect(v1, v2)

Base.issorted(obj::Vcf) = vcf_issorted(obj)
Base.merge(v1::Vcf, v2::Vcf) = vcf_merge(v1, v2)
Base.length(v::Vcf) = length(v.data)
Base.getindex(obj::Vcf, i::Int64) = getindex(obj.data, i)

