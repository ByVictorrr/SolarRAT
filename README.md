# SolarRAT

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


## Delay time - 2S

![eqn 2s Delay(https://latex.codecogs.com/gif.latex?C_1%3D%5Cfrac%7B50000000-N_o%7D%7BC_2%5Cleft%28N_2&plus;N_3C_3%5Cright%29&plus;N_1%7D%3B%5Cquad%20%5C%3AN_3%5Cne%20%5Cfrac%7B-N_1-N_2C_2%7D%7BC_3C_2%7D)



## Mapping Values - PER 2 

### Table 1 - SW mapping to rotational of servo
 | SW  | Duty Cycle  | Rotation(Degrees)  | 
 |-----|-------------|--------------------|
 | 12  |     5%      |   0 °              |  
 | 19  |     7.8%    |   90 °             |  
 | 25  |  10.157 %   |   180 °            |  




### Input to Circuit 

* SW = 35 => 7.8 % duty cycle = > rotate motor 90 degrees (Well 7.5 % duty cycle should)

* SW =  => 10.2 % duty cycle = > rotate motor 180 degrees (Well 10 % duty cycle should)

## FirmWare

[Servo Driver]


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
