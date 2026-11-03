INCLUDE "constants.inc"

SECTION "Level 1", ROM0

level_1::

.level_number:			DB 		1						; LEVEL_NUMBER
.intro_scene:			DW_BE	level_1_intro_text  	; LEVEL_INTRO_DIALOG
.tileset:				DW_BE 	world_1_tiles 			; LEVEL_TILESET ; Se almacen como HIGH/LOW
.tilset_size:			DW_BE 	(world_1_tiles.end-world_1_tiles.start)		; LEVEL_TILESET_SIZE ; Se almacen como HIGH/LOW
.tileset_offset:		DW_BE 	128 * TILE_SIZE			; LEVEL_TILESET_OFFSET ; Se almacen como HIGH/LOW
.tilemap:				DW_BE 	level_1_tilemap			; LEVEL_TILEMAP ; Se almacen como HIGH/LOW
.music:                 DW_BE   level_1_music           ; LEVEL_MUSIC
.starting_y: 			DB 		136 					; LEVEL_PLAYER_STARTING_Y
.starting_x: 			DB 		16						; LEVEL_PLAYER_STARTING_X
.initial_scroll_y: 		DB	 	0  						; LEVEL_STARTING_SCREEN_SCROLL_Y
.initial_scroll_x:		DB 		0						; LEVEL_STARTING_SCREEN_SCROLL_X
.scene_enemy_spawner:	DW_BE 	0	; LEVEL_ENEMY_SPAWNER
.background_animation:	DW_BE	0	; LEVEL_ANIMATION_ROUTINE
.next_level_trigger:	DW_BE	0	; LEVEL_NEXT_LEVEL_TRIGGER
.next_level:			DW_BE 	level_1					; LEVEL_NEXT_LEVEL
