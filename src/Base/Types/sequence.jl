const DNA_SEQ = UInt8(0)
const RNA_SEQ = UInt8(1)
const AA_SEQ = UInt8(2)

const DNA_ALPHABET = ['A', 'T', 'C', 'G', 'N']
# for convinience, include 'C' in RNA alphabet
const RNA_ALPHABET = ['A', 'T', 'C', 'G', 'U', 'N']
const DNA_COMPLEMENT = Dict('A'=>'T', 'T'=>'A', 'C'=>'G', 'G'=>'C', 'N'=>'N', 'n'=>'n', 'a'=>'t', 't'=>'a', 'c'=>'g', 'g'=>'c')

type Sequence
	seq::ASCIIString
	seqtype::UInt8
end

Sequence(s::ASCIIString) = Sequence(s, DNA_SEQ)

Base.length(s::Sequence) = length(s.seq)
Base.getindex(s::Sequence, i::Int64) = getindex(s.seq, i)
Base.getindex(s::Sequence, r::UnitRange{Int64}) = Sequence(getindex(s.seq, r), s.seqtype)
Base.getindex(s::Sequence, indx::AbstractArray{Int64,1}) = Sequence(getindex(s.seq, indx), s.seqtype)
Base.endof(s::Sequence) = length(s)
Base.reverse(s::Sequence) = Sequence(reverse(s.seq), s.seqtype)
Base.display(s::Sequence) = display_sequence(s)
Base.print(s::Sequence) = display_sequence(s)

function dna(str::ASCIIString)
	ret = validate_sequence(str, DNA_ALPHABET)
	if ret > 0
		error("Unsupported DNA nucleotide symbol at pos $ret, value:", str[ret])
	end
	return Sequence(str, DNA_SEQ)
end

function rna(str::ASCIIString)
	ret = validate_sequence(str, RNA_ALPHABET)
	if ret > 0
		error("Unsupported RNA nucleotide symbol at pos $ret, value:", str[ret])
	end
	return Sequence(str, RNA_SEQ)
end

function aa(str::ASCIIString)
	return Sequence(str, AA_SEQ)
end

function validate_sequence(str::ASCIIString, alphabet)
	for i in 1:length(str)
		if !(uppercase(str[i]) in alphabet)
			return i
		end
	end
	return 0
end

function complement(s::Sequence)
	if s.seqtype == AA_SEQ
		error("Amino acid sequence doesn't have reverse complement")
	end
	len = length(s)
	arr = Char['N' for i in 1:len]
	for i in 1:len
		if haskey(DNA_COMPLEMENT, s[i])
			arr[i] = DNA_COMPLEMENT[s[i]]
		end
	end
	return Sequence(ASCIIString(arr), s.seqtype)
end

function reverse_complement(s::Sequence)
	if s.seqtype == AA_SEQ
		error("Amino acid sequence doesn't have reverse complement")
	end
	len = length(s)
	arr = Char['N' for i in 1:len]
	for i in 1:len
		if haskey(DNA_COMPLEMENT, s[len-i+1])
			arr[i] = DNA_COMPLEMENT[s[len-i+1]]
		end
	end
	return Sequence(ASCIIString(arr), s.seqtype)
end

function transcribe(s::Sequence)
	if s.seqtype != DNA_SEQ
		error("Only DNA sequence can be transcribed")
	end
	len = length(s)
	arr = Char[s.seq[i] for i in 1:len]
	for i in 1:len
		if s[i] == 'T'
			arr[i] = 'U'
		end
	end
	return rna(ASCIIString(arr))
end

==(s1::Sequence, s2::Sequence) = (s1.seq == s2.seq) && (s1.seqtype == s2.seqtype)
-(s1::Sequence) = reverse(s1)
!(s1::Sequence) = complement(s1)
~(s1::Sequence) = reverse_complement(s1)

# because we may meet very long sequence
# it's better to display only the head and tail of sequence if it's very long
# if limit is set 0, then no limit is made, the whole sequence will be displayed
function display_sequence(s::Sequence, limit::Int64 = 1000)
	const prefix = Dict(DNA_SEQ=>"dna", RNA_SEQ=>"rna", AA_SEQ=>"aa")
	len = length(s)
	str = prefix[s.seqtype]*":"
	if len <= limit || limit <= 0
		str = str * s.seq
	else
		show = min(500, round(Int, limit/2))
		str = str * s.seq[1:show] * "......"
		str = str * s.seq[len-show:len]
	end
	println(str)
end