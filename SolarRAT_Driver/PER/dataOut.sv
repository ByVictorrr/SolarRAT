`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2019 11:44:36 PM
// Design Name: 
// Module Name: dataOut
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Establish a communication between Basys3 board and Arduino. Master-Slave, respectively. 
//  
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dataOut(
    input clk,
    input logic [1:0] sw,
    output logic data
    );
    
    
    always @(sw)
    begin 
        if(sw == 1)
            data <= 1; // arbitrary number to detect in arduino
        else
            data <= 0;        
    end
endmodule
