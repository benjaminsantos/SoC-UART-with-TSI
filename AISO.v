`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 1 - Counter using the Tramelblaze
 * File Name: AISO.v
 * Date: 	  September 19, 2017
 * Notes:     AISO or "Asynchronous In, Synchronous Out", has an input of an
              Asynchronous reset and outputs a synchronous reset that is active
              IFF the reset is active while the clock is on its active edge.
=================================================================================*/
module AISO(clk, reset, reset_s);
   input       clk, reset;
   output      reset_s;
   
   reg temp_res1, temp_res2;
   
   always @(posedge clk or posedge reset)
      begin
         if (reset)
            temp_res1 <= 1'b0;
         else
            temp_res1 <= 1'b1;          
      end
   
   always @(posedge clk or posedge reset)
      begin
         if (reset)
            temp_res2 <= 1'b0;
         else
            temp_res2 <= temp_res1;
      end
   
   assign reset_s = ~temp_res2;
      

endmodule
