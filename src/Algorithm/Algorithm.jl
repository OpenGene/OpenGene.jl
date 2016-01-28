module Algorithm

using OpenGene

export edit_distance,
    overlap,
    simple_merge,
    try_merge

include("distance.jl")
include("overlap.jl")

end