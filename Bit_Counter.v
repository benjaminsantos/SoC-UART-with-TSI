`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: Bit_Counter.v
 * Date: 	  March 10, 2018
 *
 * Notes:     Count bits and determine if the TX is done transmitting data.
=================================================================================*/
module Bit_Counter(clk, reset, DOIT, BTU, DONE, mQ);
   input clk, reset;
   input DOIT, BTU;
   output DONE;
   
   reg [3:0]  Q;
   output reg [3:0] mQ;
         
   always@(posedge clk, posedge reset)
      if(reset)
         Q <= 4'b0;
      else
         Q <= mQ;
      
   always@(*) begin
      case({DOIT, BTU})
         2'b00: mQ = 0;
         2'b01: mQ = 0;
         2'b10: mQ = Q;         //Latch
         2'b11: mQ = Q + 4'b1;  //Bit Counter + 1
      endcase
   end
   
   assign DONE = (Q == 11) ? 1'b1 : 1'b0;

endmodule
