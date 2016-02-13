# distance functions
@test edit_distance("AAAATTTTCCCCGGGG", "AAAATTATCCCCGGGG") == 1
@test edit_distance("AAAATTTTCCCCGGGG", "AAAATTTCCCCGGGG") == 1
@test edit_distance("AAAATTTTCCCCGGGG", "AAAATATCCCCGGGG") == 2
@test hamming_distance("AAAATTTTCCCCGGGG", "AAAATTATCCCCGGGG") == 1
@test hamming_distance("AAAATTTTCCCCGGGG", "AAAATTTCCCCGGGG") == 2