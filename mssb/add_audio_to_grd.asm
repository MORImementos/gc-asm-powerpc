#To be inserted at 80645b3c
stb r0, 0x1bd1(r5)

stwu sp,-0x80 (sp) #Push stack, make space for 29 registers
stmw r3, 0x8 (sp)

li r3, 0x159 # argument for GRD audio
lis r12, 0x806C
ori r12, r12, 0xF328 # function address
mtctr r12 # call sfx function
bctrl 

lmw r3, 0x8 (sp)
addi sp, sp, 0x80 #Pop stack
