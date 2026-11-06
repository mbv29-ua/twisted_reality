INCLUDE "system/sound_manager/hUGE.inc"

SECTION "Level 1 Song Data", ROM0

level_1_music::
db 0
dw empty_order_cnt
dw empty_order1, empty_order2, empty_order3, empty_order4
dw _duty_instruments, _wave_instruments, _noise_instruments
dw _music_game_routines
dw _music_game_waves

level_1_order_cnt: db 2
level_1_order1: dw empty_track
level_1_order2: dw empty_track
level_1_order3: dw empty_track
level_1_order4: dw empty_track
