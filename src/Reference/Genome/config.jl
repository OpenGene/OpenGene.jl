function assembly_dir()
    dir = joinpath(opengene_datadir(), "assembly")
    if !isdir(dir)
        mkpath(dir)
    end
    return dir
end

const human_genomes = Dict(
    "hg38" => Dict(
        "localfile" => joinpath(assembly_dir(), "hg38.chromFa.tar.gz"),
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz",
        "sha1" => "f459b51d6440f7342f3ddb38c33a1f945ded7cf2",
        "subdir" => "chroms"
    ),
    "hg19" => Dict(
        "localfile" => joinpath(assembly_dir(), "hg19.chromFa.tar.gz"),
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz",
        "sha1" => "eae3720102935210a10c184d68e3024ce05b18a0",
        "subdir" => ""
    ),
)