#To be inserted at 8042f36c
# Mario Golf: Toadstool Tour
# in training mode, Z+X increases wind speed, and Z+Y decreases wind speed

# if not training mode skip
cmpwi r9, 0x3
bne SKIP

# p1 input struct
lis r12, 0x8026
ori r12, r12, 0xbb62
# load input
lhz r11, 0x0(r12)

SPEED:
# load speed addr
lis r12, 0x804e
ori r12, r12, 0x6854
# load speed as float
lfs f12, 0x0(r12)
# check for left or right
cmpwi r11, 0x810
beq LEFT
cmpwi r11, 0x410
beq RIGHT
b SKIP

DIR:
# load direction increment - to be done later
lis r9, 0x804d
ori r9, r9, 0xfdf0
lfs f13, 0x0(r9)

# load direction addr
lis r12, 0x804e
ori r12, r12, 0x6850
lfs f12, 0x0(r12)

# check for left or right
cmpwi r11, 0x18
beq UP
cmpwi r11, 0x14
beq DOWN
b SKIP

LEFT:
#load minimum 
lis r9, 0x804d
ori r9, r9, 0xfdd8
lfs f13, 0x0(r9)

# compare to 0.0
fcmpo cr0, f12, f13
ble SKIP

# if not zero, subtract 1.0
lis r12, 0x804d
ori r12, r12, 0xfdf4
lfs f13, 0x0(r12)
fsubs f12, f12, f13
b DONE

RIGHT:
# load maximum as float
lis r9, 0x804d
ori r9, r9, 0xfdf8
lfs f13, 0x0(r9)

# compare to 10.0
fcmpo cr0, f12, f13
bge SKIP

# if not 10 add 1.0
lis r12, 0x804d
ori r12, r12, 0xfdf4
lfs f13, 0x0(r12)
fadds f12, f12, f13
b DONE

UP:
b DONE

DOWN:
b DONE

DONE:
lis r11, 0x804e
ori r11, r11, 0x6854
stfs f12, 0x0(r11)


SKIP:
li r9, 3


END:
