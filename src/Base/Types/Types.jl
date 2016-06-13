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
	vcf_intersect,
	vcf_minus,
	vcf_merge,
	vcf_samples,
	vcf_filter,
	vcf_diff_genotype,
	vcf_split_sample,
	vcf_filter_region,
	parse_genotype,
	==,
	-,
	!,
	~,
	>,
	<,
	sort,
	sort!,
	+,
	*,
	-

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
	~,
	>,
	<,
	sort,
	sort!,
	+,
	*,
	-

if VERSION < v"0.5.0-"
    import Base:complement
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
