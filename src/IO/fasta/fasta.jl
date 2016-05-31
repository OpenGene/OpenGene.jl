
# open a fasta stream, mode should be either r or w
function fasta_open(filename::AbstractString, mode::AbstractString="r")
	return opengene_open(filename, mode)
end

# read the stream and return a fasta record
# \n will be stripped automatically
function fasta_read(stream)
	try
		if eof(stream)
			return false
		end
		#will get '>' for the first record, trim it
		line = readline(stream)
		while startswith(line, "#")
			line = readline(stream)
		end
		name = lstrip(rstrip(line,'\n'), '>')
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
function fasta_write(stream, fa::FastaRead, linesize = 50)
	try
		write(stream, ">", fa.name, "\n")
		len = length(fa.sequence)
		for i in 1:linesize:len
			write(stream, fa.sequence.seq[i:min(i+linesize-1, len)], "\n")
		end
	catch e
		println(e)
		return false
	end
end