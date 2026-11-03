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
	;; call set_initial_memory_values
	ld hl, level_1
    call load_level
	ret
