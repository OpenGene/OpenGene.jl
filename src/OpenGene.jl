module OpenGene


# all code in Base should have no code dependency on others
include("Base/Base.jl")

# IO code should only depend on Base
include("IO/IO.jl")

end # module
