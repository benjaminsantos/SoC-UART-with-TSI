`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: shiftTX.v
 * Date: 	  March 10, 2018
 *
 * Notes:     Shift Register for the TX that generates the bit that the TX
              outputs according to the flags, LD1 and SH.
                  LD1 - Loads in the elevenIN from an outside source into the 
                        inner register (SR)    [Highest Priority]
                  SH  - Shifts 1 bit of 1 into the inner register(SR) to the right        
=================================================================================*/
module shiftTX(clk, reset, elevenIN, LD1, SH, SDI, SD0);
   input clk, reset;
   input [10:0] elevenIN;
   input LD1, SH, SDI;
   output SD0;
   
   reg [10:0] SR; //shift register
   
   always @(posedge clk, posedge reset)
      if(reset)
         SR <= 11'b11111111111;
      else
         if(LD1)
            SR <= elevenIN;
         else if(SH)
            SR <= {1'b1, SR[10:1]};
         else
            SR <= SR;
            
   assign SD0 = SR[0];  
   

endmodule
