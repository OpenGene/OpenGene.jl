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

function union(v1::Vcf, v2::Vcf)
    if !issorted(v1)
        info("The first vcf is not sorted, sort it now")
        sort!(v1)
    end
    if !issorted(v2)
        info("The second vcf is not sorted, sort it now")
        sort!(v2)
    end
    result = nothing
end

Base.issorted(obj::Vcf) = vcf_issorted(obj)