
bitstype 960 Struct_BGZF
typealias BGZF Struct_BGZF

function bgzf_close(fp::BGZF)
end

const HTS_FMT_BAI = Cint(1)

typealias int8_t Cchar
typealias int16_t Cshort
typealias int32_t Cint
typealias int64_t Clong
typealias uint8_t Cuchar
typealias uint16_t Cushort
typealias uint32_t Cuint
typealias uint64_t Culong
typealias int_least8_t Cchar
typealias int_least16_t Cshort
typealias int_least32_t Cint
typealias int_least64_t  Clong
typealias uint_least8_t  Cuchar
typealias uint_least16_t  Cushort
typealias uint_least32_t  Cuint
typealias uint_least64_t  Culong
typealias int_fast8_t  Cchar
typealias int_fast16_t  Clong
typealias int_fast32_t  Clong
typealias int_fast64_t  Clong
typealias uint_fast8_t  Cuchar
typealias uint_fast16_t  Culong
typealias uint_fast32_t  Culong
typealias uint_fast64_t  Culong
typealias intptr_t  Clong
typealias uintptr_t  Culong
typealias intmax_t  Clong
typealias uintmax_t  Culong
typealias ptrdiff_t  Clong
typealias size_t  Culong
typealias wchar_t  Cint

@enum Struct_cram_fd cram1 cram2
@enum Struct_hFILE hFile1 hfile2

immutable Struct___kstring_t
    l::Csize_t
    m::Csize_t
    s::Cchar
    function Struct___kstring_t()
        new(0, 0, "")
    end
end

typealias kstring_t  Struct___kstring_t
typealias Enum_htsFormatCategory  Cuint
const unknown_category = Cuint(0)
const sequence_data = Cuint(1)
const variant_data = Cuint(2)
const index_file = Cuint(3)
const region_list = Cuint(4)
const category_maximum = Cuint(32767)
typealias Enum_htsExactFormat  Cuint
const unknown_format = Cuint(0)
const binary_format = Cuint(1)
const text_format = Cuint(2)
const sam = Cuint(3)
const bam = Cuint(4)
const bai = Cuint(5)
const cram_const = Cuint(6)
const crai = Cuint(7)
const vcf = Cuint(8)
const bcf = Cuint(9)
const csi = Cuint(10)
const gzi = Cuint(11)
const tbi = Cuint(12)
const bed = Cuint(13)
const format_maximum = Cuint(32767)
typealias Enum_htsCompression Cuint
const no_compression = Cuint(0)
const gzip = Cuint(1)
const bgzf_const = Cuint(2)
const custom = Cuint(3)
const compression_maximum = Cuint(32767)

immutable Struct_Unnamed1
    major::Cshort
    minor::Cshort
    function Struct_Unnamed1()
        new(0,0)
    end
end

immutable Struct_htsFormat
    category::Enum_htsFormatCategory
    format::Enum_htsExactFormat
    version::Struct_Unnamed1
    compression::Enum_htsCompression
    compression_level::Cshort
    specific::Void
end

function Struct_htsFormat()
    new(0,0,0,0,0,0)
end



typealias htsFormat Struct_htsFormat

immutable Union_Unnamed3
    _bindgen_data_::Array{Int64,1}
    function Union_Unnamed3()
        new(zeros())
    end
end

immutable Struct_Unnamed2
    isbin_isright_isbe_iscram_dummy::uint32_t
    lineno::int64_t
    line::kstring_t
    _fn::Cchar
    fn_aux::Cchar
    fp::Union_Unnamed3
    format::htsFormat
    function Struct_Unnamed2()
        new(0,0,0,0,0,0,0)
    end
end

function bgzf(uu3::Union_Unnamed3) 
    #::std::mem::transmute(&self._bindgen_data_)
end
function cram(uu3::Union_Unnamed3)
    #::std::mem::transmute(&self._bindgen_data_)
end
function hfile(uu3::Union_Unnamed3)
    #::std::mem::transmute(&self._bindgen_data_)
