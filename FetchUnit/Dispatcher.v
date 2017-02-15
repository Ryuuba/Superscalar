`ifndef DISPATCHER_V
`define DISPATCHER_V

//Author: Adán G. Medrano-Chávez
//This module is a combinational logic block routing operands to an available
//functional unit. Besides, it emits a signal indicating which operand is the
//greatest in order to predict which datapointer ought to be updated

module Dispatcher(
  data0,      //Data pointed by dp0
  data1,      //Data pointed by dp1
  operand0,   //Conveys the operand the FU0 process
  operand1,   //Conveys the operand the FU process
  selpath,    //Signal routing data to an available datapath
  zer1,       //Indicates the data1 equals zero
  zer0,       //Indicates the data0 equals zero
  path1,      //Indicates the pointer that is being processed by fu0
  path0,      //Indicates the pointer that is being processed by fu1
  preset,     //Clears reg path
  clk         //Clock signal
);

  parameter width = 16; //data width

  input wire[width-1:0] data0, data1;
  input wire selpath, clk, preset;
  output wire path0, path1, zer0, zer1;
  output reg[width-1:0] operand0, operand1;

  reg path;

  //Behavioral description of two muxes
  always @(*) begin
    if (selpath) begin
      operand0 = data1;
      operand1 = data0;
    end
    else begin
      operand0 = data0;
      operand1 = data1;
    end
  end

  always @(posedge clk) begin
    if (preset)
      path <= 0;
    else
      path <= selpath;
  end

  assign zer0 = (data0 == 0) ? 1 : 0;
  assign zer1 = (data1 == 0) ? 1 : 0;
  assign path0 = path;
  assign path1 = ~path;


endmodule // Dispatcher

`endif