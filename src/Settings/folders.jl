function opengene_homedir()
    dir = homedir() * "/.OpenGene"
    if !isdir(dir)
        try
            mkdir(dir)
        catch(e)
            error("Cannot create folder $dir")
        end
    end
    return dir
end

function opengene_datadir()
    dir = opengene_homedir() * "/data"
    if !isdir(dir)
        try
            mkdir(dir)
        catch(e)
            error("Cannot create folder $dir")
        end
    end
    return dir
end