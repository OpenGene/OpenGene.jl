
# open a fastq stream, mode should be either r or w
function fastq_open(filename::AbstractString, mode::AbstractString="r")
	return opengene_open(filename, mode)
end

# read the stream and return a fastq record
# \n will be stripped automatically
function fastq_read(stream)
	try
		if eof(stream)
			return false
		end
		name = rstrip(readline(stream),'\n')
		sequence = Sequence(rstrip(readline(stream),'\n'))
		strand = rstrip(readline(stream),'\n')
		quality = Quality(rstrip(readline(stream),'\n'))
		return FastqRead(name, sequence, strand, quality)
	catch e
		println(e)
		return false
	end
end

# write a fastq read to a stream
function fastq_write(stream, fq::FastqRead)
	try
		strs = [fq.name, fq.sequence.seq, fq.strand, fq.quality.qual]
		write(stream, join(strs, "\n")*"\n")
	catch e
		println(e)
		return false
	end
end

# handle reading and writing for a pair<read1 + read2> of fastq files
type FastqPairStream
	read1stream
	read2stream
	iswrite::Bool
end

function fastq_flush_pair(s::FastqPairStream)
	if s.iswrite
		flush(s.read1stream)
		flush(s.read2stream)
	end
end

function fastq_close_pair(s::FastqPairStream)
	if s.iswrite
		close(s.read1stream)
		close(s.read2stream)
	end
end

function fastq_open_pair(filename1::AbstractString, filename2::AbstractString, mode::AbstractString="r")
	return FastqPairStream(fastq_open(filename1, mode), fastq_open(filename2, mode), contains(mode, "w"))
end

function fastq_read_pair(s::FastqPairStream)
	read1 = fastq_read(s.read1stream)
	read2 = fastq_read(s.read2stream)
	if read1 == false || read2 == false
		return false
	end
	return FastqPair(read1, read2)
end

function fastq_write_pair(s::FastqPairStream, pair::FastqPair)
	fastq_write(s.read1stream, pair.read1)
	fastq_write(s.read2stream, pair.read2)
end

Base.eof(stream::FastqPairStream) =  eof(stream.read1stream) || eof(stream.read2stream)
Base.flush(stream::FastqPairStream) = fastq_flush_pair(stream)
Base.close(stream::FastqPairStream) = fastq_close_pair(stream)
