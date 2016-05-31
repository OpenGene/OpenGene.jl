export Sequence,
	Quality,
	qual2num,
	num2qual,
	qual_str,
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
	transcribe,
	display_sequence,
	display_fastq,
	display_fasta,
	display_fastq_pair,
	Interval,
	BED,
	Variant,
	version,
	==,
	-,
	!,
	~

export VcfHeader,
	Vcf,
	GtfHeader,
	GtfItem,
	GtfData,
	Gtf

import Base: convert,
	==,
	-,
	!,
	~

@static if VERSION < v"0.5.0-"
    import complement
end

export DNA_SEQ,
	RNA_SEQ,
	AA_SEQ

include("sequence.jl")
include("quality.jl")
include("read.jl")
include("interval.jl")
include("variant.jl")
include("gtf.jl")
