SECTION "Game start", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine starts the game in the given scene
;;
;; INPUT:
;;      HL: Address of scene.conf
;; OUTPUT:
;;      -   
;; WARNING: Destroys A, BC, DE, HLgit 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start_game::
	call set_initial_memory_values
	ld hl, level_1
   	;ld hl, level_8
    call load_level
	ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine sets the values of the RAM 
;; variables to its initial values.
;;
;; INPUT:
;;      -
;; OUTPUT:
;;      -   
;; WARNING: Destroys A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_initial_memory_values::
    ; Load pseudo-random number generator seed:
    ld hl, wRandomNumber
    ld [hl], 1 ; seed - must be different from 0 

    ; Resetear vidas y balas
    ld a, 0
    ld [wAnimationTimer], a
    ld [wVortexCooldown], a

    ;ld a, GRAVITY
    ;ld [wGravity], a

    ret