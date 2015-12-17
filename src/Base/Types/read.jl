abstract SeqRead

type FastaRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
	strand::Char
end

type FastqRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
	strand::Char
	quality::Quality
end