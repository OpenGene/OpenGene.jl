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