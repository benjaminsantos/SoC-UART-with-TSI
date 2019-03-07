`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 1 - Counter using the Tramelblaze
 * File Name: Pulse_Maker.v
 * Date: 	  September 19, 2017
 * Notes:     Inputs a debounced tick from the PC_Debounce.v module and generates
              a pulse to be used by the RS_flop.v module
=================================================================================*/
module Pulse_Maker(clk, reset, db, pulse);
   input  clk, reset, db;
   output pulse;
   
   reg temp, temp2;
   always @(posedge clk or posedge reset)
      if (reset) 
         temp <= 1'b0;
      else 
         temp <= db;
      
   always @(posedge clk or posedge reset)
      if (reset)
         temp2 <= 1'b0;
      else
         temp2 <= temp;
         
   assign pulse = temp & ~temp2;
         

endmodule
