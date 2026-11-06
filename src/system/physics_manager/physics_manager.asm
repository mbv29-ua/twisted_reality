INCLUDE "entities/entities.inc"
INCLUDE "constants_game.inc"
INCLUDE "constants_system.inc"
INCLUDE "utils/arithmetic_macros.inc"

SECTION "Physics system", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine applies gravity to the E-th entity.
;;
;; INPUT:
;;		E: Entity index
;; OUTPUT:
;;		-	
;; WARNING: Destroys A, BC and DE

apply_gravity_to_entity::
	;; HL contains the address of the routine,
	;; so we save it since we want to use HL
    push hl

	;; Load entity physics addres in HL
	ld h, CMP_PHYS_H
	ld l, e

	;; Load Vy in BC
	ld b, [hl] ; Load current Vy in B
	inc hl
	ld c, [hl]

	;; Load GRAVITY in DE
	push hl
	ld a, e
	cp 8
	jr nc, .positive_gravity

	ld h, CMP_ATTR_H
	ld l, PHY_FLAGS
	bit PHY_REVERSED_GRAVITY, [hl]
	jp nz, .negative_gravity

	.positive_gravity
		ld d, 0
		ld e, GRAVITY

		;; Add and store
		add_bc_de

		;; To avoid infinite acceleration
		ld a, MAX_GRAVITY
		cp b
		jr nz, .store_new_speed ; if equal, we limit the gravity
		ld b, MAX_GRAVITY-1
		jr .store_new_speed

	.negative_gravity:
		ld d, $FF
		ld e, -GRAVITY

		;; Add and store
		add_bc_de

		;; To avoid infinite acceleration
		ld a, -MAX_GRAVITY
		cp b
		jr nz, .store_new_speed ; if equal, we limit the gravity
		ld b, -MAX_GRAVITY+1

	.store_new_speed:
	pop hl
	ld [hl], c
	dec hl
	ld [hl], b

	pop hl
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine applies gravity to all the 
;; affected entities
;;
;; INPUT:
;;		-
;; OUTPUT:
;;		-	
;; WARNING: Destroys ... (lo que destruya man_entity_for_each) 

apply_gravity_to_affected_entities::
	ld hl, apply_gravity_to_entity
	;ld b, E_BIT_GRAVITY
	call man_entity_for_each_gravity ;;; Cambiar por man_entity_for_each_ gravity
	ret






set_normal_gravity::
	call wait_vblank
	ld h, CMP_ATTR_H
	ld l, PHY_FLAGS
	res PHY_REVERSED_GRAVITY, [hl]
	ld h, CMP_SPRIT_H
	ld l, SPR_ATTR
	res E_BIT_FLIP_X, [hl]
	ld a, l
	add 4
	ld l, a
	res E_BIT_FLIP_X, [hl]
	ret



set_reversed_gravity::
	ld h, CMP_ATTR_H
	ld l, PHY_FLAGS
	set PHY_REVERSED_GRAVITY, [hl]
	call set_negative_palette_for_character_sprites_and_background
	ret
