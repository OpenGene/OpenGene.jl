
#compare sequence
seq = Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG")
same_seq = Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG")
reverse_seq = Sequence("GGGGCCCCTTTTAAAAGGGGCCCCTTTTAAAA") 
compelment_seq = Sequence("TTTTAAAAGGGGCCCCTTTTAAAAGGGGCCCC") 
reverse_compelment_seq = Sequence("CCCCGGGGAAAATTTTCCCCGGGGAAAATTTT")
qual = Quality("FFFF####AAAAFFFFFFFFFFFFFFFFFFFF")
seq_name = "this_is_a_sequence_name"
fq = FastqRead(seq_name, seq, "+", qual)
reverse_compelment_fq = FastqRead(seq_name, reverse_compelment_seq, "+", reverse(qual))
fa = FastaRead(seq_name, seq)
reverse_compelment_fa = FastaRead(seq_name, reverse_compelment_seq)

@test seq == same_seq
@test seq == -reverse_seq
@test seq == !compelment_seq
@test seq == ~reverse_compelment_seq
@test seq == -(-seq)
@test seq == !(!seq)
@test seq == ~(~seq)
@test complement(dna("ATCG"))== dna("TAGC")
@test reverse_compelment_seq == !(-seq)
@test reverse_compelment_seq == -(!seq)
@test reverse_compelment_fq.sequence == (~fq).sequence
@test reverse_compelment_fq.quality == (~fq).quality
@test reverse_compelment_fa.sequence == (~fa).sequence
@test dna("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG") == Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG", DNA_SEQ)
@test rna("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG") == Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG", RNA_SEQ)
@test aa("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG") == Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG", AA_SEQ)
