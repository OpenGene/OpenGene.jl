# dummy
function check_md5(file, hash)
    return true
end

function verify_human_genome_folder(folder, subdir)
    chr_folder = joinpath(folder, subdir)
    for chr in 1:22
        file = joinpath(chr_folder, "chr$chr.fa")
        if !isfile(file)
            return false
        end
    end
    other_chr = ["X", "Y"]
    for chr in other_chr
        file = joinpath(chr_folder, "chr$chr.fa")
        if !isfile(file)
            return false
        end
    end
    return true
end

function download_genome(assembly)
    if !haskey(human_genomes, assembly)
        error("$assembly is not supported, please use hg19/hg38")
    end

    fileinfo = human_genomes[assembly]

    # check if the assembly already exists
    folder = joinpath(genome_dir(), assembly)
    if isdir(folder)
        if verify_human_genome_folder(folder, fileinfo["subdir"])
            return true
        end
    end

    # download the reference
    if !isfile(fileinfo["localfile"]) || !check_md5(fileinfo["localfile"], fileinfo["md5"])
        info("start to download $assembly from " * fileinfo["source"])
        download(fileinfo["source"], fileinfo["localfile"]*".part")
        mv(fileinfo["localfile"]*".part", fileinfo["localfile"])
    end

    # check md5
    if !check_md5(fileinfo["localfile"], fileinfo["md5"])
        error("Failed to check MD5 integrity for " * fileinfo["localfile"])
    end

    # decompress
    mkpath(folder)
    gz = fileinfo["localfile"]
    info("decompressing...")
    run(`tar -xvzf $gz -C $folder`)

    if verify_human_genome_folder(folder, fileinfo["subdir"])
        return true
    else
        return false
    end
end