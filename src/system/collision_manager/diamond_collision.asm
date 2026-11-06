INCLUDE "constants_system.inc"
INCLUDE "utils/arithmetic_macros.inc"
INCLUDE "system/collision_manager/collisions.inc"

SECTION "Diamond collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_tile_collision
;;; Checks if player is touching a diamond tile
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; THIS MUST BE REWRITTEN TO ALLOW MOR FLEXIBILITY

check_tile_collision::
    .loop:
    .top_left:
        call get_current_tile_address_top_left_point
        ld a, [hl] ; load tile
        call is_tile_collectible
        jr nz, .top_left_deadly
        call process_collectible
        jr .top_right
        .top_left_deadly:
            call is_tile_deadly
            jr nz, .top_right
            call spike_damage
            ret

    .top_right:
        call get_current_tile_address_top_right_point
        ld a, [hl] ; load tile
        call is_tile_collectible
        jr nz, .top_right_deadly
        call process_collectible
        jr .bottom_left
        .top_right_deadly:
            call is_tile_deadly
            jr nz, .bottom_left  ; Not deadly, return
            call spike_damage
            ret

    .bottom_left:
        call get_current_tile_address_bottom_left_point
        ld a, [hl] ; load tile
        call is_tile_collectible
        jr nz, .bottom_left_deadly
        call process_collectible
        jr .bottom_right
        .bottom_left_deadly:
            call is_tile_deadly
            jr nz, .bottom_right  ; Not deadly, return
            call spike_damage
            ret

    .bottom_right:
        call get_current_tile_address_bottom_right_point
        ld a, [hl] ; load tile
        call is_tile_collectible
        jp nz, .bottom_right_deadly
        call process_collectible
        ret
        .bottom_right_deadly:
            call is_tile_deadly
            ret nz; Not deadly, return
            call spike_damage
            ret



process_collectible:
    ld a, [hl] ; load tile
    ld [hl], EMPTY_TILE
    call is_tile_diamond
    jr z, .is_diamond
    ;call is_tile_bulletbox
    ;jr z, .is_bulletbox
    ;jr .another_collectible
    ; Is an ahmbar, collect it

    .is_diamond:
        ;call increment_score_and_display
        ld hl, wRemainingDiamonds
        dec [hl]
        ret

    ;.is_bulletbox:
    ;    call collect_bullet
    ;    ret
    ;.another_collectible:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_diamond_tile_collision
;;; Checks if player is touching a diamond tile
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; THIS MUST BE REWRITTEN TO ALLOW MOR FLEXIBILITY

;check_diamond_tile_collision::
;    .loop:
;    .left:
;        call get_current_tile_address_left_point
;        ld a, [hl] ; load tile
;        call is_tile_collectible
;        jp z, .process_collectible
;
;    .center:
;        call get_current_tile_address_center_point
;        ld a, [hl] ; load tile
;        call is_tile_collectible
;        jp z, .process_collectible
;
;    .right:
;        call get_current_tile_address_right_point
;        ld a, [hl] ; load tile
;        call is_tile_collectible
;        ret nz  ; Not a door, return
;
;    .process_collectible:
;        ld a, [hl] ; load tile
;        ld [hl], EMPTY_TILE
;        call is_tile_diamond
;        jr z, .is_diamond
        ;call is_tile_bulletbox
        ;jr z, .is_bulletbox
        ;jr .another_collectible
        ; Is an ahmbar, collect it

;        .is_diamond:
            ;call increment_score_and_display
;            ret

        ;.is_bulletbox:
        ;    call collect_bullet
        ;    ret
        ;.another_collectible:
;    jp .loop




get_current_tile_address_left_point::
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    add 1
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret




get_current_tile_address_right_point::
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    ; add 6
    add 14
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret








get_current_tile_address_top_left_point::
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    add 4
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret




get_current_tile_address_top_right_point::
    ld a, [Player.wPlayerY]
    add 4
    ld b, a
    ld a, [Player.wPlayerX]
    add 11
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret




get_current_tile_address_bottom_left_point::
    ld a, [Player.wPlayerY]
    add 11
    ld b, a
    ld a, [Player.wPlayerX]
    add 4
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret




get_current_tile_address_bottom_right_point::
    ld a, [Player.wPlayerY]
    add 11
    ld b, a
    ld a, [Player.wPlayerX]
    add 11
    ld c, a
    ld a, b
    call convert_y_to_ty
    ld b, a
    ld a, c
    call convert_x_to_tx
    ld c, a

    ld h, 0 ; HL = Tile Y
    ld l, b
    mult_hl_32
    
    ; Add Tile X
    ld d, 0
    ld e, c ; DE = Tile X 
    add hl, de
    ld de, BG_MAP_START
    add hl, de
    ret
