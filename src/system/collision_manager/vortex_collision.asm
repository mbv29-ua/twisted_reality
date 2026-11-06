INCLUDE "constants_system.inc"
INCLUDE "system/collision_manager/collisions.inc"
INCLUDE "entities/entities.inc"

SECTION "Vortex tile effect variables", WRAM0 

wVortexCooldown:: DS 1

SECTION "Vortex collisions", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_diamond_tile_collision
;;; Checks if player is touching a diamond tile
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_vortex_tile_collision::
    ld a, [wVortexCooldown]
    and a
    jr z, .left

    ld hl, wVortexCooldown
    dec [hl]
    ret

    .left:
        call get_current_tile_address_left_point
        ld a, [hl] ; load tile
        call is_tile_vortex
        jp z, .process_vortex

    .right:
        call get_current_tile_address_right_point
        ld a, [hl] ; load tile
        call is_tile_vortex
        ret nz  ; Not a door, return

    .process_vortex:
        ld a, 5
        ld [wVortexCooldown], a
       
        ; change gravity
        ld h, CMP_ATTR_H
        ld l, PHY_FLAGS
        ld a, [hl]
        xor (1<<PHY_REVERSED_GRAVITY)
        ld [hl], a

        ; flip sprite
        ld h, CMP_SPRIT_H
        ld l, SPR_ATTR
        ld a, [hl]
        xor (1<<E_BIT_FLIP_Y)
        ld [hl], a
        ld a, l
        add a, 4
        ld l, a
        ld a, [hl]
        xor (1<<E_BIT_FLIP_Y)
        ld [hl], a
        
        ; change palette
        ld a, [rBGP]
        xor %11011101
        ldh [rBGP], a ; Change background palette
        ld a, [rOBP0]
        xor $FF
        ldh [rOBP0], a ; Change sprite palette

    ret