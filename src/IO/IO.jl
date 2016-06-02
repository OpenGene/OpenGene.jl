# Input/Output support for fasta/fastq/bam/sam/bed and other formats
# IO functions are provided as core featuers of OpenGene, so it is not inside a sub-module
# ===========

export opengene_open,
	fastq_open,
	fastq_read,
	fastq_write,
	fasta_open,
	fasta_read,
	fasta_write,
	FastqPairStream,
	fastq_open_pair,
	fastq_flush_pair,
	fastq_close_pair,
	fastq_read_pair,
	fastq_write_pair,
	bed_read_intervals,
	bed_write_intervals

export vcf_read,
	vcf_write,
	gtf_read,
	gtf_read_row,
	gtf_read_row!,
	gtf_write


include("common.jl")

# for every file format, we create a folder
include("fastq/fastq.jl")
include("fasta/fasta.jl")
include("beds/bed.jl")
include("vcf/vcf.jl")
include("gtf/gtf.jl")


