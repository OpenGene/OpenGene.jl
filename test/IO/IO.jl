
# compare FastqRead from gz files and not gz files
function test_gz_reading()
    data_dir = Pkg.dir("OpenGene") * "/test/testdata/fq/"
    # open the gz file
    gzstream = fastq_open(data_dir * "R1.fq.gz")
    # open the fq file, whose content is same as the gz file
    fqstream = fastq_open(data_dir * "R1.fq")

    while (fq = fastq_read(fqstream)) != false
        gzfq = fastq_read(gzstream)
        if fq.sequence != gzfq.sequence || fq.name != gzfq.name || fq.quality.qual != gzfq.quality.qual
            return false
        end
    end
    return true
end

@test test_gz_reading()