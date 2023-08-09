#To be inserted at 80650110
lis r3, 0x8035
ori r3, r3, 0x3be0
lha r11, 0x60 (r29)
mulli r12, r11, 160
add r11, r3, r12
lis r3, 0x8089
ori r3, r3, 0x09BA
lbz r4, 0(r3)
addi r4, r4, 1
mulli r3, r4, 0x4
add r11, r11, r3
lfs f0, 0x0(r11)