end
function voidp(uu3::Union_Unnamed3)
    #::std::mem::transmute(&self._bindgen_data_)
end

typealias htsFile  Struct_Unnamed2
typealias Enum_sam_fields  Cuint
const SAM_QNAME = Cuint(1)
const SAM_FLAG = Cuint(2)
const SAM_RNAME = Cuint(4)
const SAM_POS = Cuint(8)
const SAM_MAPQ = Cuint(16)
const SAM_CIGAR = Cuint(32)
const SAM_RNEXT = Cuint(64)
const SAM_PNEXT = Cuint(128)
const SAM_TLEN = Cuint(256)
const SAM_SEQ = Cuint(512)
const SAM_QUAL = Cuint(1024)
const SAM_AUX = Cuint(2048)
const SAM_RGAUX = Cuint(4096)
typealias Enum_cram_option  Cuint
const CRAM_OPT_DECODE_MD = Cuint(0)
const CRAM_OPT_PREFIX = Cuint(1)
const CRAM_OPT_VERBOSITY = Cuint(2)
const CRAM_OPT_SEQS_PER_SLICE = Cuint(3)
const CRAM_OPT_SLICES_PER_CONTAINER = Cuint(4)
const CRAM_OPT_RANGE = Cuint(5)
const CRAM_OPT_VERSION = Cuint(6)
const CRAM_OPT_EMBED_REF = Cuint(7)
const CRAM_OPT_IGNORE_MD5 = Cuint(8)
const CRAM_OPT_REFERENCE = Cuint(9)
const CRAM_OPT_MULTI_SEQ_PER_SLICE = Cuint(10)
const CRAM_OPT_NO_REF = Cuint(11)
const CRAM_OPT_USE_BZIP2 = Cuint(12)
const CRAM_OPT_SHARED_REF = Cuint(13)
const CRAM_OPT_NTHREADS = Cuint(14)
const CRAM_OPT_THREAD_POOL = Cuint(15)
const CRAM_OPT_USE_LZMA = Cuint(16)
const CRAM_OPT_USE_RANS = Cuint(17)
const CRAM_OPT_REQUIRED_FIELDS = Cuint(18)
@enum Struct___hts_idx_t hts_idx_1 hts_idx_2
typealias hts_idx_t Struct___hts_idx_t

immutable Struct_Unnamed4
    u::uint64_t
    v::uint64_t
    function Struct_Unnamed4()
        new(0,0)
    end
end

typealias hts_pair64_t Struct_Unnamed4
hts_readrec_func(fp::BGZF,data::Void,r::Void,tid::Cint,beg::Cint,ed::Cint) = ()


immutable Struct_Unnamed6 
    n::Cint
    m::Cint
    a::Cint
    function Struct_Unnamed5()
        new(0,0,0)
    end
end

immutable Struct_Unnamed5 
    readres_finished_dummy::uint32_t
    tid::Cint
    beg::Cint
    ed::Cint
    n_off::Cint
    i::Cint
    curr_tid::Cint
    curr_beg::Cint
    curr_end::Cint
    curr_off::uint64_t
    off::hts_pair64_t
    readrec
    bins::Struct_Unnamed6
    function Struct_Unnamed5()
        new(0,0,0,0,0,0,0,0)
    end
end


typealias hts_itr_t Struct_Unnamed5
hts_name2id_f(arg1,arg2) = ()
hts_id2name_f(arg1,arg2) = () 
hts_itr_query_func(idx,tid,beg,ed,readrec) =()

immutable Struct_Unnamed7 
    n_targets::int32_t
    ignore_sam_err::int32_t
    l_text::uint32_t
    target_len::uint32_t
    cigar_tab::int8_t
    target_name::Cchar
    text::Cchar
    sdict::Void
    function Struct_Unnamed7()
        new()
    end
end

typealias bam_hdr_t Struct_Unnamed7

immutable Struct_Unnamed8
    tid::int32_t
    pos::int32_t
    bin::uint16_t
    qual::uint8_t
    l_qname::uint8_t
    flag::uint16_t
    n_cigar::uint16_t
    l_qseq::int32_t
    mtid::int32_t
    mpos::int32_t
    isize::int32_t
    function Struct_Unnamed7()
        new()
    end
