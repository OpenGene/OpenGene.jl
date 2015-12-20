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
	Interval,
	BED,
	==,
	-,
	!,
	~

import Base: convert,
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