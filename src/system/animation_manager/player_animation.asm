INCLUDE "constants_system.inc"
INCLUDE "assets/tiles/tiles.inc"
INCLUDE "entities/entities.inc"

SECTION "Player Animation", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine updates the player tile
;; entities when there is a change of the scroll.
;;
;; INPUT:
;;      E: Entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

update_player_sprite::
	.set_sprite:
	ld h, CMP_ATTR_H
	ld l, PHY_FLAGS
	
	bit PHY_FLAG_GROUNDED, [hl]
	jr nz, .not_jumping
	.jumping:
		ld h, CMP_PHYS_H
		ld l, PHY_VX
		ld a, [hl]
		bit 7, a
		jr nz, .left_dir_jumping
		.right_dir_jumping:
			ld h, CMP_SPRIT_H
			ld l, SPR_ATTR
			res E_BIT_FLIP_X, [hl]
			ld a, l
			add a, 4
			ld l, a
			res E_BIT_FLIP_X, [hl]

			ld h, CMP_SPRIT_H
			ld l, SPR_TILE
			ld [hl], TILE_PLAYER_JUMPING_L
			ld a, l
			add a, 4
			ld l, a
			ld [hl], TILE_PLAYER_JUMPING_R
			ret

		.left_dir_jumping:
			ld h, CMP_SPRIT_H
			ld l, SPR_ATTR
        	set E_BIT_FLIP_X, [hl]
        	ld a, l
        	add a, 4
    	    ld l, a
	        set E_BIT_FLIP_X, [hl]
		
			ld h, CMP_SPRIT_H
			ld l, SPR_TILE
			ld [hl], TILE_PLAYER_JUMPING_R
			ld a, l
			add a, 4
			ld l, a
			ld [hl], TILE_PLAYER_JUMPING_L
			ret

	.not_jumping:
		ld h, CMP_PHYS_H
		ld l, PHY_VX
		ld a, [hl]
		or a
		jr nz, .walking

        ld h, CMP_SPRIT_H
        ld l, SPR_ATTR
        res E_BIT_FLIP_X, [hl]
        ld a, l
        add a, 4
        ld l, a
        res E_BIT_FLIP_X, [hl]

		ld l, SPR_TILE
		ld [hl], TILE_PLAYER_FRONT_L
		ld a, l
		add a, 4
		ld l, a
		ld [hl], TILE_PLAYER_FRONT_R
		ret

	.walking:
		ld h, CMP_CONT_H
		ld l, COUNT_MOVING_COOLDOWN
		ld a, [hl]
		and %00001000 ; 16, approximately changes tile every 0.25 seconds if walking.
		jr nz, .left_step

		.right_step:
			ld h, CMP_PHYS_H
			ld l, PHY_VX
			ld a, [hl]
			bit 7, a
			jr nz, .left_dir_right_step

			.right_dir_right_step:
				ld h, CMP_SPRIT_H
				ld l, SPR_ATTR
        		res E_BIT_FLIP_X, [hl]
        		ld a, l
        		add a, 4
        		ld l, a
    	    	res E_BIT_FLIP_X, [hl]

				ld h, CMP_SPRIT_H
				ld l, SPR_TILE
				ld [hl], TILE_PLAYER_WALKING_1_L
				ld a, l
				add a, 4
				ld l, a
				ld [hl], TILE_PLAYER_WALKING_1_R
				ret

			.left_dir_right_step:
				ld h, CMP_SPRIT_H
				ld l, SPR_ATTR
        		set E_BIT_FLIP_X, [hl]
        		ld a, l
        		add a, 4
        		ld l, a
    	    	set E_BIT_FLIP_X, [hl]

				ld h, CMP_SPRIT_H
				ld l, SPR_TILE
				ld [hl], TILE_PLAYER_WALKING_1_R
				ld a, l
				add a, 4
				ld l, a
				ld [hl], TILE_PLAYER_WALKING_1_L
				ret

		.left_step:
			ld h, CMP_PHYS_H
			ld l, PHY_VX
			ld a, [hl]
			bit 7, a
			jr nz, .left_dir_left_step

			.right_dir_left_step:
				ld h, CMP_SPRIT_H
				ld l, SPR_ATTR
        		res E_BIT_FLIP_X, [hl]
        		ld a, l
        		add a, 4
        		ld l, a
    	    	res E_BIT_FLIP_X, [hl]

				ld h, CMP_SPRIT_H
				ld l, SPR_TILE
				ld [hl], TILE_PLAYER_WALKING_2_L
				ld a, l
				add a, 4
				ld l, a
				ld [hl], TILE_PLAYER_WALKING_2_R
				ret

			.left_dir_left_step:
				ld h, CMP_SPRIT_H
				ld l, SPR_ATTR
        		set E_BIT_FLIP_X, [hl]
        		ld a, l
        		add a, 4
        		ld l, a
    	    	set E_BIT_FLIP_X, [hl]

				ld h, CMP_SPRIT_H
				ld l, SPR_TILE
				ld [hl], TILE_PLAYER_WALKING_2_R
				ld a, l
				add a, 4
				ld l, a
				ld [hl], TILE_PLAYER_WALKING_2_L
				ret