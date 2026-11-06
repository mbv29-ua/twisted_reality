SECTION "Next level check", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; check_door_collision
;;; Checks if player is touching a door tile (tiles $C0-$C3)
;;; and triggers level transition if true
;;; Door tiles have bits 4,5,6 = %010 (DOOR_TILE group)
;;;
;;; Destroys: A, BC, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_next_level::
    ld a, [wRemainingDiamonds]
    and a
    ret nz  ; Not a door, return

    ; Is a door, change level
    ld b, 30
    call wait_x_frames  
    call next_level
    ret

