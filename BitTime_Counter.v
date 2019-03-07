`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: BitTime_Counter.v
 * Date: 	  March 10, 2018
 *
 * Notes:     Count clocks to determine the Bit Time in accordance to the
              BAUD Rate provided by the onboard switches.
=================================================================================*/
module BitTime_Counter(clk, reset, DOIT, K, BTU);
   input clk, reset;
   input DOIT;
   input [19:0] K;
   output BTU;
   
   reg [19:0] Q;
   reg [19:0] mQ;
                                    
   always@(posedge clk, posedge reset)
      if(reset)
         Q <= 20'b0; 
      else
         Q <= mQ;
      
   always@(*) begin
      case({DOIT, BTU})
         2'b00: mQ = 0;
         2'b01: mQ = 0;
         2'b10: mQ = Q + 20'b1;  //Bit Counter + 1
         2'b11: mQ = 0;  
      endcase
   end
   
   assign BTU = (Q == K) ? 1'b1 : 1'b0;
         
   
         
endmodule
