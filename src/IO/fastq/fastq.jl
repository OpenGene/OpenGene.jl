
using Libz

function open_fastq(filename::AbstractString, mode::AbstractString="r")
	stream = open(filename, mode) |> ZlibInflateInputStream
	return stream
end