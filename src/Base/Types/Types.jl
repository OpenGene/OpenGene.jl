export Sequence,
	Quality,
	SeqRead,
	FastaRead,
	FastqRead,
	FastqPair,
	reverse,
	complement,
	reverse_complement,
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