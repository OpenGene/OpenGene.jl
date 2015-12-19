
# open a fasta stream, mode should be either r or w
function fasta_open(filename::AbstractString, mode::AbstractString="r")
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

# read the stream and return a fasta record
# \n will be stripped automatically
function fasta_read(stream::BufferedInputStream)
	try
		if eof(stream)
			return false
		end
		#will get '>' for the first record, trim it
		name = lstrip(rstrip(readline(stream),'\n'), '>')
		seq = rstrip(readuntil(stream, '>'),'>')

		# remove the comments
		if contains(seq, "#")
			seq = replace(seq, r"#[^\n]*", "")
		end

		#remove line breaks
		seq = replace(seq, r"\r|\n", "")
		return FastaRead(name, Sequence(seq))
	catch e
		println(e)
		return false
	end
end

# write a fasta read to a stream
function fasta_write(stream::BufferedOutputStream, fa::FastaRead, linesize = 50)
	try
		write(stream, ">", fa.name, "\n")
		len = length(fa.sequence)
		for i in 1:linesize:len
			write(stream, fa.sequence.seq[i:min(i+linesize, len)], "\n")
		end
	catch e
		println(e)
		return false
	end
end