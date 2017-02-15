`include "Processor.v"
`timescale 1ns/100ps

module Testbench;

  wire[1:0] done;
  reg clk, preset;

  Processor proc_u(done, preset, clk);

  always #1 clk = ~clk;

  initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0, Testbench);
    clk = 0;
    preset = 0;
    #0.5;
    preset = 1;
    #2;
    preset = 0;
    #20 $finish;
  end

endmodule // Testbench