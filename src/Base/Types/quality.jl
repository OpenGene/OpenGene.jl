
type Quality
	qual::ASCIIString
end

Base.length(q::Quality) = length(q.qual)
Base.sizeof(q::Quality) = sizeof(q.qual)
Base.getindex(q::Quality, i::Int64) = getindex(q.qual, i)
Base.getindex(q::Quality, r::UnitRange{Int64}) = Quality(getindex(q.qual, r))
Base.getindex(q::Quality, indx::AbstractArray{Int64,1}) = Quality(getindex(q.qual, indx))