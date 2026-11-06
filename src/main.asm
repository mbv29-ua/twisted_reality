;;----------LICENSE NOTICE-------------------------------------------------------------------------------------------------------;;
;;  This file is part of GBTelera: A Gameboy Development Framework                                                               ;;
;;  Copyright (C) 2024 ronaldo / Cheesetea / ByteRealms (@FranGallegoBR)                                                         ;;
;;                                                                                                                               ;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    ;;
;; files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy,    ;;
;; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the         ;;
;; Softwareis furnished to do so, subject to the following conditions:                                                           ;;
;;                                                                                                                               ;;
;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.;;
;;                                                                                                                               ;;
;; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          ;;
;; WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         ;;
;; COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ;;
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         ;;
;;-------------------------------------------------------------------------------------------------------------------------------;;

SECTION "Global timer", WRAM0 

wAnimationTimer::  DS 1
wBottomLeftTile::  DS 1
wBottomDownTile::  DS 1
wBottomRightTile:: DS 1
wTopLeftTile::     DS 1
wTopDownTile::     DS 1
wTopRightTile::    DS 1
wGravity::		   DS 1
wRemainingDiamonds::  DS 1

SECTION "Entry point", ROM0[$150]

main::
	call start_game
	call wait_vblank

.main_loop:

	;; Render
	;; Routines accessing the VRAM must be placed here (still VBlank)

	; call process_scene_background_animation
	ld hl, wAnimationTimer
	inc [hl]
	ld a, [wAnimationTimer]
	and %11000001
	jr nz, .vortex_animation_process
		call diamond_animation
	jr .continue_tiles
	.vortex_animation_process:
		call vortex_animation

	.continue_tiles:
	ld a, [wAnimationTimer]
	and %00000001
	jr nz, .check_vortex
		call update_player_sprite
    	call check_tile_collision
		;call check_diamond_tile_collision
		jr .continue_no_vram

	.check_vortex:
		call check_vortex_tile_collision
    	;call check_deadly_collision     ; Check deadly tiles (spikes) to damage player


	;; Checks
    ; call check_lives ; Check state after render and before the rest
    call check_next_level
    call hUGE_dosound               ; Update hUGE music driver

	.continue_no_vram:
	;; Update entities 
	;; Routines not accessing the VRAM should be placed here
	call read_pad
	call update_character_velocities
    ; call apply_intelligent_behavior_to_enemies
    call process_all_enemies_AIs
    call apply_gravity_to_affected_entities
	; call generate_random_number
	call update_all_entities_positions
	call scroll_manager

    call check_enemy_collision      ; Check collision with enemies

	;; Halt the CPU (stop procesing here until a VBlank interruption)
	halt   
	jp .main_loop

