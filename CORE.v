`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 3 - Full UART Receiver and Transmitter
 * File Name: CORE.v
 * Date: 	  March 27, 2018
 
 * Notes:     Top Level module of the Universal Asynchronous Receiver-Transmitter
              or UART, with the Tramelblaze to read and write to the 
              serial capture program(Realterm) using a Nexys4DDR board.
=================================================================================*/
module CORE(clk, reset, BAUD, EIGHT, PEN, OHEL, RX_in, TX_out, LEDS);
   input clk, reset;
   input [3:0] BAUD;
   input EIGHT, PEN, OHEL;
   
   input  RX_in;             // The serial input received from the REALTERM
   output TX_out;            // The serial output to be received by REALTERM
   
   output reg [15:0] LEDS;   // The onboard LEDs that run from left to right

   wire reset_s;             // Asynchronous reset generated by AISO.v
   wire PED;                 // Positive Edge Detect of the UART_INT signal
   
   wire WS;                  // Write Strobe generated by the Tramelblaze
   wire RS;                  // Read Strobe generated by the Tramelblaze
   wire [15:0] PID;          // Port ID output of the Tramelblaze
   wire [15:0] OUT_PORT;     // OUT_PORT generated by the Tramelblaze
                             // used by the TX
                             
   wire [7:0]  UART_DS;      // UART_DS generated by the UART to the Tramelblaze
   
   wire TXRDY;               // ready flag of the TX
   wire RXRDY;               // ready flag of the RX
   wire int_ack;             // Interrupt Acknowledged Flag from the Tramelblaze

   wire UART_INT;            // Interrupt generated by the UART
   
   reg [15:0] WRITES;        // Generated signals by the ADDRESS DECODER
   reg [15:0] READS;         //    for the UART
   
   AISO        MOD_1 (
                      .clk(clk), 
                      .reset(reset),
                      .reset_s(reset_s)
                     );      
   
   UART        MOD_2 (
                      .clk(clk), 
                      .reset(reset_s), 
                      .BAUD(BAUD), 
                      .WRITES(WRITES[0]),
                      .READS(READS[1:0]), 
                      .OUT_PORT(OUT_PORT[7:0]),                      
                      .EIGHT(EIGHT), 
                      .PEN(PEN), 
                      .OHEL(OHEL),
                      .RX_in(RX_in), 
                      .TX_out(TX_out), 
                      .UART_DS(UART_DS), 
                      .UART_INT(UART_INT)
                     );
                                           
   RS_flop     MOD_3 (
                      .clk(clk),
                      .reset(reset_s),
                      .S(UART_INT),
                      .R(int_ack),
                      .Q(INT)
                     );  
                        
   tramelblaze_top 
               MOD_4 (
                      .CLK(clk),
                      .RESET(reset_s),
                      .IN_PORT({8'b0, UART_DS}),
                      .INTERRUPT(INT),
                      .OUT_PORT(OUT_PORT),
                      .PORT_ID(PID), 
                      .READ_STROBE(RS),
                      .WRITE_STROBE(WS),
                      .INTERRUPT_ACK(int_ack)
                     );  

   //ADDRESS DECODER
   always @(*) begin
      READS = 0;
      WRITES = 0;
      READS [PID[5:0]] = RS;
      WRITES[PID[5:0]] = WS;   
   end
   
   //LEDS 
   always @(posedge clk, posedge reset_s)
      if(reset_s)
         LEDS <= 16'b0;
      else if(WRITES[1] == 1'b1)
         LEDS <= OUT_PORT;         
            
endmodule