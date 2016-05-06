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

"""
read1 and read2 of a FastqPair are considered with different directions
"""
type FastqPair
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

Base.length(read::SeqRead) = length(read.sequence)

Base.getindex(read::FastqRead, i::Int64) = (getindex(read.sequence, i), getindex(read.quality, i))
Base.getindex(read::FastqRead, r::UnitRange{Int64}) = FastqRead(read.name, getindex(read.sequence, r), read.strand, getindex(read.quality, r))
Base.getindex(read::FastqRead, indx::AbstractArray{Int64,1}) = FastqRead(read.name, getindex(read.sequence, indx), read.strand, getindex(read.quality, indx))
Base.reverse(read::FastqRead) = FastqRead(read.name, reverse(read.sequence), read.strand, reverse(read.quality))
complement(read::FastqRead) = FastqRead(read.name, complement(read.sequence), read.strand, read.quality)
reverse_complement(read::FastqRead) = FastqRead(read.name, reverse_complement(read.sequence), read.strand, reverse(read.quality))
Base.display(read::FastqRead) = display_fastq(read)

Base.getindex(read::FastaRead, i::Int64) = getindex(read.sequence, i)
Base.getindex(read::FastaRead, r::UnitRange{Int64}) = FastaRead(read.name, getindex(read.sequence, r))
Base.getindex(read::FastaRead, indx::AbstractArray{Int64,1}) = FastaRead(read.name, getindex(read.sequence, indx))
Base.reverse(read::FastaRead) = FastaRead(read.name, reverse(read.sequence))
complement(read::FastaRead) = FastaRead(read.name, complement(read.sequence))
reverse_complement(read::FastaRead) = FastaRead(read.name, reverse_complement(read.sequence))
Base.display(read::FastaRead) = display_fasta(read)

Base.display(pair::FastqPair) = display_fastq_pair(pair)

-(read::FastqRead) = reverse(read)
!(read::FastqRead) = complement(read)
~(read::FastqRead) = reverse_complement(read)
-(read::FastaRead) = reverse(read)
!(read::FastaRead) = complement(read)
~(read::FastaRead) = reverse_complement(read)

function display_fasta(read::FastaRead)
	println(">" * read.name)
	display_sequence(read.sequence)
end

function display_fastq(read::FastqRead)
	println(read.name)
	println(read.sequence.seq)
	println(read.strand)
	println(read.quality.qual)
end

function display_fastq_pair(pair::FastqPair)
	println("----Read #1----")
	display_fastq(pair.read1)
	println("----Read #2----")
	display_fastq(pair.read2)
end