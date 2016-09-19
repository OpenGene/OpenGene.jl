import SHA.sha1


function check_sha1(file, hash)
    info("checking SHA1...")
    f = open(file)
    filehash = sha1(f)
    # work around for SHA.sha1() incompatibility
    if isa(filehash, Array{UInt8,1})
        filehash = bytes2hex(filehash)
    end
    if lowercase(filehash) == lowercase(hash)
        info("SHA1 OK")
        return true
    else
        warn("wrong hash, expect $hash, but got $filehash")
        return false
    end
    return false
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

function download_assembly(assembly)
    if !haskey(human_genomes, assembly)
        error("$assembly is not supported, please use hg19/hg38")
    end

    fileinfo = human_genomes[assembly]

    # check if the assembly already exists
    folder = joinpath(assembly_dir(), assembly)
    if isdir(folder)
        if verify_human_genome_folder(folder, fileinfo["subdir"])
            return true
        end
    end

    # download the reference
    if !isfile(fileinfo["localfile"]) || !check_sha1(fileinfo["localfile"], fileinfo["sha1"])
        info("start to download $assembly from " * fileinfo["source"])
        download(fileinfo["source"], fileinfo["localfile"]*".part")
        mv(fileinfo["localfile"]*".part", fileinfo["localfile"])
        # check sha1
        if !check_sha1(fileinfo["localfile"], fileinfo["sha1"])
            error("Failed to check sha1 integrity for " * fileinfo["localfile"])
        end
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