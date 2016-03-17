
"""
A simple implementation of calculating edit distance of two strings
"""
function edit_distance(s1::ASCIIString, s2::ASCIIString)
    m=length(s1)+1
    n=length(s2)+1
    i=0
    j=0
    tbl = Array{Int64}(m,n)
    for i=1:m
        tbl[i,1]=i-1
    end
    for j=1:n
        tbl[1,j]=j-1
    end
    for i=2:m
        for j=2:n
            cost = s1[i-1] == s2[j-1]?0:1
            tbl[i,j] = min(tbl[i, j-1]+1, tbl[i-1, j]+1, tbl[i-1, j-1]+cost)
        end
    end
    return tbl[i,j]
end

function hamming_distance(s1::ASCIIString, s2::ASCIIString)
    d = 0
    len = min(length(s1), length(s2))
    for i in 1:len
        if s1[i] != s2[i]
            d += 1
        end
    end
    return d
end

function edit_distance(s1::Sequence, s2::Sequence)
    return edit_distance(s1.seq, s2.seq)
end

function hamming_distance(s1::Sequence, s2::Sequence)
    return hamming_distance(s1.seq, s2.seq)
end