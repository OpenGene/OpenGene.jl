
immutable Reader
    bgzf::Struct_BGZF
    header::HeaderView

    function Reader(path::AbstractString)
        bgzf = bgzf_open(path, "r")
        header = bam_hdr_read(bgzf)
        new(bgzf,header)
    end
    function pileup_read(data,record::Bam1_t)
        error()
    end
    # there is a for Reader iterator not implemented here.
end


function bam_read(read::Read, record::Record)
    error()
end
function records(read::Read)
    error()
end
function pipleup(read::Read)
    error()
end
function bgzf(read::Read)
    error()
end

function drop(read::Reader)
    error()
end

immutable IndexedReader
    bgzf::Struct_BGZF
    header::HeaderView
    idx::hts_idx_t
    itr::hts_itr_t

    function IndexedReader(path)
        error()
    end
    function seek(idx_reader::IndexedReader,tid::UInt32,st::UInt32,ed::UInt32)
        error()
    end
    function pileup_read(data,record::Bam1_t)
        error()
    end
    # iterator for loop IndexReader not implemented
OBend

function drop(idx_reader::IndexedReader)
    error()
end

immutable Writer
    f::Struct_BGZF
    header::HeaderView

    function Writer(path,header::Header)
        error()
    end
    function writh_template(template,path)
        error()
    end
    function write(writer::Writer,record::Record)
        error()
    end
end
function drop(writer::Writer)
    error()
end
@enum ReadError Truncated Invalid NoMoreRecord end
@enum IndexError InvalidIndex InvalidPath end
@enum BGZFError InvalidPath end

function bgzf_open(path, mode)
    error()
end
function itr_next(bgzf,itr,record)
    error()
end

immutable HeaderView
    inner::bam_hdr_t
    
    function HeaderView(inner)
        new(inner)
    end
    function inner(hdr_view::HeaderView)
       error()
    end
    function tid(hdr_view::HeaderView,name::UInt8)
        error()
    end
    function target_count(hdr_view::HeaderView)
        hdr_view.inner().n_targets #data type
    end
    function target_names(hdr_view::HeaderView)
        error()
    end
    function target_len(hdr_view::HeaderView)
        error()
    end
end