end

typealias bam1_core_t Struct_Unnamed8

immutable Struct_Unnamed9
    core::bam1_core_t
    l_data::Cint
    m_data::Cint
    data::uint8_t
    id::uint64_t
    function Struct_Unnamed7()
        new()
    end
end

typealias bam1_t Struct_Unnamed9
typealias samFile htsFile

immutable Struct_Unnamed10
    b::bam1_t
    qpos::int32_t
    indel::Cint
    level::Cint
    isdel_ishead_istail_isrefskip_isaux::uint32_t
    function Struct_Unnamed10()
        new()
    end
end

typealias bam_pileup1_t Struct_Unnamed10
bam_plp_auto_f(data,b) = ()
@enum Struct___bam_plp_t test1 test2
typealias bam_plp_t  Struct___bam_plp_t
@enum Struct___bam_mplp_t b1 b2
typealias bam_mplp_t Struct___bam_mplp_t

typealias hts_verbose Cint
typealias seq_nt16_table Array{Cuchar,1}
typealias seq_nt16_str Cchar
typealias seq_nt16_int Cint

type Cvoid #unkown
end
#=
function bgzf_open(_function::Cchar, mode::Cchar)
end
=#
function hts_version()
end
function hts_detect_format(fp::Struct_hFILE, fmt::htsFormat)
end
function hts_format_description(format::htsFormat)
end
function hts_open(_function::Cchar, mode::Cchar)
end
function hts_hopen(fp::Struct_hFILE, _function::Cchar, mode::Cchar)
end
function hts_close(fp::htsFile)
end
function hts_get_format(fp::htsFile)
end
function hts_set_opt(fp::htsFile, opt...)
end
function hts_getline(fp::htsFile, delimiter::Cint, str::kstring_t)
end
function hts_readlines(_function::Cchar, _n::Cint)
end
function hts_readlist(_function::Cchar, is_file::Cint, _n::Cint)
end
function hts_set_threads(fp::htsFile, n::Cint)
end
function hts_set_fai_filename(fp::htsFile, function_aux::Cchar)
end
function hts_idx_init(n::Cint, fmt::Cint, offset0::uint64_t, min_shift::Cint, n_lvls::Cint)
end
function hts_idx_destroy(idx::hts_idx_t)
end
function hts_idx_push(idx::hts_idx_t, tid::Cint, beg::Cint, ed::Cint, offset::uint64_t, is_mapped::Cint)
end
function hts_idx_finish(idx::hts_idx_t, final_offset::uint64_t)
end
function hts_idx_save(idx::hts_idx_t, _function::Cchar,
                    fmt::Cint)
end
function hts_idx_load(_function::Cchar, fmt::Cint)
end
function hts_idx_get_meta(idx::hts_idx_t, l_meta::Cint)
end
function hts_idx_set_meta(idx::hts_idx_t, l_meta::Cint,
                    meta::uint8_t, is_copy::Cint)
end
function hts_idx_get_stat(idx::hts_idx_t, tid::Cint,
                    mapped::uint64_t, unmapped::uint64_t)
end
function hts_idx_get_n_no_coor(idx::hts_idx_t)
end
function hts_parse_reg(s::Cchar, beg::Cint,
                 ed::Cint)
end
function hts_itr_query(idx::hts_idx_t, tid::Cint,
                 beg::Cint, ed::Cint,
                 readrec)
end
function hts_itr_destroy(iter::hts_itr_t)
end
#= hts_name2id_f function 
function hts_itr_querys(idx::hts_idx_t,reg::Cchar,getid::hts_name2id_f, hdr::Cvoid,
                        itr_query_1, readrec_1)
end
=#
function hts_itr_next(fp::BGZF, iter::hts_itr_t,
                r::Cvoid, data::Cvoid)
