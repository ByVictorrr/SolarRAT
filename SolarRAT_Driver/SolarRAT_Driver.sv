/*`include "RAT_MCU/RAT_MCU.sv"
`include "/Modules/mux_2t1_nb.v"
`include "Modules/univ_sseg.v"
`include "PER/debounce_one_shot.sv"
`include "XADC/XADC.v"
`include "../PER/dataOut.sv"
*/


//////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Victor
// Edited by: Victor Delaplaine
// Create Date: 06/28/2018 05:21:01 AM
// Module Name: SolarRAT_DRIVER
// Target Devices: RAT MCU on Basys3
// Description: Basic SolarRAT_Driver
//
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////

module SolarRAT_Driver(

    input CLK,
    input BTNL,
    input BTNR,
    input [7:0] SW,
    input vauxp6, //for wizard adc
    input vauxn6,
    output [7:0] Arduino_Data,
    output reg [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output dp
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam SW_ID = 8'hFF;
    localparam LIGHT_ID     = 8'h96;
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam SEG_ID       = 8'h81;
    localparam ARDUINO_ID   = 8'h69;
    
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic IO_STRB;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    logic [7:0] SEV_SEG; 
    logic [3:0] LIGHT_IN;
    
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_seg = 8'h00;
    logic [7:0]   r_arduino = 8'b00;
    
    
    // Declare RAT_CPU ///////////////////////////////////////////////////////
    RAT_MCU MCU (.IN_PORT(s_input_port), 
	    	.OUT_PORT(s_output_port),
            	.PORT_ID(s_port_id), 
	   	.IO_STRB(IO_STRB), 
	       	.RESET(s_reset),
            	.INTR(s_interrupt), 
	    	.CLK(s_clk_50));
   
	
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end
    

    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == SW_ID)
            s_input_port = SW;
        else if (s_port_id == LIGHT_ID)
            s_input_port = {LIGHT_IN,4'b000};
	else
	    s_input_port = 0;
    end

//MUX and output reg
    always_ff @ (posedge CLK) begin
        if (IO_STRB == 1'b1) begin
	       if (s_port_id == SEG_ID)
	        r_seg <= s_output_port;
	    else if (s_port_id == ARDUINO_ID)
    	        r_arduino <= s_output_port;
            end
        end
    
/*    
univ_sseg Univ( 	
	.cnt1(SEV_SEG),                                                                                    
   	.cnt2(0),                                                                                     
    	.valid(1), 
    	.dp_en(0),                                                                                          
    	.dp_sel(0),                                                                                   
     	.mod_sel(0),                                                                                  
     	.sign(0),                                                                                           
     	.clk(CLK),                                                                                            
    	.ssegs(seg),                                                                               
    	.disp_en(an) 
);
*/

debounce_one_shot ONESHOT(
		.CLK(s_clk_50),
    		.BTN(BTNL),
    		.DB_BTN(s_interrupt)
    );

//Analog to ditial converter  
XADC WIZARD(
    .CLK100MHZ(CLK),
    .vauxp6(vauxp6),
    .vauxn6(vauxn6),
   //.sw(SW[1:0]),
    .led(led),
    .an(an),
    .dp(dp),
    .seg(seg),
    .data_digital(LIGHT_IN)
    );
    

    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNR;
    //assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    assign SEV_SEG =r_seg;
    assign Arduino_Data = r_arduino;
      
    endmodule
