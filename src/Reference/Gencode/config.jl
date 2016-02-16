datadir = opengene_datadir()
const gencode_releases = Dict(
    "grch37" => Dict(
        "localfile" => "$datadir/gencode.v19.annotation.gtf.gz",
        "source" => "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz"
    ),
    "hg19" => Dict(
        "localfile" => "$datadir/gencode.v19.annotation.gtf.gz",
        "source" => "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz"
    ),
    "grch38" => Dict(
        "localefile" => "$datadir/gencode.v24.annotation.gtf.gz",
        "source" => "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_24/gencode.v24.annotation.gtf.gz"
    )
)