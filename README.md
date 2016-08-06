# graphics.pl
Overclocking / Fan Control Script for RX480 GPU's @ Ubuntu 16.04 with amdgpu-pro


INSTALL:

Copy script and set execute privileges:
sudo chmod +x graphics.pl


SAMPLE OUTPUT:

# ./graphics.pl
graphics.pl - v1.0.0

Usage: ./graphics.pl get|fan|gpuClock|memClock|pcie [val]

# ./graphics.pl get
gpu_count: 2
##############################################################
name: amdgpu 0000:02:00.0 pci:0000:02:00.0
temp1: 52
pwm1: 145 (0 - 255)
pm_info:
 [  mclk  ]: 1750 MHz

 [  sclk  ]: 1077 MHz

 [GPU load]: 100%

uvd    disabled
vce    disabled
##############################################################
name: amdgpu 0000:01:00.0 pci:0000:01:00.0
temp1: 67
pwm1: 145 (0 - 255)
pm_info:
 [  mclk  ]: 2000 MHz

 [  sclk  ]: 1077 MHz

 [GPU load]: 100%

uvd    disabled
vce    disabled

# ./graphics.pl fan
card0 pwm1: 145
card1 pwm1: 145

# ./graphics.pl memClock
#### card0 has 2 possible settings: ####
 0: 300Mhz
 1: 2000Mhz *
#### card1 has 2 possible settings: ####
 0: 300Mhz
 1: 1750Mhz *
 
# ./graphics.pl gpuClock
#### card0 has 8 possible settings: ####
 0: 300Mhz
 1: 608Mhz
 2: 910Mhz
 3: 1077Mhz *
 4: 1145Mhz
 5: 1191Mhz
 6: 1236Mhz
 7: 1266Mhz
#### card1 has 8 possible settings: ####
 0: 300Mhz
 1: 608Mhz
 2: 910Mhz
 3: 1077Mhz *
 4: 1145Mhz
 5: 1191Mhz
 6: 1236Mhz
 7: 1306Mhz
