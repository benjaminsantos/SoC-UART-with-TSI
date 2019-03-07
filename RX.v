`timescale 1ns / 1ps
/*=================================================================================
 * Authors:	  Benjamin Santos
 * Email: 	  benjaminsantos@gmx.com
 * Project:   CECS 460 Lab 3 - Full UART Receiver and Transmitter
 * File Name: RX.v
 * Date: 	  March 14, 2018
 * Notes:     The Receive Engine Controller for the UART.
              RX synchronizes the data collection with the TX communication.
              
              The Receive Engine is always polling the RX_in line looking for a 
              high to low transition indicating the arrival of the START bit.
=================================================================================*/
module RX(clk, reset, K, K_2, RX_in, READS, EIGHT, PEN, OHEL,
          UART_RDATA, OVF, FERR, PERR, RXRDY);
          
   input        clk, reset;
   input [19:0] K, K_2;
   input        RX_in;
   input        EIGHT, PEN, OHEL;
   input        READS;
   output       RXRDY, PERR, FERR, OVF;
   output [7:0] UART_RDATA;   
   
   wire BTU, DONE;
   
// ====================================================================================
//    State Machine
// ====================================================================================
   reg START, DOIT;
   reg nstart, ndoit;
   reg [1:0] state;
   reg [1:0] nstate;

   always @(posedge clk, posedge reset)
      if(reset)   begin
         START  <= 1'b0; DOIT  <= 1'b0; state  <= 2'b0;
                  end
      else  begin
         START <= nstart;
         DOIT  <= ndoit;
         state <= nstate;
            end
   
   always @(*) begin
      {nstate, nstart, ndoit} = 4'b0;
      casez( {DONE, RX_in, BTU, state} )
         5'b?1?00: {nstate, nstart, ndoit} = 4'b00_0_0;     // {START, DOIT}
         5'b?0?00: {nstate, nstart, ndoit} = 4'b01_0_0;     // {START, DOIT}
         5'b?0001: {nstate, nstart, ndoit} = 4'b01_1_1;     // {START, DOIT}
         5'b?0101: {nstate, nstart, ndoit} = 4'b10_1_1;     // {START, DOIT}
         5'b?1?01: {nstate, nstart, ndoit} = 4'b00_1_1;     // {START, DOIT}
         5'b0??10: {nstate, nstart, ndoit} = 4'b10_0_1;     // {START, DOIT}
         5'b1??10: {nstate, nstart, ndoit} = 4'b00_0_1;     // {START, DOIT}
         default: {nstate, nstart, ndoit} = 4'bz;
      endcase
               end
      
// ====================================================================================
//    Shift Register
// ====================================================================================
   
   wire SH;
   assign SH = (BTU && ~START);
   
   reg [9:0] SR; //shift register
   
   always @(posedge clk, posedge reset)
      if(reset)
         SR <= 10'b0;
      else
         if(SH)
            SR <= {RX_in, SR[9:1]};
         else
            SR <= SR;
   
// ====================================================================================
//    Remap
// ====================================================================================
   
   reg [9:0] RMP;    //remapped shift register
   
   always @(posedge clk, posedge reset)
      if(reset)
         RMP <= 10'b1100000000;
      else
         case({EIGHT, PEN})        
            2'b00: RMP <= {2'b11, SR[9:2]};   // SR 2
            2'b01: RMP <= {1'b1,  SR[9:1]};   // SR 1
            2'b10: RMP <= {1'b1,  SR[9:1]};   // SR 1
            2'b11: RMP <= SR[9:0];   
         endcase   
   
   // if 7 bits only, RDATA gets RMP[6:0] with a 0 fill MSB
   assign UART_RDATA = RMP[7:0];       // DATA TO BE SENT TO TRAMELBLAZE
   
   // FOR PERR
   reg parr0;
   wire parr1, parr2;        //parr2 generates S for PERR RS flop
   
   always @(*)
      case({EIGHT, OHEL})
         2'b00: parr0 =  ^RMP[6:0];
         2'b01: parr0 = ~^RMP[6:0];
         2'b10: parr0 =  ^RMP[7:0];
         2'b11: parr0 = ~^RMP[7:0];
      endcase   
   
   assign parr1 = (EIGHT) ? parr0 ^ RMP[8] : 
                            parr0 ^ RMP[7];
   
   assign parr2 = ( PEN && parr1 && DONE);
   
   // Stop Bit Select
   reg SBS; 
   always @(*)
      if(reset)
         SBS <= 1'b0;
      else
         case({EIGHT, PEN})
            2'b00 : SBS <= RMP[7];
            2'b01 : SBS <= RMP[8];
            2'b10 : SBS <= RMP[8];
            2'b11 : SBS <= RMP[9];
            default SBS <= 1'b0;
         endcase
                        
   // START dictates when the BTU occurs
   wire [19:0] K_in;
   assign K_in = (START == 0) ? K : K_2;
   
   BitTime_Counter      
                 RX_BT (.clk(clk), .reset(reset),
                        .DOIT(DOIT),
                        .K(K_in),
                        .BTU(BTU)
                       );
   
   // Generating DONE signal from Bit_Counter
   reg  [3:0] DCHECK;
   wire [3:0] mQ;
      
   always @(*)
      case({EIGHT, PEN})
         2'b00: DCHECK = 4'b1001;   // 9 bits
         2'b01: DCHECK = 4'b1010;   //10 bits
         2'b10: DCHECK = 4'b1010;   //10 bits
         2'b11: DCHECK = 4'b1011;   //11 bits
      endcase
      
   assign DONE = (reset) ? 1'b0 : (mQ == DCHECK);
   
   Bit_Counter   RX_BC (.clk(clk), .reset(reset),
                        .DOIT(DOIT),
                        .BTU(BTU),
                        .DONE(),
                        .mQ(mQ)
                       );
   
   RS_flop       RX_rd (.clk(clk), .reset(reset),      //RXRDY
                        .S(DONE),
                        .R(READS),
                        .Q(RXRDY)
                       );  
                       
   RS_flop       RX_pe (.clk(clk), .reset(reset),      //Parity Error
                        .S(parr2),
                        .R(READS),
                        .Q(PERR)
                       );  

   RS_flop       RX_fe (.clk(clk), .reset(reset),      //Framing Error
                        .S( (DONE && ~SBS) ),          //DONE and ~Stop bit select
                        .R(READS),
                        .Q(FERR)
                       );  

   RS_flop       RX_ov (.clk(clk), .reset(reset),      //Overflow Error
                        .S( (DONE && RXRDY) ),         //DONE and RXRDY
                        .R(READS),
                        .Q(OVF)
                       );  

endmodule
