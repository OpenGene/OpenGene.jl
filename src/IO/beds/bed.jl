"""
The simplest bed file only has three columns (chr, start, end), like:
```
chr1    11846100    11846483
chr1    11846810    11850969
chr1    11851220    11851402
chr1    11852290    11852468
chr1    11853920    11854179
```
"""

# read all records in a bed file
function bed_read_intervals(filename)
    records = Array{Interval}{1}()
    stream = opengene_open(filename, "r")
    # TODO: work around for readall missing in master
    if isdefined(Base, :readstring)
        text = readstring(stream)
    else
        text = readall(stream)
    end
    lines = split(text, "\n")
    for line in lines
        # remove Windows/Mac line breaks
        if startswith(line, "track")
            continue
        end
        str = strip(line, '\r')
        items = split(str, r"[\s\t]+")
        if length(items) < 3
            continue
        end
        chrom = items[1]
        chromstart = parse(Int, items[2])
        chromend = parse(Int, items[3])
        push!(records, Interval(chrom, chromstart, chromend))
    end
    return records
end

# write all records into a bed file
function bed_write_intervals(filename, records)
    stream = opengene_open(filename, "w")
    for r in records
        write(stream, r.chrom, "\t", string(r.chromstart), "\t", string(r.chromend), "\n")
    end
    close(stream)
end