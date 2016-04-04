
type Quality
	qual::ASCIIString
end

Base.length(q::Quality) = length(q.qual)
Base.sizeof(q::Quality) = sizeof(q.qual)
Base.getindex(q::Quality, i::Int64) = getindex(q.qual, i)
Base.getindex(q::Quality, r::UnitRange{Int64}) = Quality(getindex(q.qual, r))
Base.getindex(q::Quality, indx::AbstractArray{Int64,1}) = Quality(getindex(q.qual, indx))
Base.endof(q::Quality) = length(q)
Base.reverse(q::Quality) = Quality(reverse(q.qual))
==(s1::Quality, s2::Quality) = s1.qual == s2.qual
-(s1::Quality) = Quality(reverse(s1.qual))

function qual2num(q::Char)
    return UInt8(q) - 33
end

function num2qual(num::Int64)
    return Char(num+33)
end

function qual_str(q::Char)
    qnum = qual2num(q)
    str = "Q$qnum"
    return str
end

function qual_str(qual::ASCIIString)
    ret = ""
    for i in 1: length(qual)
        q = qual[i]
        if i > 1
            ret *= " "
        end
        ret *= qual_str(q)
    end
    return ret
end

function qual_str(qual::Quality)
    return qual_str(qual.qual)
end