INCLUDE "utils/joypad.inc"
INCLUDE "constants_system.inc"
INCLUDE "system/text_manager/text_manager_constants.inc"
INCLUDE "utils/arithmetic_macros.inc"

SECTION "Text manager", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans a line of the text.
;; position
;;
;; INPUT
;;      HL: line to be cleaned
;; OUTPUT:
;;      -
;; WARNING: Destroys B and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clean_line::
	push hl
	call wait_vblank
	ld  b, TEXTLINE_SIZE
	pop hl
	call memreset_256
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans the dialog box
;;
;; INPUT
;;      -
;; OUTPUT:
;;      -
;; WARNING: Destroys A, B and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clean_dialog_box::
	di
	ld hl, FIRST_DIALOG_LINE
	call clean_line

	ld hl, SECOND_DIALOG_LINE
	call clean_line

	ld hl, THIRD_DIALOG_LINE
	call clean_line

	ld hl, FOURTH_DIALOG_LINE
	call clean_line

	ld hl, FIFTH_DIALOG_LINE
	call clean_line

	ld hl, SIXTH_DIALOG_LINE
	call clean_line
	ei
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine cleans a line of the text.
;; position
;;
;; INPUT
;; 		HL: text address
;; 		DE: line to write the text
;; OUTPUT:
;;      	A: ENDLINE or ENDTEXT
;; WARNING: Destroys A, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

write_line::
	.loop:
		; We wait 4 or 1 frames depending if A is pressed or not
		push hl
		call read_pad
		ld a, [PRESSED_BUTTONS] 
		bit BUTTON_A, a
		jr nz, .write_faster
			call wait_a_frame
			call wait_a_frame
			call wait_a_frame
		.write_faster:
		call wait_a_frame
		pop hl

		ld a, [hl+]
		; We check if we reached the end of the line
		cp ENDLINE
		ret z

		; We check if we reached the end of the text
		cp ENDTEXT
		ret z

		; We write the character
	    ld [de], a
   		inc de
		jr .loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This routine writes a lines of text
;;
;; INPUT
;; 		HL: text address
;; OUTPUT:
;;      A: ENDLINE or ENDTEXT
;; WARNING: Destroys A, BC, DE and HL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

write_text:
	ld de, FIRST_DIALOG_LINE
	.loop:
		push de
		call write_line ; Outputs ENDLINE or ENDTEXT in A
		pop de
		cp ENDTEXT
		jr z, .end_dialog

		ld bc, $20
		add_de_bc
		jr .loop

	.end_dialog
		call wait_until_A_pressed
		call clean_dialog_box
		ret
