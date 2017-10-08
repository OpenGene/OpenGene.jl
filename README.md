# OpenGene

`OpenGene.jl` project aims to provide basic functions and rich utilities to analyze sequencing data, with the beautiful language [Julia](http://julialang.org/)   

If you want to be an author of OpenGene, please open an issue, or make a pull request.  

If you are looking for BAM/SAM read/write, see [OpenGene/HTSLIB](https://github.com/OpenGene/HTSLIB.jl)  
Bug reports and feature requests, please [file an issue](https://github.com/OpenGene/OpenGene.jl/issues/new)

## Julia
Julia is a fresh programming language with `C/C++` like performance and `Python` like simple usage  
On Ubuntu, you can install Julia by `sudo apt-get install julia`, and type `julia` to open Julia interactive prompt. Details to install Julia is at [platform specific instructions](http://julialang.org/downloads/platform.html).

## Add OpenGene
```julia
# run on Julia REPL
Pkg.add("OpenGene")
```
If you want to get the latest dev version of OpenGene (not for beginners)
```julia
Pkg.checkout("OpenGene")
```

This project is under active developing, remember to update it to get newest features:
```julia
Pkg.update()
```
## Examples
***sequence operation***
```julia
julia> using OpenGene

julia> seq = dna("AAATTTCCCGGGATCGATCGATCG")
dna:AAATTTCCCGGGATCGATCGATCG
# reverse complement operator
julia> ~seq
dna:CGATCGATCGATCCCGGGAAATTT
# transcribiton, note that seq is treated as coding sequence, not template sequence
# so this operation only changes T to U
julia> transcribe(seq)
rna:CGAUCGAUCGAUCCCGGGAAAUUU
```

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

***VCF Operations***
```julia
using OpenGene

v1 = vcf_read("v1.vcf")
v2 = vcf_read("v2.vcf")

# merge by positions
v_merge = v1 + v2

# intersect by positions
v_intersect = v1 * v2

# remove v2 records from v1, by positions
v_minus = v1 - v2
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

# load the gencode dataset, it will download a file from gencode website if it's not downloaded before
# once it's loaded, it will be cached so future loads will be fast
index = gencode_load("GRCh37")

# locate which gene chr:pos is in
gencode_locate(index, "chr5", 149526621)
# it will return
# 1-element Array{Any,1}:
#  Dict{ASCIIString,Any}("gene"=>"PDGFRB","number"=>1,"transcript"=>"ENST00000261799.4","type"=>"intron")
genes = gencode_genes(index, "TP53")
# return an array with only one record
genes[1].name, genes[1].chr, genes[1].start_pos, genes[1].end_pos
# ("TP53","chr17",7565097,7590856)
```

***access assembly (hg19/hg38)***
```julia
julia> using OpenGene

julia> using OpenGene.Reference

julia> hg19 = load_assembly("hg19")
# Dict{ASCIIString,OpenGene.FastaRead} with 93 entries:

julia> hg19["chr17"]
# >chr17
# dna:AAGCTTCTCACCCTGTTCCTGCATAGATAATTGCATGACA......agggtgtgggtgtgggtgtgggtgtgggtgtggtgtgtgggtgtgggtgtgGT

julia> hg19["chr17"].sequence[1:100]
# dna:AAGCTTCTCACCCTGTTCCTGCATAGATAATTGCATGACAATTGCCTTGTCCCTGCTGAATGTGCTCTGGGGTCTCTGGGGTCTCACCCACGACCAACTC
```
***merge a pair of reads from pair-end sequencing***
```julia
julia> using OpenGene, OpenGene.Algorithm

julia> r1=dna("TTTAGGCCTGTCACTGTGAACGCTATCAGCAAGCCTTTGCATGATTTTTCTCTTTCCCACTCCTACATTCTCGGTGATGACAACAACTGTAGCCTGATCCAGATATTTCGAAGTGCAACAAATCGTATTCAATATAGAGTAAGG")
dna:TTTAGGCCTGTCACTGTGAACGCTATCAGCAAGCCTTTGCATGATTTTTCTCTTTCCCACTCCTACATTCTCGGTGATGACAACAACTGTAGCCTGATCCAGATATTTCGAAGTGCAACAAATCGTATTCAATATAGAGTAAGG

julia> r2=dna("GTTAGCTATTACTGTAATCACCGCGAGACAAGTTAATGAGAGAGTTATTCATAAAACTTACTCTATATTGAATACGATTTGTAGCACATCGAAATATCTGGATCAGGCTACAGTTGTAGTCATCACCGAGAATGTAGGAGTGG")
dna:GTTAGCTATTACTGTAATCACCGCGAGACAAGTTAATGAGAGAGTTATTCATAAAACTTACTCTATATTGAATACGATTTGTAGCACATCGAAATATCTGGATCAGGCTACAGTTGTAGTCATCACCGAGAATGTAGGAGTGG

julia> offset, overlap_len, distance = overlap(r1, r2)
(56,88,4)

julia> merged = simple_merge(r1, r2, overlap_len)
dna:TTTAGGCCTGTCACTGTGAACGCTATCAGCAAGCCTTTGCATGATTTTTCTCTTTCCCACTCCTACATTCTCGGTGATGACAACAACTGTAGCCTGATCCAGATATTTCGAAGTGCAACAAATCGTATTCAATATAGAGTAAGGTTTATGAATAACTCTCTCATTAACTTGTCTCGCGGTGATTACAGTAATAGCTAAC
```
