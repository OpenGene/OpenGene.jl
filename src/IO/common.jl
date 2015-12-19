
using Libz
import BufferedStreams:
	BufferedInputStream,
	BufferedOutputStream

# get the format of a file
function getformat(filename::AbstractString)
	format_extensions = Dict(
			"fastq"=>["fastq", "fq", "fastq.gz", "fq.gz", "fastq.zip", "fq.zip"],
			"fasta"=>["fasta", "fa", "fasta.gz", "fa.gz", "fasta.zip", "fa.zip"],
			"sam"=>["sam", "sam.gz", "sam.zip"],
			"bam"=>["bam"],
			"bed"=>["bed", "bed.gz", "bed.zip"]
		)
	for (format, extensions) in format_extensions
		for ext in extensions
			if endswith(filename, "." * ext)
				return format
			end
		end
	end
	#no format match, return unknown
	return "unknown"
end


function iszipped(filename::AbstractString)
	return endswith(filename, ".gz") || endswith(filename, ".zip")
end

# detect the stream type by its filename and mode
function streamtype(filename::AbstractString, mode::AbstractString)
	if iszipped(filename)
		return contains(mode, "r")?ZlibInflateInputStream:ZlibDeflateOutputStream
	else
		return contains(mode, "r")?BufferedInputStream:BufferedOutputStream
	end
end

function verify_openmode(mode::AbstractString)
	if contains(mode, "r") && contains(mode, "w")
		error("Open mode cannot be both read(r) and write(w)")
		return false
	elseif !contains(mode, "r") && !contains(mode, "w")
		error("No write(w) or read(r) mode specified")
		return false
	else
		return true
	end
end