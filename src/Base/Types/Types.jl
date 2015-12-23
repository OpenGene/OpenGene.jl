export Sequence,
	Quality,
	SeqRead,
	FastaRead,
	FastqRead,
	FastqPair,
	dna,
	rna,
	aa,
	reverse,
	complement,
	reverse_complement,
	display_sequence,
	display_fastq,
	display_fasta,
	display_fastq_pair,
	Interval,
	BED,
	Variant,
	==,
	-,
	!,
	~

export VcfHeader,
	vcf_add_meta_line,
	vcf_add_meta,
	vcf_parse_meta,
	vcf_parse_prop

import Base: convert,
        complement,
	==,
	-,
	!,
	~

export DNA_SEQ,
	RNA_SEQ,
	AA_SEQ

include("sequence.jl")
include("quality.jl")
include("read.jl")
include("interval.jl")
include("variant.jl")
