INCLUDE "constants_system.inc"
INCLUDE "assets/tiles/tiles.inc"
;INCLUDE "entities/enemies/enemies.inc"

SECTION "Jumping alien", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file contains the definition of a static 
;; frog enemy. It jumps in the same position.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

jumping_alien_l::

.initial_tile: 			DB TILE_JUMPING_ALIEN_1_L ;; ENEMY_TILE_L
;.initial_tile_r: 			DB TILE_JUMPING_ALIEN_1_R ;; ENEMY_TILE_R
.initial_sprite_attrs: 	DB  0		 	          ;; ENEMY_INITAL_SPRITE_ATTRIBUTES
.initial_y_speed: 		DB -3 		 	          ;; ENEMY_INITIAL_VY_SPEED
.initial_x_speed: 		DB  0		 	          ;; ENEMY_INITIAL_VX_SPEED

.enemy_flags: DB %00001000 				        ;; ENEMY_FLAGS
;; 3 E_BIT_INTELLIGENT_ENEMY

.enemy_interaction: DB %11011100 		        ;; ENEMY_ENVIRONMENT_INTERACTION
; 7 E_BIT_MOVABLE
; 6 E_BIT_GRAVITY
; 5 E_BIT_DIES_OUT_OF_SCREEN
; 4 E_BIT_COLLIDABLE
; 3 E_BIT_DAMAGEABLE
; 2 E_BIT_STICK_TO_EDGES

.enemy_life: DB 	1 					;; ENEMY_LIFE
.enemy_height: DB   16                   ;; ENEMY_HEIGHT
.enemy_width:  DB   8                   ;; ENEMY_WIDTH 
.enemy_AI_1: DW_BE	AI_jumping_enemy 	;; ENEMY_AI_1
.enemy_AI_2: DW_BE 	No_AI				;; ENEMY_AI_2
.enemy_AI_3: DW_BE  No_AI				;; ENEMY_AI_2

.end_definition:







jumping_alien_r::

.initial_tile: 			DB TILE_JUMPING_ALIEN_1_R ;; ENEMY_TILE_R
.initial_sprite_attrs: 	DB  0		 	          ;; ENEMY_INITAL_SPRITE_ATTRIBUTES
.initial_y_speed: 		DB -3 		 	          ;; ENEMY_INITIAL_VY_SPEED
.initial_x_speed: 		DB  0		 	          ;; ENEMY_INITIAL_VX_SPEED

.enemy_flags: DB %00001000 				        ;; ENEMY_FLAGS
;; 3 E_BIT_INTELLIGENT_ENEMY

.enemy_interaction: DB %11011100 		        ;; ENEMY_ENVIRONMENT_INTERACTION
; 7 E_BIT_MOVABLE
; 6 E_BIT_GRAVITY
; 5 E_BIT_DIES_OUT_OF_SCREEN
; 4 E_BIT_COLLIDABLE
; 3 E_BIT_DAMAGEABLE
; 2 E_BIT_STICK_TO_EDGES

.enemy_life: DB 	 1					;; ENEMY_LIFE
.enemy_height: DB   16                  ;; ENEMY_HEIGHT
.enemy_width:  DB    8                  ;; ENEMY_WIDTH 
.enemy_AI_1: DW_BE	AI_jumping_enemy 	;; ENEMY_AI_1
.enemy_AI_2: DW_BE 	No_AI				;; ENEMY_AI_2
.enemy_AI_3: DW_BE  No_AI				;; ENEMY_AI_2

.end_definition:
