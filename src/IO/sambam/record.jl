
#BAM record
immutable Record
    inner::bam1_t
    own::Bool

    function Record()
        inner = bam_init1()
        inner.m_data = 0
        new(inner, true)
    end
    function from_inner(inner::bam1_t)
        new(inner,false)
    end
    # series flag! not implemented as lack of macro flag
end

function data(record::Record)
    from_raw_parts(record.inner.data, record.inner.l_data)
end
function tid(record::Record)
    record.inner.core.tid
end
function set_tid!(record::Record,tid::Int32)
    record.inner.tid = tid
end
function pos(record::Record)
    record.inner.core.pos
end
function set_pos!(record::Record, pos::Int32)
    record.inner.core.pos = pos
end
function bin(record::Record)
    record.inner.core.bin
end
function set_bin!(record::Record, bin::UInt16)
    record.inner.core.bin = bin
end
function mapq(record::Record)
    record.inner.core.qual
end
function set_mapq!(record::Record,mapq::UInt8)
    record.inner.qual = mapq
end
function flags(record::Record)
    record.inner.core.flag
end
function set_flags!(record::Record, flags)
    record.inner.core.flag = flags
end
function unset_flags!(record::Record)
    record.inner.core.flag = 0
end
function mtid(record::Record)
    record.inner.core.mtid
end
function set_mtid!(record::Record,mtid::Int32)
    record.inner.core.mtid = mtid
end
function mpos(record::Record)
    record.inner.core.mpos
end
function set_mpos!(record::Record, mpos::Int32)
    record.inner.core.mpos = mpos
end
function insert_size(record::Record)
    record.inner.core.isize
end
function set_insert_size(record::Record, insert_size)
    record.inner.core.isize = insert_size
end
function qname_len(record::Record)
    record.inner.core.l_qname # data type may change
end
function qname(record::Record)
    data(record) # need reimplement
end
type QName end
type Cigar end
type Seq end
type Qual end
function set(record::Record,qname::QName,cigar::Cigar,seq::Seq,qual::Qual)
    throw("set is big and not implemented now")
end
function cigar_len(record::Record)
    record.inner.core.n_cigar # data type may change
end
function cigar(record::Record)
    throw("Not implemented now")
end
function seq_len(record::Record)
    record.inner.core.l_qseq #data type may change
end
function seq(record::Record)
    Seq(record.data,seq_len(record)) # wrong
end
function qual(record::Record)
    record.data() #wrong
end
function aux(record::Record)
    bam_aux_get(record.inner) #wrong
end
type Tag end
type Aux end
function push_aux(record::Record,tag::Tag,value::Aux)
    throw("Not implemented")
end

function drop(record::Record)
    throw("Not implemented")
end


# Auxiliary record data
#@enum Aux "Int32(0)" "ASCIIString()" "Float64(0)" "Char(UInt32(0))"
@enum Aux a_int32, a_asciistirng

function string(aux::Aux)
    error()
end
function float(aux::Aux)
    error()
end
function integer(aux::Aux)
    error()
end
function char(aux::Aux)
    error()
end

const DECODE_BASE = "ACMGRSVTWYHKDBN"
const ENCODE_BASE = [
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
1, 2, 4, 8, 15,15,15,15, 15,15,15,15, 15, 0,15,15,
15, 1,14, 2, 13,15,15, 4, 11,15,15,12, 15, 3,15,15,
15,15, 5, 6, 8,15, 7, 9, 15,10,15,15, 15,15,15,15,
15, 1,14, 2, 13,15,15, 4, 11,15,15,12, 15, 3,15,15,
15,15, 5, 6, 8,15, 7, 9, 15,10,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15,
15,15,15,15, 15,15,15,15, 15,15,15,15, 15,15,15,15
];

immutable Seq<T>
    encode::T
    len::UInt64
end
function encode_base(seq::Seq, i::UInt64)
    seq.encoded[i/2]>>((!i&i << 2)) & 0b1111
end
function as_bytes(seq::Seq)
    error()
end
function len(seq::Seq)
    seq.len
end

# operator for Seq not implemented here

@enum Cigar Match(UInt32) Ins(UInt32) Del(UInt32)
RefSkip(UInt32) SoftClip(UInt32) HardClip(UInt32)
Pad(UInt32) Equal(Int32) Diff(UInt32) Back(Int32)
end

function encode(cigar::Cigar)
    error("Not implementd")
end
