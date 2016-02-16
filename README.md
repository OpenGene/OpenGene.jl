# OpenGene

[![Build Status](https://travis-ci.org/OpenGene/OpenGene.jl.svg?branch=master)](https://travis-ci.org/OpenGene/OpenGene.jl)
[![Coverage Status](https://coveralls.io/repos/OpenGene/OpenGene.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/OpenGene/OpenGene.jl?branch=master)

`OpenGene.jl` project aims to provide basic functions and rich utilities to analyze sequencing data, with the beautiful language `Julia`   

This project is just started and it need more bioinformaticians to contribute. If you want to be an author of OpenGene, please open an issue, or make a pull request.

## Add OpenGene
```julia
# run on Julia REPL
Pkg.add("OpenGene")
```
If you want to pull the latest dev version of OpenGene
```julia
Pkg.clone("git://github.com/OpenGene/OpenGene.jl.git")

# you can build it to accelerate the loading (optional)
Pkg.build("OpenGene")
```

This project is under active developing, remember to update it to get newest features:
```julia
Pkg.checkout("OpenGene")
```
## Examples
***read/write a single fastq/fasta file***
```julia
using OpenGene

istream = fastq_open("input.fastq.gz")
ostream = fastq_open("output.fastq.gz","w")

# fastq_read will return an object FastqRead {name, sequence, strand, quality}
# fastq_write can write a FastqRead into a ouput stream
while (fq = fastq_read(istream))!=false
    fastq_write(ostream, fq)
end

close(ostream)
```
fasta is supported similarly with `fasta_open`, `fasta_read` and `fasta_write`   

***read/write a pair of fastq files***
```julia
using OpenGene

istream = fastq_open_pair("R1.fastq.gz", "R2.fastq.gz")
ostream = fastq_open_pair("Out.R1.fastq.gz","Out.R2.fastq.gz","w")

# fastq_read_pair will return a pair of FastqRead {read1, read2}
# fastq_write_pair can write this pair to two files
while (pair = fastq_read_pair(istream))!=false
    fastq_write_pair(ostream, pair)
end

close(ostream)
```

***read/write a bed file***
```julia
using OpenGene

# read all records, return an array of Intervals(chrom, chromstart, chromend)
intervals = bed_read_intervals("in.bed")
# write all records
bed_write_intervals("out.bed",intervals)
```

***read/write a VCF***
```julia
using OpenGene

# load the entire VCF data into a vcf object, which has a .header field and a .data field
vcfobj = vcf_read("in.vcf")
# write the vcf object into a file
vcf_write("out.vcf", vcfobj)
```

***read/write a GTF***
```julia
using OpenGene

# load the gtf header and data
gtfobj = gtf_read("in.gtf")

# write the gtf object into a file
gtf_write("out.gtf", gtfobj)

# if the file is too big, use following to load header only
gtfobj, stream = gtf_read("in.gtf", loaddata = false)
while (row = gtf_read_row(stream)) != false
    # do something with row ...
end
```

***locate the gene/exon/intron***
```julia
using OpenGene, OpenGene.Reference

# load the gencode dataset, it will download a file from gencode website if it not downloaded before
# once it's loaded, it will be cached so future loads will be fast
index = gencode_load("GRCh37")

# locate which gene chr:pos is in
gencode_locate(index, "chr5", 149526621)
# it will return
# 1-element Array{Any,1}:
#  Dict{ASCIIString,Any}("gene"=>"PDGFRB","number"=>1,"transcript"=>"ENST00000261799.4","type"=>"intron")
```
