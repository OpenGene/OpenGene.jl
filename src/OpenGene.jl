module OpenGene

##############################################################################
##
## Dependencies
##
##############################################################################

using DataFrames

# all code in Base should have no code dependency on others
include("Base/Base.jl")

# Settings
include("Settings/Settings.jl")

# IO code should only depend on Base
include("IO/IO.jl")

# module OpenGene.Algorithm
include("Algorithm/Algorithm.jl")

# module OpenGene.Reference
include("Reference/Reference.jl")

include("utils/print.jl")

end # module
