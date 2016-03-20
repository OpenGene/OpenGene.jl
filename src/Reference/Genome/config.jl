function genome_dir()
    dir = joinpath(opengene_datadir(), "genome")
    if !isdir(dir)
        mkpath(dir)
    end
    return dir
end

const human_genomes = Dict(
    "hg38" => Dict(
        "localfile" => joinpath(genome_dir(), "hg38.chromFa.tar.gz"),
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz"
    ),
    "hg19" => Dict(
        "localfile" => joinpath(genome_dir(), "hg19.chromFa.tar.gz"),
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz"
    ),
)