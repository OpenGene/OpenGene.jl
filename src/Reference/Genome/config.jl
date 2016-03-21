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
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz",
        "sha1" => "6d0f69febb2212af46920d170ac811f49b159e8e",
        "subdir" => "chroms"
    ),
    "hg19" => Dict(
        "localfile" => joinpath(genome_dir(), "hg19.chromFa.tar.gz"),
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz",
        "sha1" => "eae3720102935210a10c184d68e3024ce05b18a0",
        "subdir" => ""
    ),
)