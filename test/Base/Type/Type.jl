
#compare sequence
seq = Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG")
same_seq = Sequence("AAAATTTTCCCCGGGGAAAATTTTCCCCGGGG")
reverse_seq = Sequence("GGGGCCCCTTTTAAAAGGGGCCCCTTTTAAAA") 
compelment_seq = Sequence("TTTTAAAAGGGGCCCCTTTTAAAAGGGGCCCC") 
reverse_compelment_seq = Sequence("CCCCGGGGAAAATTTTCCCCGGGGAAAATTTT")
qual = Quality("FFFF####AAAAFFFFFFFFFFFFFFFFFFFF")
@test  seq == same_seq
@test seq == -reverse_seq
@test seq == !compelment_seq
@test seq == ~reverse_compelment_seq
@test seq == -(-seq)
@test seq == !(!seq)
@test seq == ~(~seq)
@test reverse_compelment_seq == !(-seq)
@test reverse_compelment_seq == -(!seq)