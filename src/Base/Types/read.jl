abstract SeqRead

type FastaRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
end

type FastqRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
	strand::ASCIIString
	quality::Quality
end

type FastqPair
	# read1 and read2 are considered as different directions
	read1::FastqRead
	read2::FastqRead

	# template length, if it's not calculated, it is set as -1
	template_length::Int
	# overlap length, if it's not calculated, it is set as -1
	overlap_length::Int
end

function FastqPair(read1::FastqRead, read2::FastqRead)
	return FastqPair(read1, read2, -1, -1)
end