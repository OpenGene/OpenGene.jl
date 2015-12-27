module SamBam

using Logging
@Logging.configure(level=DEBUG)

include("sam.jl")
include("header.jl")
include("bam.jl")
include("record.jl")
include("utils.jl")


end
