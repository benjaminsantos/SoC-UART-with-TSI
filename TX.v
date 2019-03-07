`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 2 - Transmit Engine
 * File Name: TX.v
 * Date: 	  March 14, 2018
 * Notes:     Transmit Engine generates a 1 bit serial output(TX_out) according to
              the instruction set from the Tramelblaze and the BAUD rate. 
=================================================================================*/
module TX(clk, reset, K, LOAD, OUT_PORT, EIGHT, PEN, OHEL, TXRDY, TX_out);
   input clk, reset;
   input [19:0] K;   //Integer count of the baud rate
   input [7:0] OUT_PORT;
   input LOAD, EIGHT, PEN, OHEL;
   output TXRDY;
   output TX_out;
   
   wire DOIT;        //RS -> DONE, LD1
   wire DONE;        //Output from Bit Counter 
   wire LOADD1;      //1 clock delay of input LOAD
   wire BTU;         //Bit Time Up (output from Bit Time Counter
   wire [7:0] LDATA; //Output of Loadable register for the Shift Register
   wire ten, nine;   //10th and 9th bit of the shift register         
   
   //Generates 1 clock delay of LOAD
   DFlop         TX_D1 (.clk(clk), .reset(reset),
                        .D(LOAD), 
                        .Q(LOADD1)
                       );
   RS_rdy        TX_R1 (.clk(clk), .reset(reset),
                        .S(DONE),  
                        .R(LOAD),
                        .Q(TXRDY)          
                       );
   RS_flop       TX_R2 (.clk(clk), .reset(reset), 
                        .S(LOADD1),
                        .R(DONE),     
                        .Q(DOIT) 
                        );
   
   loadREG       TX_L1 (.clk(clk), .reset(reset),
                        .load(LOAD),
                        .D(OUT_PORT),
                        .Q(LDATA)
                       );

   parity_func   TX_PF (.LDATA(LDATA),
                        .EIGHT(EIGHT), 
                        .PEN(PEN), 
                        .OHEL(OHEL), 
                        .ten(ten), 
                        .nine(nine)
                       );
   
   shiftTX       TX_S  (
                        .clk(clk), .reset(reset),
                        .elevenIN({ten, nine, LDATA[6:0], 1'b0, 1'b1}),
                        .LD1(LOADD1),
                        .SH(BTU),
                        .SDI(1'b1),
                        .SD0(TX_out)
                        );
      
   BitTime_Counter      
                 TX_BT (.clk(clk), .reset(reset),
                        .DOIT(DOIT),
                        .K(K),
                        .BTU(BTU)
                       );
                       
   Bit_Counter   TX_BC (.clk(clk), .reset(reset),
                        .DOIT(DOIT),
                        .BTU(BTU),
                        .DONE(DONE),
                        .mQ()
                       );
   
   
endmodule
