MACRO SPAWN_ENEMY_AT
    ;ld b, FMOD(\2 * 8 + 16 + (256 - A1_L1_INITIAL_SCROLL_Y), 256)
    ld b, FMOD(\2 * 8 + 16 + (256 - 0), 256)
    ;ld c, FMOD(\1 * 8 +  8 + (256 - A1_L1_INITIAL_SCROLL_X), 256)
    ld c, FMOD(\1 * 8 +  8 + (256 - 0), 256)	
    ld hl, \3
	call enemy_spawn
ENDM



SECTION "Level 7 Routines", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine shows the intro scene of level 2.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level_7_intro_text_write::  
	ld hl, level_7_intro_text
    call write_text
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spawns the enemies of level 2.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

level_7_enemy_spawner::
	;SPAWN_ENEMY_AT $07, $12, jumping_alien_l
	;SPAWN_ENEMY_AT $08, $12, jumping_alien_r
	;SPAWN_ENEMY_AT $07, $1B, jumping_alien
	ret
