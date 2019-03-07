`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 3 - Full UART Receiver and Transmitter
 * File Name: UART.v
 * Date: 	  March 27, 2018
 
 * Notes:     Universal Asynchronous Receiver-Transmitter for serial communication
              with a Serial Capture Program(REALTERM) using the Tramelblaze to 
              communicate according to a written Assembly program (tba) by the 
              Author.
=================================================================================*/
module UART(clk, reset, BAUD, WRITES, READS, OUT_PORT, EIGHT, PEN, OHEL,
            RX_in, TX_out, UART_DS, UART_INT);
   input clk, reset;
   input EIGHT, PEN, OHEL;
   input WRITES;
   input [3:0] BAUD;
   input [1:0] READS;
   input [7:0] OUT_PORT;   
   input RX_in;
   
   output TX_out;
   output [7:0] UART_DS;
   
   output UART_INT;           //interrupt detected (OR of TX and RX interrupt)
   
   wire [19:0] K;             //Integer value of the BAUD rate
   wire [19:0] K_2;           //Half of the Integer value of the BAUD rate
   wire TXRDY, RXRDY;         
   wire [4:0] UART_STATUS;    //OVF, FERR, PERR, TXRDY, RXRDY
   
   wire OVF, FERR, PERR;
   wire [7:0] UART_RDATA;     //DATA from the RX
   wire UART_RXRDY, UART_TXRDY;
      
   // Combinational Logic
   assign UART_STATUS = {OVF, FERR, PERR, TXRDY, RXRDY};
   assign K_2 = {1'b0, K[19:1]};
   assign UART_DS = (READS[1] == 1'b1) ? {3'b111, UART_STATUS} : UART_RDATA; 
   assign UART_INT = UART_TXRDY | UART_RXRDY;  

   BAUD_DECODE    U_BD (.BAUD(BAUD), .K(K));
   
   TX             U_TX (.clk(clk), 
                        .reset(reset),
                        .K(K), 
                        .LOAD(WRITES), 
                        .OUT_PORT(OUT_PORT), 
                        .EIGHT(EIGHT), 
                        .PEN(PEN), 
                        .OHEL(OHEL), 
                        .TXRDY(TXRDY), 
                        .TX_out(TX_out)
                       );
   
   
   RX             U_RX (.clk(clk), .reset(reset), 
                        .K(K), .K_2(K_2), 
                        .RX_in(RX_in), 
                        .READS(READS[0]), 
                        .EIGHT(EIGHT), 
                        .PEN(PEN), 
                        .OHEL(OHEL),
                        .UART_RDATA(UART_RDATA), 
                        .OVF(OVF), 
                        .FERR(FERR), 
                        .PERR(PERR), 
                        .RXRDY(RXRDY)
                       );
   

   Pulse_Maker    U_RXrdy
                       (.clk(clk), 
                        .reset(reset), 
                        .db(RXRDY), 
                        .pulse(UART_RXRDY)
                       );
                       
   Pulse_Maker    U_TXrdy
                       (.clk(clk), 
                        .reset(reset), 
                        .db(TXRDY), 
                        .pulse(UART_TXRDY)
                       );
                       
endmodule
