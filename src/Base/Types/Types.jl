export Sequence,
	Quality,
	SeqRead,
	FastaRead,
	FastqRead,
	reverse,
	==,
	-

import Base: convert,
	==,
	-

export DNA_SEQ,
	RNA_SEQ,
	AA_SEQ

include("sequence.jl")
include("quality.jl")
include("read.jl")