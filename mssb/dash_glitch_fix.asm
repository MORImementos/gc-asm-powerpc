.set dash_fielder,0x80892764
.set mfs_hand_1, 0x80892800
.set in_game, 0x80892AB5
.set mfs_hand_0, 0x80892806
.set dash_state, 0x8089276a

# this code runs once per frame when in game

stwu sp, -0x80 (sp) #Push stack, make space for 29 registers
stmw r3, 0x8 (sp)
b check_in_game

check_in_game:
  lis r12, in_game@h
  ori r12, r12, in_game@l
  lbz r12, 0(r12)
  cmpwi r12, 0x1 # if 1, in game so check for dash
  bne end

  b check_dash

check_dash:
  lis r12, dash_state@h
  ori r12, r12, dash_state@l
  lbz r12, 0(r12)
  cmpwi r12, 0x0 # if not dashing, skip, else see who the fielder is
  bne check_fielder
  b end

check_fielder:

  lis r12, dash_fielder@h
  ori r12, r12, dash_fielder@l
  lis r11, mfs_hand_1@h
  ori r11, r11, mfs_hand_1@l

  lhz r9, 0(r11)
  lhz r10, 0(r12)

  cmpw r10, r9 # if the dashing fielder and the active fielder are the same, no dash glitch is happening

  beq end
  cmpwi r10, 0xff # if there is no dashing fielder at all, no dash glitch should be happening
  beq end
  sth r9, 0(r12) # if mismatched, write the active fielder to the dashing fielder address
  b end

end:

  lmw r3, 0x8 (sp)
  addi sp, sp, 0x80 #Pop stack
  blr
