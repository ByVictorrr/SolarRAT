# SolarRAT

![solar rat logo]()

### Project designed by:
Julio Tena

Victor Delaplaine

Javier Flores 

## Mechanism
Using A RAT MCU Created int CPE233, to input a set of data from a solar panel and have a bubble sort algorithm run every 5 min finding the highest voltage position.


## SolarRAT_Driver

This module interacts with a arduino, its outputs are digital writes the arduino
controlling the servo motor. The Driver has a architecre of 8 bits length and
its first 4 bits are the data of light intensity (in Volts) and corresponding to
the 4 least bits is the location



### Table 1 - sweep function
 |  output from basys3  | Servo Rotation(Degrees)  | 
 |----------------------|--------------------------|
 |0000                  |    0°                    |  
 |0001                  |    15°                   |  
 |0010                  |    30°                   |
 |0011                  |    45°                   |  
 |0100                  |    60°                   |  
 |0101                  |    75°                   |  
 |0110                  |    90°                   |
 |0111                  |    105°                  |  
 |1000                  |    120°                  |  
 |1001                  |    135°                  |  
 |1010                  |    150°                  |
 |1011                  |    165°                  |  
 |1100                  |    180°                  | 
 

## FirmWare

[SolarRAT Driver](https://github.com/ByVictorrr/SolarRAT/blob/master/SolarRAT_Driver/ASM/main.asm)

![Flow Chart of firmware](https://github.com/ByVictorrr/SolarRAT/tree/master/SolarRAT_Driver/ASM/Flowcharts/images/main.png)

### Delay time - 2S

Since the Rat MCU completes one instruction / 40ns, and we want the function delay to delay 2s so equating a general equation below gives us an equation below that.

![gen equation delay](https://latex.codecogs.com/gif.latex?N_%7B1%2C2%2C3tot%7D%20%3D%20%5B%5B%5B%5BN_%7B3%7D*C_%7B3%7D%5D&plus;N_%7B2%7D%20%5D%20*C_%7B2%7D%5D%20&plus;%20N_1%5D*%20C_1%20&plus;%20N_%7Bol%7D%20%250)

where N_i corresonds to the ith loop

where C_i corresponds to the ith loop

i=1(outermost),

2(middle),

3(inner)

![eqn 2s Delay](https://latex.codecogs.com/gif.latex?C_1%3D%5Cfrac%7B50000000-N_o%7D%7BC_2%5Cleft%28N_2&plus;N_3C_3%5Cright%29&plus;N_1%7D%3B%5Cquad%20%5C%3AN_3%5Cne%20%5Cfrac%7B-N_1-N_2C_2%7D%7BC_3C_2%7D)

Using the guess in check method for all parameters we get:


![plugging in to 2s delay](https://latex.codecogs.com/gif.latex?C_1%28N_%7Bol%7D%20%3D2%20%2CN_1%20%3D%2010%2C%20N_2%20%3D%204%2C%20N_3%3D%206%2C%20C_2%20%3D%20176%2C%20C_3%20%3D236%20%29%20%5Capprox%20201%250)





## Hardware
[Basys 3 Artix-7 FPGA](https://store.digilentinc.com/basys-3-artix-7-fpga-trainer-board-recommended-for-introductory-users/)

[9g Micro Servo Motor (4.8V)](https://www.robotshop.com/en/9g-micro-servo-motor-4-8v.html)

[1787AHC125 - FRIENDLY 8-BIT LOGIC LEVEL SHIFTER](https://www.adafruit.com/product/735)

[Photoresistor](https://www.adafruit.com/product/161)

[3d print for Servo](https://www.thingiverse.com/thing:2271734)

[Mini solar panel](https://www.amazon.com/gp/product/B0736W4HK1/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)


## Reference Links

3D joints - 
https://www.thingiverse.com/thing:2271734

Stepper-to-PVC 3D-Part - 
https://www.thingiverse.com/thing:53321

Servo Motor - 
http://www.ee.ic.ac.uk/pcheung/teaching/de1_ee/stores/sg90_datasheet.pdf

Level Shifter - 
https://cdn-shop.adafruit.com/product-files/1787/1787AHC125.pdf

3D Printing Services on Campus - 
https://www.theinnovationsandbox.com/

BASYS3 XADC Demo- 
https://github.com/Digilent/Basys-3-XADC?_ga=2.28328696.598648131.1551755682-1318774948.1543268595)

7 Series FPGA XADC - 
https://www.xilinx.com/support/documentation/user_guides/ug480_7Series_XADC.pdf?_ga=2.35717988.598648131.1551755682-1318774948.1543268595
