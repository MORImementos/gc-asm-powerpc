# r11: in game > cstick input
# r12: z input > final address
# f9: increment
# f10: value
# f11: max
# f12: min

check_in_game:
  lis r12, 0x8016
  ori r12, r12, 0x2B5F
  lbz r11, 0x0(r12)

  cmpwi r11, 0x1

  beq check_z_input

  b end


check_z_input:
  lis r12, 0x804E
  ori r12, r12, 0xCC8F
  lbz r12, 0x0(r12)

  cmpwi r12, 0x10
  beq check_c_stick_input

  b end

check_c_stick_input:
  lis r11, 0x804E
  ori r11, r11, 0xCC99
  lbz r11, 0x0(r11)

  cmpwi r11, 0x8
  beq wind_speed

  cmpwi r11, 0x4
  beq wind_speed

  cmpwi r11, 0x1
  beq wind_dir

  cmpwi r11, 0x2
  beq wind_dir

  b end

wind_speed:

  lis r12, 0x804D
  ori r12,r12, 0xFDF4

  # load wind speed increment into f9
  lfs f9, 0x0(r12)

  # load const to reduce sensitivity
  #lis r12, 0x8015
  #ori r12, r12, 0xE510
  lis r12, 0x804D
  ori r12, r12, 0xAF04
  lfs f13, 0x0(r12)

  fmuls f9, f9, f13



  lis r12, 0x804E
  ori r12, r12, 0x6854
  
  # load wind speed into f10
  lfs f10, 0x0(r12)
  
  cmpwi r11, 0x8
  beq increase_wind_speed
  
  cmpwi r11, 0x4
  beq decrease_wind_speed
  
  b end


wind_dir:

  lis r12, 0x804D
  ori r12,r12, 0xFDF0

  # load increment
  lfs f9, 0x0(r12)
  
  # wind dir
  lis r12, 0x804E
  ori r12, r12, 0x6850

  # load wind dir
  lfs f10, 0x0(r12)

  cmpwi r11, 0x1
  beq decrease_wind_dir
  
  cmpwi r11, 0x2
  beq increase_wind_dir
  
  b end


increase_wind_speed:
  lis r11, 0x804D
  #ori r11, r11, 0xFDF8
  ori r11, r11, 0xA358

  # load wind speed cap
  lfs f11, 0x0(r11)
  
  fcmpo cr1, f10, f11
  bge cr1, assign_max

  b add_increment


#compare_to_baseline:
  #fcmpo cr1, f10, f11
  #bgt+ cr1, assign_max

  #fcmpo cr1, f10, f12
  #blt- cr1, assign_min

decrease_wind_speed:
  lis r11, 0x804D
  #ori r11, r11, 0xFDD8
  ori r11, r11, 0xA34C
  
  # load wind speed minimum
  lfs f12, 0x0(r11)

  fcmpo cr1, f10, f12
  ble cr1, assign_min

  b subtract_increment

increase_wind_dir:
  lis r11, 0x804E
  ori r11, r11, 0x3198
  
  # load arbitary cap
  lfs f11, 0x0(r11)

  b add_increment

decrease_wind_dir:
  lis r11, 0x8015
  ori r11, r11, 0xD8D8

  lfs f12, 0x0(r11)
  
  b subtract_increment

add_increment:
  fadds f10, f10, f9
  b store_float

subtract_increment:
  fsubs f10, f10, f9
  b store_float

assign_max:
  fmr f10, f11
  b store_float

assign_min:
  fmr f10, f12
  b store_float

store_float:
  stfs f10, 0x0(r12)
  b end




end:
  blr
