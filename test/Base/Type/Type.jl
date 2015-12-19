
#compare sequence
@test Sequence("AAAATTTTCCCCGGGG") == Sequence("AAAATTTTCCCCGGGG")
@test Sequence("AAAATTTTCCCCGGGG") == -Sequence("GGGGCCCCTTTTAAAA")
@test Sequence("AAAATTTTCCCCGGGG") == -(-(Sequence("AAAATTTTCCCCGGGG")))
@test Sequence("AAAATTTTCCCCGGGG", DNA_SEQ) != Sequence("AAAATTTTCCCCGGGG", RNA_SEQ)
@test Sequence("AAAATTTTCCCCGGGG") == ~(~(Sequence("AAAATTTTCCCCGGGG")))