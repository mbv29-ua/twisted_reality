INCLUDE "constants_system.inc"
INCLUDE "system/collision_manager/collisions.inc"

;SECTION "Vortex tile animation variables", WRAM0 

;wVortexAnimation:: DS 1

SECTION "Vortex tile animation", ROM0


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

vortex_animation::
    ld a, [wAnimationTimer]
    and %0110110
    cp  %0000010
    jp z, .frame_1_l
    cp  %0000100
    jp z, .frame_1_r
    cp  %0010010
    jp z, .frame_2_l
    cp  %0010100
    jp z, .frame_2_r
    cp  %0100010
    jp z, .frame_3_l
    cp  %0100100
    jp z, .frame_3_r
    cp  %0110010
    jp z, .frame_4_l
    cp  %0110100
    jp z, .frame_4_r
    ret
    
    .frame_1_l:
        ld hl, vortex_animation_tiles.vortex_1
        jr .copy_l

    .frame_2_l:
        ld hl, vortex_animation_tiles.vortex_2
        jr .copy_l

    .frame_3_l:
        ld hl, vortex_animation_tiles.vortex_3
        jr .copy_l

    .frame_4_l:
        ld hl, vortex_animation_tiles.vortex_4
        ; jr .copy

    .copy_l:
    ld de, VRAM0_START + VORTEX_TILE_1 * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256
    ret

    .frame_1_r:
        ld hl, vortex_animation_tiles.vortex_1 + TILE_SIZE
        jr .copy_r

    .frame_2_r:
        ld hl, vortex_animation_tiles.vortex_2 + TILE_SIZE
        jr .copy_r

    .frame_3_r:
        ld hl, vortex_animation_tiles.vortex_3 + TILE_SIZE
        jr .copy_r

    .frame_4_r:
        ld hl, vortex_animation_tiles.vortex_4 + TILE_SIZE
        ; jr .copy

    .copy_r:
    ld de, VRAM0_START + VORTEX_TILE_2 * TILE_SIZE
    ld  b, TILE_SIZE
    call memcpy_256
    ret