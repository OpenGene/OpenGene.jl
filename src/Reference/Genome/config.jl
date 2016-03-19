datadir = opengene_datadir()
const human_genomes = Dict(
    "hg38" => Dict(
        "localfile" => "$datadir/hg38.chromFa.tar.gz",
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz"
    ),
    "hg19" => Dict(
        "localfile" => "$datadir/hg19.chromFa.tar.gz",
        "source" => "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/chromFa.tar.gz"
    ),
)