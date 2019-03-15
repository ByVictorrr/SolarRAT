# SolarRAT - Solar Tracker that is RAT fast 

![solar rat logo](https://github.com/ByVictorrr/SolarRAT/blob/master/images/SolarRat_Logo.png)

* Allows you to optimize solar energy automomously
* Works as a manual tracker

Note: This project had to completed in less than a week, so there are some minor bugs.



### Project designed by:
Julio Tena

Victor Delaplaine

Javier Flores 

Instructor: Dr. Benson

[Project report](https://github.com/ByVictorrr/SolarRAT/blob/master/SolarRAT.pdf) 

## How SolarRAT works

Using A RAT MCU Created in CPE233, to input a set of data from a photoresitor using a servo to go through different set of locations (defined as a sweep subroutine). These locations (0-12 [4-bits] shown below in table 1) and the corresonding photon intensity (0-1V [4-bits]) are concatentated into one 8-bit register to be stored in the sctrach ram of the RAT MCU. This sweep repeats until it goes from location 0-12, then a bubble sort algorithm is then called. This bubble sort sorts the highest Register[7:4] value on the top os the stack(TOS). After a goToBestLocation is called to pop the highest voltage value of the stack and is outputed to the servo_driver(arduino) to give the servo instructions to stay there for a longer time than usual. 

![sweep video](https://github.com/ByVictorrr/SolarRAT/blob/master/images/sweep.gif)


This procedure repeats until someone presses the BTNL button the RATMCU, this will put the Solar_RAT in manual mode and one can perform the operations shown in table 2.

![manual mode](https://github.com/ByVictorrr/SolarRAT/blob/master/images/manual_mode.gif)

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
 
### Table 2 - isr (manual mode)
 | output[7:0](from basys3)  | Servo Rotation(Degrees)  | 
 |---------------------------|--------------------------|
 |100000_00                  |    15°                   |  
 |100000_01                  |    75°                   |  
 |100000_10                  |    135°                  |  
 |100000_11                  |sweep(no data collection) | 
 |000000_00                  |    sweep                 |  
 |000000_01                  |    sweep                 |  
 |000000_10                  |    sweep                 |  
 |000000_11                  |    sweep                 | 


* Note that output[7] tells the arduino that we currently in manual mode.

### XADC

The XADC ports required a special implementation of the module that was done with the help of a wizard in the Vivado software. A short explanation is described below. The following guide works with Vivado 2018.2. Other version may have different ways of enabling the XADC ports.

1.) In the Flow Navigator Window located in the left side of the code, locate and click on IP Catalog

![ip catalog](https://github.com/ByVictorrr/SolarRAT/blob/master/images/ip_catalog.png)

2.) Scroll to find the FPGA Features and Design folder and expand. Select XADC → XADC Wizard

![wizard xadc](https://github.com/ByVictorrr/SolarRAT/blob/master/images/xadc_wizard.png)

3.) Under the Basic tab, select Channel Sequencer and select the Channel Sequencer tab.

Note: At the top, the Component Name can be edited. This is the same as naming a module.

![ch seq 1](https://github.com/ByVictorrr/SolarRAT/blob/master/images/channel_sequencer.png)

4.) Select the appropriate channel-pair to enable. More than one can be enabled. 

Note: This example uses only 1 channel-pair

![ch seq 2](https://github.com/ByVictorrr/SolarRAT/blob/master/images/channel_sequencer_2.png)

5.) Finish by pressing OK at bottom right corner. 

6.) The module can now be instantiated with the rest of your project. For more information see Appendix.

This xadc tutorial was writen by [Julio Tena](https://github.com/jctenav)

## Servo_Driver

This was the external module we attached to the SolarRat driver. It was used mainly as a decoder for the reason the arduino has a built in servo library.

## FirmWare

### RAT_MCU CODE
[SolarRAT Driver](https://github.com/ByVictorrr/SolarRAT/blob/master/SolarRAT_Driver/ASM/main.asm)

![Flow Chart of firmware](https://github.com/ByVictorrr/SolarRAT/blob/master/SolarRAT_Driver/ASM/Flowcharts/images/main.png)


#### Delay time - 2S

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


This source code was entirely writen by [Victor Delaplaine](https://github.com/byvictorrr)

### ARDUINO CODE 
[Servo Driver](https://github.com/ByVictorrr/SolarRAT/blob/master/images/SolarRAT_assembled.jpg)

This source code was entirely writen by [Julio Tena](https://github.com/jctenav)

### VERILOG HDL (RAT MCU)

[mcu](https://github.com/ByVictorrr/SolarRAT/tree/master/SolarRAT_Driver/RAT_MCU)


![MCU](https://github.com/ByVictorrr/SolarRAT/blob/master/images/MCU_RTL.png)

This source code was developed over the course of CPE233 by [Julio Tena](https://github.com/jctenav) and [Victor Delaplaine](https://github.com/byvictorrr)

## Sschematic

![computer schematic](https://github.com/ByVictorrr/SolarRAT/blob/master/images/Basys_Arduino_Servo_connection_with_photoresistor.png)

## Hardware

![assembled schematic](https://github.com/ByVictorrr/SolarRAT/blob/master/images/SolarRAT_assembled.jpg)

[Basys 3 Artix-7 FPGA](https://store.digilentinc.com/basys-3-artix-7-fpga-trainer-board-recommended-for-introductory-users/)

[Arduino uno](https://store.arduino.cc/usa/arduino-uno-rev3)

[9g Micro Servo Motor (4.8V)](https://www.robotshop.com/en/9g-micro-servo-motor-4-8v.html)

[Photoresistor](https://www.adafruit.com/product/161)

[Potentiometer ](https://www.adafruit.com/product/562?gclid=CjwKCAjw96fkBRA2EiwAKZjFTSLwvKly44EqbvIkXQ16QzZ4vzWpp0l6KcqAAFwjvVuQISN1syU8zBoCd88QAvD_BwE)

[3d print for Servo](https://www.thingiverse.com/thing:2271734)

[Mini solar panel](https://www.amazon.com/gp/product/B0736W4HK1/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)

## Reference Links

3D joints - 
https://www.thingiverse.com/thing:2271734

Stepper-to-PVC 3D-Part - 
https://www.thingiverse.com/thing:53321

Servo Motor - 
http://www.ee.ic.ac.uk/pcheung/teaching/de1_ee/stores/sg90_datasheet.pdf

3D Printing Services on Campus - 
https://www.theinnovationsandbox.com/

BASYS3 XADC Demo- 
https://github.com/Digilent/Basys-3-XADC?_ga=2.28328696.598648131.1551755682-1318774948.1543268595)

7 Series FPGA XADC - 
https://www.xilinx.com/support/documentation/user_guides/ug480_7Series_XADC.pdf?_ga=2.35717988.598648131.1551755682-1318774948.1543268595
