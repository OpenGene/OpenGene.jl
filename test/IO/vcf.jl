function test_reading_vcf()
    vcf = vcf_read(joinpath(dirname(@__FILE__),"..","testdata","vcf","floats.vcf"))
    if version(vcf) != v"4.1.0"
        return false
    end
    return true
end

function test_vcf_operation()
    v1 = vcf_read(joinpath(dirname(@__FILE__),"..","testdata","vcf","cmp-test-a.vcf"))
    v2 = vcf_read(joinpath(dirname(@__FILE__),"..","testdata","vcf","cmp-test-b.vcf"))
    minus = v1 - v2
    intersect = v1 * v2
    return length(minus) == 1 && length(intersect) == length(v1)-1
end

@test test_reading_vcf()
@test test_vcf_operation()
