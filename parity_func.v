`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: parity_func.v
 * Date: 	  March 10, 2018
 *
 * Notes:     Generates bit10 and bit9 for the register that the shiftTX.v loads in
              according to the 3 flags
                  EIGHT - 8 bits to be used
                  PEN   - Parity Enable 
                  OHEL  - Odd High or Even Low for the Parity
=================================================================================*/
module parity_func(LDATA, EIGHT, PEN, OHEL, ten, nine);
   input [7:0] LDATA;
   input EIGHT, PEN, OHEL;
   output reg ten, nine;

   always @(*) begin
      case({EIGHT, PEN, OHEL})
         3'b000: {ten, nine} = 2'b11;
         3'b001: {ten, nine} = 2'b11;
         3'b010: {ten, nine} = {1'b1,  ^LDATA[6:0]};
         3'b011: {ten, nine} = {1'b1, ~^LDATA[6:0]};
         3'b100: {ten, nine} = {1'b1, LDATA[7]};
         3'b101: {ten, nine} = {1'b1, LDATA[7]};
         3'b110: {ten, nine} = { ^LDATA[7:0], LDATA[7]};
         3'b111: {ten, nine} = {~^LDATA[7:0], LDATA[7]};
      endcase
   end

endmodule
