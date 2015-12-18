# OpenGene

[![Build Status](https://travis-ci.org/OpenGene/OpenGene.jl.svg?branch=master)](https://travis-ci.org/OpenGene/OpenGene.jl)

`OpenGene.jl` project aims to provide basic functions and rich utilities to analyze sequencing data, with the beautiful language `Julia`   

This project is just started and it need more bioinformaticians to contribute. If you want to be an author of OpenGene, please open an issue, or make a pull request.

## Add OpenGene
This project hasn't been registered in Julia METADATA.jl, so if you want to use it, do:
```julia
Pkg.clone("git://github.com/OpenGene/OpenGene.jl.git")
```

## Example
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