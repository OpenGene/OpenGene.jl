
immutable HeaderRecord{T}
    rec_type::Array{UInt8,1}
    # not sure
    tags::Array{Array{UInt8,1},1}

    function HeaderRecord(rec_type)
        tags = Array{Array{UInt8,1},1}()
        new(rec_type, tags)
    end

    function push_tag!(header_record::HeaderRecord,tag,value)
        push!(header_record.tags, into_bytes(String(value)))
    end

    
end

immutable Header
    records::Array{Array{UInt8,1},1}

    function header()
        empty_records = Array{Array{UInt8,1},1}()
        new(empty_records)
    end
    
    function push_record!(header::Header, record::HeaderRecord)
        byte_record = to_bytes(record)
        push!(header.records, byte_record)
    end

end



function to_bytes(record::Header)
    throw("Not Implemented!")
end
    
function to_bytes(record::HeaderRecord)
    throw("Not Implemented!")
end

