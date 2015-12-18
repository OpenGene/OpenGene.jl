

type Sequence
	seq::ASCIIString
end

Base.length(s::Sequence) = length(s.seq)
Base.sizeof(s::Sequence) = sizeof(s.seq)
Base.getindex(s::Sequence, i::Int64) = getindex(s.seq, i)
#Base.getindex(s::Sequence, r::Array{T,1}) = getindex(s.seq, r)
Base.getindex(s::Sequence, r::UnitRange{Int64}) = Sequence(getindex(s.seq, r))
Base.getindex(s::Sequence, indx::AbstractArray{Int64,1}) = Sequence(getindex(s.seq, indx))