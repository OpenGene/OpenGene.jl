module Algorithm

using OpenGene

export edit_distance,
    overlap

include("distance.jl")
include("overlap.jl")

end