.set in_game, 0x80892AB5


stwu sp, -0x80 (sp) #Push stack, make space for 29 registers
stmw r3, 0x8 (sp)
b check_in_game

check_in_game:
  lis r12, in_game@h
  ori r12, r12, in_game@l
  lbz r12, 0(r12)
  cmpwi r12, 0x1 # if 1, in game so check for dash
  bne end

  b write_pitch

write_pitch:
  lis r12, 0x8089 # aiPitchType
  ori r12, r12, 0x2b2e
  li r11, 0x1
  stb r11, 0x0(r12)
  lis r12, 0x8089 # typeOfPitch
  ori r12, r12, 0x0b21
  li r11, 0x1
  stb r11, 0x0(r12)
  lis r12, 0x8089 # perfectChargeInd
  ori r12, r12, 0x2b33
  li r11, 0x1
  stb r11, 0x0(r12)
  b end  

end:

  lmw r3, 0x8 (sp)
  addi sp, sp, 0x80 #Pop stack
  blr


