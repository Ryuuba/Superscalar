`ifndef FECTH_V
`define FECTH_V

`include "DataFetch.v"
`include "DataMemory.v"
`include "Dispatcher.v"
`include "ControlUnit0.v"

module Fetch(
  status,
  preset,
  clk
);

  input wire[5:0] status;
  input wire preset, clk;

  wire[4:0] ctrlword;
  wire[4:0] addr0, addr1;
  wire[15:0] data0, data1, operand0, operand1;
  
  FetchUnit df_unit(ctrlword[4:1], addr0, addr1, preset, clk);
  DataMemory data_mem(addr1, addr0, data1, data0);
  Dispatcher dispatcher(data0, data1, operand0, operand1, ctrlword[0]);
  ControlUnitZero ctrl_unit(status, ctrlword, preset, clk);

endmodule // Fetch

`endif