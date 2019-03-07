`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: DFlop.v
 * Date: 	  March 10, 2017
 * Notes:     A general DFlop that generates 1 clock delay for a register.
 
=================================================================================*/
module DFlop(clk, reset, D, Q);
   input clk, reset, D;
   output reg Q;
   
   always @(posedge clk, posedge reset)
      if(reset)
         Q <= 0;
      else
         Q <= D;
       
endmodule
