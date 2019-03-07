`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: loadREG.v
 * Date: 	  February 8, 2018
 *
 * Notes:     Register(Q) that accepts the value D only if the LOAD flag is active
=================================================================================*/
module loadREG(clk, reset, load, D, Q);
   input clk, reset, load;
   input [7:0] D;
   output reg [7:0] Q;
   
   always @(posedge clk, posedge reset) begin
      if(reset)
         Q <= 16'b0;
      else
         if(load)
            Q <= D;
         else
            Q <= Q;
   end
   
endmodule
