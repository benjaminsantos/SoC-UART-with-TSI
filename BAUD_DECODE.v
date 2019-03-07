`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: BAUD_DECODE.v
 * Date: 	  March 10, 2018
 *
 * Notes:     Decoder for the set BAUD rates chosen from the switches and the 
              serial capture program(Realterm) for the Bit Time Counter
=================================================================================*/
module BAUD_DECODE(BAUD, K);
   input  [3:0]  BAUD;
   output [19:0] K;
   reg    [19:0] K;
   
   always@(*)
      case(BAUD)
         4'b0000: K = 20'd333333;      // 300
         4'b0001: K = 20'd83333;       // 1200
         4'b0010: K = 20'd41667;       // 2400
         4'b0011: K = 20'd20833;       // 4800
         4'b0100: K = 20'd10417;       // 9600
         4'b0101: K = 20'd5208;        // 19200
         4'b0110: K = 20'd2604;        // 38400
         4'b0111: K = 20'd1736;        // 57600
         4'b1000: K = 20'd868;         // 115200
         4'b1001: K = 20'd434;         // 230400
         4'b1010: K = 20'd217;         // 460800
         4'b1011: K = 20'd109;         // 921600
         default: K = 20'd333333;      //defaulted to slowest speed
      endcase
endmodule
