;INCLUDE "constants.inc"
INCLUDE "entities/entities.inc"


SECTION "Enemy collisions", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks if an enemy is colliding
;; with the player.
;;
;; INPUT
;;      E: Enemy entity index
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_player_enemy_collision::
    ld l, 0 ; Player entity index
    call are_entities_colliding
    call c, enemy_damage ; If collide, then damage the player - Call it with a different name
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine checks the collisions of the player
;; with the enemies.
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_enemy_collision::
    ;ld a, [wSpikeCooldown]
    ;or a
    ;ret nz 

    ld hl, check_player_enemy_collision
    call man_entity_for_each_enemy
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; enemy_damage
;;; Called when player collides with enemy
;;; Loses 1 life and activates cooldown
;;;
;;; Destroys: A, HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

enemy_damage::
    ; Activar cooldown de 60 frames (1 segundo)
    ;ld a, 60
    ;ld [wSpikeCooldown], a

    ; Perder 1 vida
    ;ld hl, wPlayerLives
    ;dec [hl]

    ; Marcar que HUD necesita actualizarse
    ;call hud_needs_update
    
    call fade_to_black
    call restore_player_position
    call set_normal_gravity
    call fade_to_original
    call set_only_for_sprites
    ret