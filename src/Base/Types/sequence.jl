const DNA_SEQ = UInt8(0)
const RNA_SEQ = UInt8(1)
const AA_SEQ = UInt8(2)

type Sequence
	seq::ASCIIString
	seqtype::UInt8
end

Sequence(s::ASCIIString) = Sequence(s, DNA_SEQ)

Base.length(s::Sequence) = length(s.seq)
Base.sizeof(s::Sequence) = sizeof(s.seq)
Base.getindex(s::Sequence, i::Int64) = getindex(s.seq, i)
Base.getindex(s::Sequence, r::UnitRange{Int64}) = Sequence(getindex(s.seq, r), s.seqtype)
Base.getindex(s::Sequence, indx::AbstractArray{Int64,1}) = Sequence(getindex(s.seq, indx), s.seqtype)
Base.reverse(s::Sequence) = Sequence(reverse(s.seq), s.seqtype)

const DNA_COMPLEMENT = Dict('A'=>'T', 'T'=>'A', 'C'=>'G', 'G'=>'C')

function reverse_complement(s::Sequence)
	if s.seqtype == AA_SEQ
		error("Amino acid sequence doesn't have reverse complement")
	end
	len = length(s)
	arr = Char[ifelse(s[i] in keys(DNA_COMPLEMENT), DNA_COMPLEMENT[s[i]], 'N') for i in 1:len]
	return Sequence(ASCIIString(arr), s.seqtype)
end

==(s1::Sequence, s2::Sequence) = (s1.seq == s2.seq) && (s1.seqtype == s2.seqtype)
-(s1::Sequence) = reverse(s1)
~(s1::Sequence) = reverse_complement(s1)