const DNA_SEQ = UInt8(0)
const RNA_SEQ = UInt8(1)
const AA_SEQ = UInt8(2)

type Sequence
	seq::ASCIIString
	seqtype::UInt8
end

Sequence(s::ASCIIString) = Sequence(s, DNA_SEQ)

Base.length(s::Sequence) = length(s.seq)
Base.getindex(s::Sequence, i::Int64) = getindex(s.seq, i)
Base.getindex(s::Sequence, r::UnitRange{Int64}) = Sequence(getindex(s.seq, r), s.seqtype)
Base.getindex(s::Sequence, indx::AbstractArray{Int64,1}) = Sequence(getindex(s.seq, indx), s.seqtype)
Base.reverse(s::Sequence) = Sequence(reverse(s.seq), s.seqtype)
Base.display(s::Sequence) = display_sequence(s)

function dna(str::ASCIIString)
	return Sequence(str, DNA_SEQ)
end

function rna(str::ASCIIString)
	return Sequence(str, RNA_SEQ)
end

function aa(str::ASCIIString)
	return Sequence(str, AA_SEQ)
end

const DNA_COMPLEMENT = Dict('A'=>'T', 'T'=>'A', 'C'=>'G', 'G'=>'C')

function complement(s::Sequence)
	if s.seqtype == AA_SEQ
		error("Amino acid sequence doesn't have reverse complement")
	end
	len = length(s)
	arr = Char[ifelse(s[i] in keys(DNA_COMPLEMENT), DNA_COMPLEMENT[s[i]], 'N') for i in 1:len]
	return Sequence(ASCIIString(arr), s.seqtype)
end

function reverse_complement(s::Sequence)
	if s.seqtype == AA_SEQ
		error("Amino acid sequence doesn't have reverse complement")
	end
	len = length(s)
	arr = Char[ifelse(s[len-i+1] in keys(DNA_COMPLEMENT), DNA_COMPLEMENT[s[len-i+1]], 'N') for i in 1:len]
	return Sequence(ASCIIString(arr), s.seqtype)
end

==(s1::Sequence, s2::Sequence) = (s1.seq == s2.seq) && (s1.seqtype == s2.seqtype)
-(s1::Sequence) = reverse(s1)
!(s1::Sequence) = complement(s1)
~(s1::Sequence) = reverse_complement(s1)

# because we may meet very long sequence
# it's better to display only the head and tail of sequence if it's very long
# if limit is set 0, then no limit is made, the whole sequence will be displayed
function display_sequence(s::Sequence, limit::Int64 = 100)
	const prefix = Dict(DNA_SEQ=>"dna", RNA_SEQ=>"rna", AA_SEQ=>"aa")
	str = prefix[s.seqtype] * "(\""
	len = length(s)
	if len <= limit || limit <= 0
		str = str * s.seq * "\")"
	else
		half = round(Int, limit/2)
		str = str * s.seq[1:half] * "......"
		str = str * s.seq[len-half:len] * "\")"
	end
	println(str)
end