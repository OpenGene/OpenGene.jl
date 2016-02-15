function gtf_parse_attributes(str::ASCIIString)
    attributes = OrderedDict{ASCIIString, ASCIIString}()
    items = split(str, ";")
    for item in items
        item = strip(item)
        pos = search(item, " ")
        if length(pos) == 0
            continue
        end
        pos = pos[1]
        if pos <= 0 || pos == length(item)
            continue
        end
        key = ASCIIString(item[1:pos-1])
        value = ASCIIString(item[pos+1:length(item)])
        key = strip(key)
        value = strip(value)
        if haskey(attributes, key)
            attributes[key] *= "/$value"
        else
            attributes[key] = value
        end
    end
    return attributes
end