function gencode_dir()
    dir = joinpath(opengene_datadir(), "gencode")
    if !isdir(dir)
        mkpath(dir)
    end
    return dir
end
const gencode_releases = Dict(
    "grch37" => Dict(
        "localfile" => joinpath(gencode_dir(), "gencode.v19.annotation.gtf.gz"),
        "source" => "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz"
    ),
    "hg19" => Dict(
        "localfile" => joinpath(gencode_dir(), "gencode.v19.annotation.gtf.gz"),
        "source" => "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz"
    ),
    "grch38" => Dict(
        "localfile" => joinpath(gencode_dir(), "gencode.v24.annotation.gtf.gz"),
        "source" => "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_24/gencode.v24.annotation.gtf.gz"
    )
)