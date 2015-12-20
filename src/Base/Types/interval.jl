# ref to http://www.genome.ucsc.edu/FAQ/FAQformat.html#format1.8

type Interval
    chrom::ASCIIString
    chromstart::Int
    chromend::Int
end

type BED
    interval::Interval
    score::Int
    strand::ASCIIString
    thickstart::Int
    thickend::Int
    itemrgb::ASCIIString
    blockcount::Int
    blocksizes::Array{Int}
    blockstarts::Array{Int}
end