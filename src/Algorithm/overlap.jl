
function distance_threshold(overlap_len)
    return min(6, overlap_len/10.0)
end

"""
calculate the overlap length of a pair of reads
"""
function overlap(r1::Sequence, r2::Sequence)
    len1 = length(r1)
    len2 = length(r2)
    reverse_r2 = ~r2

    overlapped = false
    overlap_len = 0
    offset = 0
    distance = 0
    # a match of less than 10 is considered as unconfident
    for offset = 0:len1-10
        # the overlap length of r1 & r2 when r2 is move right for offset
        overlap_len = min(len1-offset, len2)

        # remind that Julia is a 1-based coordination system
        distance = edit_distance(r1.seq[offset+1 : offset+overlap_len], reverse_r2.seq[1 : overlap_len])
        if distance <= distance_threshold(overlap_len)
            # now we find a good candidate
            # we verify it by moving r2 one more base to see if the distance is getting longer
            # if yes, then current is the best match, otherwise it's not
            next = offset + 1
            next_overlap_len = min(len1-next, len2)
            distance2 = edit_distance(r1.seq[next+1 : next+next_overlap_len], reverse_r2.seq[1 : next_overlap_len])
            if distance <= distance2
                overlapped = true
                break
            end
        end
    end

    if overlapped && offset == 0
        # check if distance can get smaller if offset goes negative
        # this only happens when insert DNA is shorter than sequencing read length, and some adapter/primer is sequenced but not trimmed cleanly
        # we go reversely
        for offset = 0:-1:-(len2-10)
            # the overlap length of r1 & r2 when r2 is move right for offset
            overlap_len = min(len1,  len2-abs(offset))
            distance = edit_distance(r1.seq[1:overlap_len], reverse_r2.seq[-offset + 1 : -offset + overlap_len])
            if distance <= distance_threshold(overlap_len)
                next = offset - 1
                next_overlap_len = min(len1,  len2-abs(next))
                distance2 = edit_distance(r1.seq[1:next_overlap_len], reverse_r2.seq[-next + 1 : -next + next_overlap_len])
                if distance <= distance2
                    return (offset, overlap_len, distance)
                end
            end
        end
    elseif overlapped
        return (offset, overlap_len, distance)
    end

    return (0,0,0)
end

function overlap(r1::FastqRead, r2::FastqRead)
    return overlap(r1.sequence, r2.sequence)
end

function overlap(pair::FastqPair)
    return overlap(pair.read1, pair.read2)
end

function simple_merge(r1::Sequence, r2::Sequence, overlap, offset = 0)
    reverse = ~r2
    if offset >= 0
        if overlap < length(r2)
            return Sequence(r1.seq * reverse.seq[overlap+1 : end])
        else
            return r1
        end
    else
        # offset is negative means insert DNA is shorter than read length
        # just shift the junk bases in the tail of r1
        return Sequence(r1.seq[1:overlap])
    end
end


function try_merge(r1::Sequence, r2::Sequence; distance_threshold = 2, overlap_threshold = 20)
    offset, overlap_len, distance = overlap(r1, r2)
    if overlap_len < overlap_threshold || distance > distance_threshold
        return false
    else
        return simple_merge(r1, r2, overlap_len, offset)
    end
end