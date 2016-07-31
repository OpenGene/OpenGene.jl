
# compare FastqRead from gz files and not gz files
function test_fastq_gz_reading()
    data_dir = joinpath(dirname(@__FILE__),"..","testdata","fq")
    # open the gz file
    gzstream = fastq_open(joinpath(data_dir, "R1.fq.gz"))
    # open the fq file, whose content is same as the gz file
    fqstream = fastq_open(joinpath(data_dir, "R1.fq"))

    while (fq = fastq_read(fqstream)) != false
        gzfq = fastq_read(gzstream)
        if fq.sequence != gzfq.sequence || fq.name != gzfq.name || fq.quality.qual != gzfq.quality.qual
            return false
        end
    end
    return true
end

function test_fastq_writing()
    data_dir = joinpath(dirname(@__FILE__),"..","testdata","fq")

    # open the fq file, whose content is same as the gz file
    instream = fastq_open(joinpath(data_dir, "R1.fq"))
    outstream = fastq_open(joinpath(data_dir, "R1.out.fq"), "w")

    while (fq = fastq_read(instream)) != false
        fastq_write(outstream, fq)
    end
    close(outstream)

    instream1 = fastq_open(joinpath(data_dir, "R1.fq"))
    instream2 = fastq_open(joinpath(data_dir, "R1.out.fq"))

    while (fq1 = fastq_read(instream1)) != false
        fq2 = fastq_read(instream2)
        if fq1.sequence != fq2.sequence || fq1.name != fq2.name || fq1.quality.qual != fq2.quality.qual
            return false
        end
    end

    rm(joinpath(data_dir, "R1.out.fq"))

    return true
end

@test test_fastq_gz_reading()
@test test_fastq_writing()

include("vcf.jl")
