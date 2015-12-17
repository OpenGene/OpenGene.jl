
# get the format of a file
function get_format(filename::AbstractString)
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


function is_zipped(filename::AbstractString)
	return endswith(filename, ".gz") || endswith(filename, ".zip")
end