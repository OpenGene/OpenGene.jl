# Input/Output support for fasta/fastq/bam/sam/bed and other formats
# IO functions are provided as core featuers of OpenGene, so it is not inside a sub-module
# ===========

export fastq_open,
	fastq_read,
	fastq_write

include("common.jl")

# for every file format, we create a folder
include("fastq/fastq.jl")

