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

==(s1::Sequence, s2::Sequence) = (s1.seq == s2.seq) && (s1.seqtype == s2.seqtype)
-(s1::Sequence) = reverse(s1)