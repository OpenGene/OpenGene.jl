
# open a fastq stream, mode should be either r or w
function fastq_open(filename::AbstractString, mode::AbstractString="r")
	if !verify_openmode(mode)
		return false
	end
	# WAR to fix gz file reading issue of Libz
	# https://github.com/BioJulia/Libz.jl/issues/9
	if ZlibInflateInputStream == streamtype(filename, mode)
		return ZlibInflateInputStream(open(filename, mode), reset_on_end=true)
	else
		return open(filename, mode) |> streamtype(filename, mode)
	end
end

# read the stream and return a fastq record
# \n will be stripped automatically
function fastq_read(stream::BufferedInputStream)
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
function fastq_write(stream::BufferedOutputStream, fq::FastqRead)
	try
		strs = [fq.name, fq.sequence.seq, fq.strand, fq.quality.qual]
		write(stream, join(strs, "\n")*"\n")
	catch e
		println(e)
		return false
	end
end

