# OpenGene

[![Build Status](https://travis-ci.org/OpenGene/OpenGene.jl.svg?branch=master)](https://travis-ci.org/OpenGene/OpenGene.jl)

`OpenGene.jl` project aims to provide basic functions and rich utilities to analyze sequencing data, with the beautiful language `Julia`   

This project is just started and it need more bioinformaticians to contribute. If you want to be an author of OpenGene, please open an issue, or make a pull request.

## Add OpenGene
This project hasn't been registered in Julia METADATA.jl, so if you want to use it, do:
```julia
Pkg.clone("git://github.com/OpenGene/OpenGene.jl.git")

# you can build it to accelerate the loading (optional)
Pkg.build("OpenGene")
```

This project is under active developing, remember to update it to get newest features:
```julia
Pkg.update()
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
