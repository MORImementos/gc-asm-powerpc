#To be inserted at 8063FAB4
.set stad_id, 0x800e8705

stwu sp, -0x80 (sp) #Push stack, make space for 29 registers
stmw r3, 0x8 (sp)
b check_if_toy_field


check_if_toy_field:
  lis r12, stad_id@h
  ori r12, r12, stad_id@l
  lbz r12, 0(r12)
  cmpwi r12, 0x6 #toy field id
  bne other_stad
  b toy_field

other_stad:
  lmw r3, 0x8 (sp)
  addi sp, sp, 0x80 #Pop stack
  cmpwi r29, 0x3 # default instruction
  b end

toy_field:
  lmw r3, 0x8 (sp)
  addi sp, sp, 0x80
  cmpwi r29, 0
  b end

end: