INCLUDE "constants.inc"
INCLUDE "scenes/acts/act_1/scene_1/act_1_scene_1_constants.inc"

SECTION "Level 1", ROM0

level_1::

.level_number:			DB 		1						; LEVEL_NUMBER
.intro_scene:			DW_BE	level_1_intro_textº 	; LEVEL_INTRO_DIALOG
.tileset:				DW_BE 	tiles 					; LEVEL_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(tiles_end-tiles)		; LEVEL_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; LEVEL_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	level_1_tilemap			; LEVEL_TILEMAP ; Se almacen como HIGH/LOW
.music:                 DW_BE   level_1_music           ; LEVEL_MUSIC
.starting_y: 			DB 		136 					; LEVEL_PLAYER_STARTING_Y
.starting_x: 			DB 		16						; LEVEL_PLAYER_STARTING_X
.initial_scroll_y: 		DB	 	0  						; LEVEL_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		0						; LEVEL_STARTING_SCREEN_SCROLL_X
.scene_enemy_spawner:	DW_BE 	level_1_enemy_spawner	; LEVEL_ENEMY_SPAWNER
.background_animation:	DW_BE	update_fire_animation	; LEVEL_ANIMATION_ROUTINE
.next_level_trigger:	DW_BE	check_door_collision	; LEVEL_NEXT_LEVEL_TRIGGER
.next_level:			DW_BE 	level_2					; LEVEL_NEXT_LEVEL
