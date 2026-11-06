INCLUDE "constants_system.inc"
INCLUDE "system/collision_manager/collisions.inc"

;SECTION "Diamond tile animation variables", WRAM0 

;wDiamondAnimation:: DS 1

SECTION "Diamond tile animation", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the diamond tiles
;; animation.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys  A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

diamond_animation::
    ld a, [wAnimationTimer]
    and %0011100
    cp  %0000100
    jp z, .frame_1
    cp  %0001000
    jp z, .frame_2    
    cp  %0001100
    jp z, .frame_3
    cp  %0010000
    jp z, .frame_4
    cp  %0010100
    jp z, .frame_5
    cp  %0011000
    jp z, .base_frame
    ret
    
    .base_frame:
        ld hl, diamond_animation_tiles.diamond_0
        jr .copy

    .frame_1:
        ld hl, diamond_animation_tiles.diamond_1
        jr .copy

    .frame_2:
        ld hl, diamond_animation_tiles.diamond_2
        jr .copy

    .frame_3:
        ld hl, diamond_animation_tiles.diamond_3
        jr .copy

    .frame_4:
        ld hl, diamond_animation_tiles.diamond_4
        jr .copy

    .frame_5:
        ld hl, diamond_animation_tiles.diamond_5
        ; jr .copy

    .copy:
    ld de, VRAM0_START+DIAMOND_TILE*TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256
    ret