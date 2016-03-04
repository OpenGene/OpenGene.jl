function test_gencode()
    index = gencode_load("GRCh37")
    genes = gencode_locate(index, "chr1", 12300)
    if length(genes)==0
        return false
    end
    g = genes[1]
    if g["gene"]!="DDX11L1" || g["number"]!=1 || g["type"]!="intron"
        return false
    end
    genes = gencode_genes(index, "TP53")
    g = genes[1]
    if g.name!="TP53" || g.chr!="chr17" || g.start_pos!=7565097 || g.end_pos!=7590856
        return false
    end
    return true
end

@test test_gencode()