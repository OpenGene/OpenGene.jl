function load_genome(assembly)
    if !haskey(human_genomes, assembly)
        error("$assembly is not supported, please use hg19/hg38")
    end

    # check if the assembly already exists
    folder = joinpath(genome_dir(), assembly)
    if isdir(folder) || !verify_human_genome_folder(folder)
        if !download_genome(assembly)
            error("Cannot download assembly $assembly")
        end
    end

    chr_folder = joinpath(folder, "chroms")
    chroms = readdir(chr_folder)
    genome = Dict{ASCIIString, FastaRead}()
    for chr in chroms
        chrname = replace(chr, ".fa", "")
        genome[chrname] = fasta_read(fasta_open(joinpath(chr_folder, chr)))
    end
    return genome
end