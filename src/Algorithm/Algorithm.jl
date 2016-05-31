module Algorithm

include("../compat.jl")

using OpenGene

export edit_distance,
    hamming_distance,
    overlap,
    simple_merge,
    try_merge

include("distance.jl")
include("overlap.jl")

end