INCLUDE "game_engine/level_constants.inc"
INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"
INCLUDE "assets/tiles/tiles.inc"

SECTION "Scene address", WRAM0

current_level_info_address: DS 2

SECTION "Level manager", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the information of a level
;;
;; INPUT:
;;		HL: Address of level.conf
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC, DE, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_level::
    call save_current_level_info_address
    call play_level_intro_text

    ; Turn off the screen
    call screen_off

    ; Clean routines
    call clean_OAM    
    call copy_DMA_routine
    
    call man_entity_init

    ; Load assets
    ;call load_numbers
    ;call load_heart_tiles
    ;call load_ambar_tile
    ;call load_player_tiles
    ; call load_cowboy_sprites
    ;call load_bullet_sprites
    ;call load_frog_tiles
    ;call load_fly_tiles
    ;call load_butterfly_tiles
    ;call load_darkfrog_tiles
    ;call load_desintegration_tiles

    call load_characters_tiles
    call load_tileset
    call load_level_map
    call set_initial_scroll
    call init_player
    ; call init_enemigos_prueba

    ;ld hl, wNumberOfEnemies
    ;ld [hl], 0
    ;call init_enemies
    ;call init_collectibles
    ;call init_palettes_by_default

    ; Load level variables
    ; call init_counterload_level
    ;call init_tile_animation        ; Initialize fire animation system
    ;call init_hud                   ; Initialize HUD (lives & bullets)
    ;call init_hud_score_display ; Initialize and display the score
    
    ; Load music
	call init_background_music

    ; Turn on the screen
    call enable_vblank_interrupts
    call screen_bg_on
    call screen_obj_on
    ;call screen_hud_on
    call screen_window_dialog
    call screen_on
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine saves the current level information
;; address
;;
;; INPUT:
;;      HL: Address of the level
;; OUTPUT:
;;      -   
;; WARNING: Destroys A and DE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

save_current_level_info_address::
    ld de, current_level_info_address
    
    ld a, h
    ld [de], a
    inc de
    
    ld a, l
    ld [de], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine gets the current level information
;; address
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      HL: Current level information   
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_current_level_info_address::
    ld hl, current_level_info_address
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the characters tiles in the 
;; VRAM.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_characters_tiles::
    ld hl, characters
    ld de, VRAM0_START + 4 * TILE_SIZE
    ld bc, characters.end - characters.start
    call memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the tileset using 
;; the current level information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_tileset::
	;; We compute the destiny -> VRAM0_START+LEVEL_TILESET_OFFSET
    call get_current_level_info_address ; in hl
	ld de, LEVEL_TILESET_OFFSET
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]

	ld hl, VRAM0_START
    add hl, de
    ld d, h
    ld e, l

    call get_current_level_info_address; in hl
    ld bc, LEVEL_TILESET_SIZE
    add hl, bc
    ld b, [hl]
    inc hl
    ld c, [hl]

	;  The memory address HL where the tileset is in [HL]
    push bc
    call get_current_level_info_address ; in hl
    ld bc, LEVEL_TILESET
	add hl, bc
	ld a, [hl+]
	ld l, [hl]
	ld h, a
	pop bc

    call memcpy_65536
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the tilemap using the
;; current level information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_level_map::
	;  We obtain the memory address HL where the tilemap is from [HL]
    call get_current_level_info_address ; in hl
    ld bc, LEVEL_TILEMAP
	add hl, bc
	ld a, [hl+]
	ld l, [hl]
	ld h, a

    ld de, BG_MAP_START
    ld bc, BG_MAP_SIZE

    call memcpy_65536

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the initial scroll using 
;; the current level information
;;
;; INPUT:
;;		-
;; OUTPUT: 
;;		-	
;; WARNING: Destroys A, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_initial_scroll::
	call get_current_level_info_address ; in hl
    ld d, 0
    ld e, LEVEL_STARTING_SCREEN_SCROLL_Y
    add hl, de
    ld a, [hl]
    ldh [rSCY], a

    ld e, (LEVEL_STARTING_SCREEN_SCROLL_X-LEVEL_STARTING_SCREEN_SCROLL_Y)
    add hl, de
    ld a, [hl]
    ldh [rSCX], a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine corrects the position of the
;; entities when there is a change of the scroll.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

