`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 3 - Full UART Receiver and Transmitter
 * File Name: TopLevel_TSI.v
 * Date: 	  March 27, 2018
 
 * Notes:     Top Level module of the Universal Asynchronous Receiver-Transmitter
              or UART, with the Tramelblaze to read and write to the 
              serial capture program(Realterm) using a Nexys4DDR board.
=================================================================================*/
module TopLevel_TSI(clk_100MHz, reset, BAUD, EIGHT, PEN, OHEL, RX, TX,
                    LEDS);
   input clk_100MHz, reset, EIGHT, PEN, OHEL, RX;
   input [3:0] BAUD;
   output TX;
   output [15:0] LEDS;
   
   wire clk_to, reset_to, EIGHT_to, PEN_to, OHEL_to, RX_to, TX_to;
   wire [3:0] BAUD_to;
   wire [15:0] LEDS_to;

   TSI      MOD_TSI
                  (
                   .clk_in(clk_100MHz), 
                   .reset_in(reset), 
                   .BAUD_in(BAUD), 
                   .EIGHT_in(EIGHT), 
                   .PEN_in(PEN), 
                   .OHEL_in(OHEL), 
                   .RX_in(RX), 
                   .TX_out(TX), 
                   .LEDS_out(LEDS),
                   .clk_out(clk_to), 
                   .reset_out(reset_to), 
                   .BAUD_out(BAUD_to), 
                   .EIGHT_out(EIGHT_to), 
                   .PEN_out(PEN_to), 
                   .OHEL_out(OHEL_to), 
                   .RX_out(RX_to), 
                   .TX_in(TX_to), 
                   .LEDS_in(LEDS_to)
                  );
                  
   CORE     MOD_CORE
                  (
                   .clk(clk_to), 
                   .reset(reset_to), 
                   .BAUD(BAUD_to), 
                   .EIGHT(EIGHT_to), 
                   .PEN(PEN_to), 
                   .OHEL(OHEL_to), 
                   .RX_in(RX_to), 
                   .TX_out(TX_to), 
                   .LEDS(LEDS_to)
                  );


endmodule
