
using GZip

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
		return GZipStream
	else
		return IOStream
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

"the common open function to be used by other open files like fastq_open, bed_open"
function opengene_open(filename::AbstractString, mode::AbstractString="r")
	if !verify_openmode(mode)
		return false
	end
	# WAR to fix gz file reading issue of Libz
	# https://github.com/BioJulia/Libz.jl/issues/9
	if GZipStream == streamtype(filename, mode)
        return GZip.open(filename, mode)
	elseif contains(mode, "w")
        return open(filename, mode)
    else
        return open(filename, mode) |> streamtype(filename, mode)
	end
end

# write a dataframe without quote
function write_dataframe(stream, data::DataFrame)
    # we can use printtable function from DataFrames package if no quotemark printing is supported
    # like: printtable(stream,data,header=false, separator='\t', quotemark='\0')
    for i in 1:nrow(data)
        for j in 1:ncol(data)
            print(stream, data[i, j])
            if j<ncol(data)
                print(stream, "\t")
            else
                print(stream, "\n")
            end
        end
    end
end