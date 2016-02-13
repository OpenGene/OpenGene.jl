function test_reading_vcf()
    vcf = vcf_read(Pkg.dir("OpenGene" * "/test/testdata/vcf/floats.vcf"))
    if version(vcf) != v"4.1.0"
        return false
    end
    return true
end

@test test_reading_vcf()