
using Libz

import BufferedStreams.BufferedInputStream

function fastq_read(stream::BufferedInputStream)
	try
		name = ASCIIString(rstrip(readline(stream),'\n'))
		sequence = Sequence(rstrip(readline(stream),'\n'))
		strand = readline(stream)[1]
		quality = Quality(rstrip(readline(stream),'\n'))
		return FastqRead(name, sequence, strand, quality)
	catch
		return false
	end
end

function fastq_open_zip(filename::AbstractString, mode::AbstractString="r")
	stream = open(filename, mode) |> ZlibInflateInputStream
	return stream
end

function fastq_open(filename::AbstractString, mode::AbstractString="r")
	if is_zipped(filename)
		return fastq_open_zip(filename, mode)
	end
	stream = open(filename, mode) |> BufferedInputStream
	return stream
end