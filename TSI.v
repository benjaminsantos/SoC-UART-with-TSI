`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 3 - Full UART Receiver and Transmitter
 * File Name: TSI.v
 * Date: 	  March 27, 2018
 
 * Notes:     Top Level module of the Universal Asynchronous Receiver-Transmitter
              or UART, with the Tramelblaze to read and write to the 
              serial capture program(Realterm) using a Nexys4DDR board.
=================================================================================*/
module TSI(clk_in, reset_in, BAUD_in, EIGHT_in, PEN_in, OHEL_in, RX_in, TX_out, LEDS_out,
           clk_out, reset_out, BAUD_out, EIGHT_out, PEN_out, OHEL_out, RX_out, TX_in, LEDS_in);
           
   input        clk_in, reset_in, EIGHT_in, PEN_in, OHEL_in, RX_in, TX_in;
   input  [3:0] BAUD_in;
   input [15:0] LEDS_in;
   output       clk_out, reset_out, EIGHT_out, PEN_out, OHEL_out, RX_out, TX_out;
   output [3:0] BAUD_out;
   output[15:0] LEDS_out;
   
   IBUFG #( .IOSTANDARD("DEFAULT") )
      SYS_CLOCK ( .O(clk_out), .I(clk_in) );

   IBUF  #( .IOSTANDARD("DEFAULT") )
      SYS_RESET ( .O(reset_out), .I(reset_in) );
   
   IBUF  #( .IOSTANDARD("DEFAULT") )
      BAUD [3:0]( .O(BAUD_out[3:0]),  .I(BAUD_in[3:0])  );
   
   IBUF  #( .IOSTANDARD("DEFAULT") )
      SYS_EIGHT ( .O(EIGHT_out), .I(EIGHT_in) );

   IBUF  #( .IOSTANDARD("DEFAULT") )
      SYS_PEN   ( .O(PEN_out),   .I(PEN_in)   );

   IBUF  #( .IOSTANDARD("DEFAULT") )
      SYS_OHEL  ( .O(OHEL_out),  .I(OHEL_in)  );

   IBUF  #( .IOSTANDARD("DEFAULT") )     
      SYS_RX    ( .O(RX_out),    .I(RX_in)    );

   OBUF  #( .IOSTANDARD("DEFAULT") )
      SYS_TX    ( .O(TX_out),     .I(TX_in)   );
   
   OBUF  #( .IOSTANDARD("DEFAULT") )
      LEDS [15:0] ( .O(LEDS_out[15:0]),   .I(LEDS_in[15:0]) );

endmodule
