INCLUDE "system/sound_manager/hUGE.inc"

SECTION "Music Song Data", ROM0

game_music::
db 7
dw music_order_cnt
dw music_order1, music_order2, music_order3, music_order4
dw _duty_instruments, _wave_instruments, _noise_instruments
dw _music_game_routines
dw _music_game_waves

music_order_cnt: db 8
music_order1: dw P0, P0, P0, P0
music_order2: dw P11,P11,P11,P12
music_order3: dw empty_track,empty_track,empty_track,empty_track
music_order4: dw empty_track,empty_track,empty_track,empty_track


P0:
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn F_3,1,$C0C
 dn C_3,1,$C09
 dn F_3,1,$C08
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn D_3,1,$C0C
 dn C_3,1,$C09
 dn D_3,1,$C08
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn F_3,1,$C0C
 dn C_3,1,$C09
 dn F_3,1,$C08
 dn C_3,1,$C0F
 dn E_3,1,$C0C
 dn C_3,1,$C09
 dn E_3,1,$C08
 dn C_3,1,$C0F
 dn G_3,1,$C0C
 dn C_3,1,$C09
 dn G_3,1,$C08







P11:
 dn E_4,1,$C0F
 dn D_4,1,$C0C
 dn D#4,1,$C0C
 dn E_4,1,$C0C
 dn F_4,1,$C0F
 dn D#4,1,$C0C
 dn E_4,1,$C0C
 dn F_4,1,$C0C
 dn F#4,1,$C0F
 dn E_4,1,$C0C
 dn F_4,1,$C0C
 dn F#4,1,$C0C
 dn G_4,1,$C0F
 dn F_4,1,$C0C
 dn F#4,1,$C0C
 dn G_4,1,$C0C
 dn G#4,1,$C0F
 dn G_4,1,$C0C
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn G_4,1,$C0F
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn F#4,1,$C0F
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn D#4,1,$C0C
 dn F_4,1,$C0F
 dn E_4,1,$C0C
 dn D#4,1,$C0C
 dn D_4,1,$C0C

P12:
 dn A#4,1,$C0F
 dn B_4,1,$C0C
 dn A#4,1,$C0C
 dn A_4,1,$C0C
 dn B_4,1,$C0F
 dn A#4,1,$C0C
 dn A_4,1,$C0C
 dn G#4,1,$C0C
 dn A#4,1,$C0F
 dn A_4,1,$C0C
 dn G#4,1,$C0C
 dn G_4,1,$C0C
 dn A#4,1,$C0F
 dn A_4,1,$C0C
 dn G#4,1,$C0C
 dn G_4,1,$C0C
 dn A_4,1,$C0F
 dn G#4,1,$C0C
 dn G_4,1,$C0C
 dn F#4,1,$C0C
 dn G#4,1,$C0F
 dn G_4,1,$C0C
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn G_4,1,$C0F
 dn F#4,1,$C0C
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn F#4,1,$C0F
 dn F_4,1,$C0C
 dn E_4,1,$C0C
 dn D#4,1,$C0C
