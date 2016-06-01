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

function union(obj1::Vcf, obj2::Vcf)

end

Base.issorted(obj::Vcf) = vcf_issorted(obj)