correct_entity_position_when_scroll_resets::
    ld l, e
    call get_entity_sprite
    push de
    push hl

    ;; Compensate current scroll Y
    ld a, b
    ld hl, rSCY
    add [hl]
    ld b, a

    ;; Compensate current scroll X
    ld a, c
    ld hl, rSCX
    add [hl]
    ld c, a

    call get_current_level_info_address ; in hl

    ;; Compensate initial scroll Y
    ld a, b
    ld d, 0
    ld e, LEVEL_STARTING_SCREEN_SCROLL_Y
    add hl, de
    sub [hl]
    ld b, a

    ;; Compensate initial scroll X
    ld a, c
    ld e, (LEVEL_STARTING_SCREEN_SCROLL_X-LEVEL_STARTING_SCREEN_SCROLL_Y)
    add hl, de
    sub [hl]
    ld c, a

    ;; We set the corrected values
    pop hl
    pop de
    call set_entity_sprite
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine initializes the player using 
;; the current level information
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_player::
    call man_entity_alloc ; Deja en l el indice - pero asumimos que siempre es 0
    call set_player_initial_position
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the player in the initial 
;; position according to the current level information
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_player_initial_position::
    call get_current_level_info_address ; in hl
    ld d, 0
    ld e, LEVEL_PLAYER_STARTING_Y
    add hl, de
    ld b, [hl] ; Y coordinate

    ld e, LEVEL_PLAYER_STARTING_X-LEVEL_PLAYER_STARTING_Y
    add hl, de
    ld c, [hl]  ; X coordinate

    ld d, TILE_PLAYER_WALKING_2 ; tile
    ld e, 0           ; tile properties
    ld l, 0
    call set_entity_sprite

    ld b, 0
    ld c, 0
    ld d, 0
    ld e, 0
    call set_entity_physics

;; Revisar
    ld h, CMP_ATTR_H
    ld l, E_BIT_PLAYER
    
    ; 7: E_BIT_MOVABLE
    ; 6: E_BIT_GRAVITY
    ; 5: E_BIT_DIES_OUT_OF_SCREEN
    ; 4: E_BIT_COLLIDABLE
    ; 3: E_BIT_DAMAGEABLE
    ; 2: E_BIT_STICK_TO_EDGES
    ; 1: TBA
    ; 0: TBA

    ld l, INTERACTION_FLAGS
    ld [hl], %11011100

    ld l, PHY_FLAGS
    set PHY_FLAG_GROUNDED, [hl]
    res PHY_FLAG_JUMPING, [hl]

    ld hl, wPlayerDirection
    ld [hl], 1

    ;; Player bounding box: Escribir con constantes
    ld b, PLAYER_HEIGHT
    ld c, PLAYER_WIDTH
    ld d, 0
    ld e, 0
    ld l, 0
    call set_entity_dimensions

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; restore_player_position
;;; Restores player to spawn position (level starting position)
;;; Used for spike respawn
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

restore_player_position::
    call wait_vblank
    ld hl, correct_entity_position_when_scroll_resets
    call man_entity_for_each
    ; call update_hud_if_needed
    call set_initial_scroll
    call set_player_initial_position
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine returns the next level information
;; address using the current level information
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      HL: Address of next level   
;; WARNING: Destroys A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_next_level_info::
    call get_current_level_info_address ; in hl
    ld bc, LEVEL_NEXT_LEVEL
    add hl, bc
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the next level info using 
;; the current level information
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

next_level::
    call fade_to_black
    call stop_background_music
    call get_next_level_info
    call load_level
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine spaws the enemies using the routine 
;; specified at the current level information
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys  A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_enemies::
    call get_current_level_info_address ; in hl
    ld bc, LEVEL_ENEMY_SPAWNER
    add hl, bc
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    call helper_call_hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine returns the address of the tilemap
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      DE: Address of current level tilemap    
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

get_current_tilemap_address::
    call get_current_level_info_address ; in hl
    ld bc, LEVEL_TILEMAP
    add hl, bc
    ld d, [hl]
    inc l
    ld e, [hl]
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine calls the animation routine of
;; the level specified in the configuration file.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

process_level_background_animation::
    call get_current_level_info_address ; in hl
    ld d, 0
    ld e, LEVEL_ANIMATION_ROUTINE
    add hl, de
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    call helper_call_hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine calls the finish level check
;; routine specified in the configuration file
;; of the current level.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      - 
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_next_level_trigger::
    call get_current_level_info_address ; in hl
    ld d, 0
    ld e, LEVEL_NEXT_LEVEL_TRIGGER
    add hl, de
    ld a, [hl+]
    ld l, [hl]
    ld h, a
    call helper_call_hl
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine loads the intro dialog of the
;; level specified at the current level information
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys  A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

play_level_intro_text::

    call screen_off
    call clean_OAM
    call clean_bg_map
    call load_fonts
    call set_black_palette
    call screen_hud_off
    call screen_obj_off
    call reset_scroll
    call screen_on

    call get_current_level_info_address ; in hl
    ld bc, LEVEL_INTRO_DIALOG
    add hl, bc
    ld a, [hl+]
    ld l, [hl]
    ld h, a

    di
    call helper_call_hl
    ei

    call init_palettes_by_default
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine initializes the background music
;; of the current level.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      - 
;; WARNING: Destroys  A, BC and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_background_music::
	; Initialize hUGE music driver with background_music
    ld a, $80
    ld [$FF26], a

    ld a, $77
    ld [$FF24], a

    ld a, $FF
    ld [$FF25], a

    call get_current_level_info_address ; in hl
    ld bc, LEVEL_MUSIC
    add hl, bc
    ld a, [hl+]
    ld l, [hl]
    ld h, a
	call hUGE_init
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine stops the background music
;; of the current level.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      - 
;; WARNING: Destroys  A and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

stop_background_music::
    call wait_vblank
    
    ld a, $00
    ld [$FF24], a
    ld [$FF25], a
    ld [$FF26], a

    ld hl, empty_song
    call hUGE_init

    ret