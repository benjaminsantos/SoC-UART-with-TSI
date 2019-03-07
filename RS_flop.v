`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: RS_flop.v
 * Date: 	  February 8, 2018
 *
 * Notes:     If S = 1, Q = 1, and if R = 1, Q = 0. 
 *
 * For Tramelblaze:
 *            If the Positive Edge Detect signal from the TX engine(S) is active,
 *            the tramelblaze will recieve the interrupt signal while if the 
 *            Interrupt Acknowledged flag(R) is active, the tramelblaze will not
 *            receive the interrupt signal.
 * For Transmit:
 *            If the LOADD1(S) signal is active, the signal DOIT for the Bit Time
 *            Counter and the Bit Counter while if the DONE(R) signal is active, 
 *            DOIT will be inactive.
=================================================================================*/
module RS_flop(clk, reset, S, R, Q);
   input        clk, reset, S, R;
   output reg   Q;
  
   always @(posedge clk, posedge reset)
      if(reset)
         Q <= 1'b0;
      else 
       begin
         if(S)
            Q <= 1'b1;
         else if(R)
            Q <= 1'b0;
       end

endmodule
