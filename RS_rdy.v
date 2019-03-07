`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 1 - Counter using the Tramelblaze
 * File Name: AISO.v
 * Date: 	  September 19, 2017
 * Notes:     RS Flop made specifically for the TXRDY output signal of the TX
 *            TXRDY resets to 1
 *            
 *            If S = 1, Q = 1, and if R = 1, Q = 0. 
=================================================================================*/
module RS_rdy(clk, reset, S, R, Q);
   input        clk, reset, S, R;
   output reg   Q;
  
   always @(posedge clk, posedge reset)
      if(reset)
         Q <= 1'b1;
      else 
       begin
         if(S)          //DONE
            Q <= 1'b1;
         else if(R)     //LOAD
            Q <= 1'b0;
       end

endmodule
