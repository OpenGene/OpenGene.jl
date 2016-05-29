function sort!(obj::Vcf)
    sort!(obj.data)
    return obj
end

function sort(obj::Vcf)
    data = sort(obj.data)
    header = deepcopy(obj.header)
    return Vcf(header, data)
end

function union(obj1::Vcf, obj2::Vcf)

end
