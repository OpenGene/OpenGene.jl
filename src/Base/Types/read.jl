abstract SeqRead

type FastaRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
	strand::ASCIIString
end

type FastqRead <: SeqRead
	name::ASCIIString
	sequence::Sequence
	strand::ASCIIString
	quality::Quality
end