end
#= hts_id2name_f function
function hts_idx_seqnames(idx::hts_idx_t, n::Cint, getid::hts_id2name_f, hdr::Cvoid)
end
=#
function hts_file_type(functioname::Cchar)
end
function bam_hdr_init()
end
function bam_hdr_read(fp::Ptr{BGZF})
    ccall((:bam_hdr_read,"libhts"), bam_hdr_t, (Ptr{BGZF},), fp)
end
function bam_hdr_write(fp::BGZF, h::bam_hdr_t)
end
function bam_hdr_destroy(h::bam_hdr_t)
end
function bam_name2id(h::bam_hdr_t, _ref::Cchar)
end
function bam_hdr_dup(h0::bam_hdr_t)
end
function bam_init1()
end
function bam_destroy1(b::bam1_t)
end
function bam_read1(fp::BGZF, b::bam1_t)
end
function bam_write1(fp::BGZF, b::bam1_t)
end
function bam_copy1(bdst::bam1_t, bsrc::bam1_t)
end
function bam_dup1(bsrc::bam1_t)
end
function bam_cigar2qlen(n_cigar::Cint, cigar::uint32_t)
end
function bam_cigar2rlen(n_cigar::Cint, cigar::uint32_t)
end
function bam_endpos(b::bam1_t)
end
function bam_str2flag(str::Cchar)
end
function bam_flag2str(flag::Cint)
end
function bam_index_build(_function::Cchar,
                   min_shift::Cint)
end
function sam_index_load(fp::htsFile, _function::Cchar)
end
function sam_itr_queryi(idx::hts_idx_t, tid::Cint,
                  beg::Cint, ed::Cint)
end
function sam_itr_querys(idx::hts_idx_t, hdr::bam_hdr_t,
                  region::Cchar)
end
function sam_open_mode(mode::Cchar,
                 _function::Cchar,
                 format::Cchar)
end
function sam_hdr_parse(l_text::Cint, text::Cchar)
end
function sam_hdr_read(fp::samFile)
end
function sam_hdr_write(fp::samFile, h::bam_hdr_t)
end
function sam_parse1(s::kstring_t, h::bam_hdr_t, b::bam1_t)
end
function sam_format1(h::bam_hdr_t, b::bam1_t,
               str::kstring_t)
end
function sam_read1(fp::samFile, h::bam_hdr_t, b::bam1_t)
end
function sam_write1(fp::samFile, h::bam_hdr_t, b::bam1_t)
end
function bam_aux_get(b::bam1_t, tag::Cchar)
end
function bam_aux2i(s::uint8_t)
end
function bam_aux2f(s::uint8_t)
end
function bam_aux2A(s::uint8_t)
end
function bam_aux2Z(s::uint8_t)
end
function bam_aux_append(b::bam1_t, tag::Cchar,
                  _type::Cchar, len::Cint,
                  data::uint8_t)
end
function bam_aux_del(b::bam1_t, s::uint8_t)
end
#=
function bam_plp_init(func::bam_plp_auto_f, data::Cvoid)
end
=#
function bam_plp_destroy(iter::bam_plp_t)
end
function bam_plp_push(iter::bam_plp_t, b::bam1_t)
end
function bam_plp_next(iter::bam_plp_t, _tid::Cint,
                _pos::Cint, _n_plp::Cint)
end
function bam_plp_auto(iter::bam_plp_t, _tid::Cint,
                _pos::Cint, _n_plp::Cint)
end
function bam_plp_set_maxcnt(iter::bam_plp_t, maxcnt::Cint)
end
function bam_plp_reset(iter::bam_plp_t)
end
#=
function bam_mplp_init(n::Cint, func::bam_plp_auto_f,
                 data::Cvoid)
end
=#
function bam_mplp_init_overlaps(iter::bam_mplp_t)
end
function bam_mplp_destroy(iter::bam_mplp_t)
end
function bam_mplp_set_maxcnt(iter::bam_mplp_t, maxcnt::Cint)
end
function bam_mplp_auto(iter::bam_mplp_t, _tid::Cint,
                 _pos::Cint, n_plp::Cint,
                 plp::bam_pileup1_t)
end
