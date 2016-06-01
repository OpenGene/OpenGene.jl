function sort!(obj::Vcf)
    sort!(obj.data)
    return obj
end

function sort(obj::Vcf)
    data = sort(obj.data)
    header = deepcopy(obj.header)
    return Vcf(header, data)
end

function vcf_issorted(obj::Vcf)
    df = obj.data
    nrows = size(df, 1)
    for i in 1:nrows-1
        if df[i, 1] > df[i+1, 1] || (df[i, 1] == df[i+1, 1] && df[i, 2] > df[i+1, 2])
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