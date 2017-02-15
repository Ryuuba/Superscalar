`include "GaussControlUnit.v"
`include "Gauss.v"
`timescale 1ns/100ps

module Testbench;

  reg clk, preset;
  reg[15:0] data;
  wire[15:0] result;

  wire done, prediction;
  wire[1:0] status;
  wire[2:0] ctrlword;

  GaussControlUnit ctrl_unit(status, ctrlword, preset, clk);
  Gauss gauss_unit(ctrlword, data, status[0], result, prediction, done, ~clk);

  assign status[1] = 0;

  always #1 clk = ~clk;

  initial begin
    $dumpfile("gauss.vcd");
    $dumpvars(0, Testbench);
    data = 1;
    clk = 0;
    preset = 1;
    #2.5;
    preset = 0;
    //#0.5;
    //while (~done) #1;
    #10 $finish;
  end

endmodule // Testbench