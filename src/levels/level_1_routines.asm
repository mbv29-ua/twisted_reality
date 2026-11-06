SECTION "Level 1 Routines", ROM0

level_1_intro_text_write::  
	ld hl, level_1_intro_text
    call write_text
    ret