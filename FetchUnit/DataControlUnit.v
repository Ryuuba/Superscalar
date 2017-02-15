`ifndef DATA_CONTROL_UNIT
`define DATA_CONTROL_UNIT

//Author: Adán G. Medrano-Chávez
//This module manages the operation of the data fetch unit

module DataControlUnit(
  status,   //Processor status
  ctrlword, //Signals that manage the fetch unit
  preset,   //Set the FSM in its initial state
  clk       //Clock signal
);

  input wire[5:0] status; //zer1, zer0, pre1, pre0, path1, path0
  input wire preset, clk;

  //loaddp1, loaddp0, selmuxdp1, seldatapath
  output reg[3:0] ctrlword;

  
  wire[1:0] nextstate; //Nextstate logic input
  reg[1:0] state; //FSM Memory

  //Next state logic description
  assign nextstate[0] = ~(status[5] | status[4] | status[3] | status[2]);
  assign nextstate[1] = status[5] | status[4] | status[3] | status[2];

  //Memory Behavioral
  always @(posedge clk) begin
    if (preset)
      state <= 2'b01;
    else
      state <= nextstate;
  end

  //Output combinational logic
  always @(state or status) begin
    case ({state,status})
      //Non zero has been read
      8'b10_00_00_01 :	ctrlword = 5'b0000;
      8'b10_00_00_10 :	ctrlword = 5'b0000;
      8'b10_00_01_01 :	ctrlword = 5'b1001;
      8'b10_00_01_10 :	ctrlword = 5'b0100;
      8'b10_00_10_01 :	ctrlword = 5'b0101;
      8'b10_00_10_10 :	ctrlword = 5'b1000;
      8'b10_00_11_01 :	ctrlword = 5'b1110;
      8'b10_00_11_10 :	ctrlword = 5'b1110;
      //Read a zero in data0
      8'b10_01_00_01 :	ctrlword = 5'b0101;
      8'b10_01_00_10 :	ctrlword = 5'b0100;
      8'b10_01_01_01 :	ctrlword = 5'b1110;
      8'b10_01_01_10 :	ctrlword = 5'b0100;
      8'b10_01_10_01 :	ctrlword = 5'b0101;
      8'b10_01_10_10 :	ctrlword = 5'b1110;
      8'b10_01_11_01 :	ctrlword = 5'b1110;
      8'b10_01_11_10 :	ctrlword = 5'b1110;
      //Read a zero in data1
      8'b10_10_00_01 :	ctrlword = 5'b1001;
      8'b10_10_00_10 :	ctrlword = 5'b1000;
      8'b10_10_01_01 :	ctrlword = 5'b1001;
      8'b10_10_01_10 :	ctrlword = 5'b1110;
      8'b10_10_10_01 :	ctrlword = 5'b1110;
      8'b10_10_10_10 :	ctrlword = 5'b1000;
      8'b10_10_11_01 :	ctrlword = 5'b1110;
      8'b10_10_11_10 :  ctrlword = 5'b1110;
      8'b10_00_00_01 :  ctrlword = 5'b1110;
      //Read two zeroes
      8'b10_11_00_01 :  ctrlword = 5'b1110;
      8'b10_11_00_10 :  ctrlword = 5'b1110;
      8'b10_11_01_01 :  ctrlword = 5'b1110;
      8'b10_11_01_10 :  ctrlword = 5'b1110;
      8'b10_11_10_01 :  ctrlword = 5'b1110;
      8'b10_11_10_10 :  ctrlword = 5'b1110;
      8'b10_11_11_01 :  ctrlword = 5'b1110;
      8'b10_11_11_10 :  ctrlword = 5'b1110;
      default: ctrlword = 5'b00000;
    endcase
  end

endmodule // DataControlUnit

`endif