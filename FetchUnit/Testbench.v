`timescale 1ns/100ps
`include "DataControlUnit.v"
`include "DataFetch.v"
`include "DataMemory.v"
`include "Dispatcher.v"

module Testbench;

  reg[5:0] status;
  reg clk, preset;

  wire ready;
  wire[4:0] addr0, addr1, ctrlword;
  wire[5:0] processor_status;
  wire[15:0] data0, data1, operand0, operand1;

  DataControlUnit ctrl_unit(
    processor_status,
    ctrlword,
    preset,
    clk
  );

  FetchUnit fetch_unit(
    ctrlword[4:1], //Set of signals managing the registers and muxes of this module
    addr0,    //First operand address
    addr1,    //Second operand address
    ready,    //Indicates the registers have valid pointers
    preset,   //Sets dp0 and dp1 in their initial states
    ~clk       //Clock signal
  );

  DataMemory mem(
    addr1,  //address of the second operand
    addr0,  //addres of the first operand
    data1,  //value of the second operand
    data0   //value of the first operand  
  );

  Dispatcher dispatch_unit(
    data0,      //Data pointed by dp0
    data1,      //Data pointed by dp1
    operand0,   //Conveys the operand the FU0 process
    operand1,   //Conveys the operand the FU process
    ctrlword[0],    //Signal routing data to an available datapath
    processor_status[5],       //Signal indicating a zero is load in data0
    processor_status[4],       //Signal indicating a zero is load in data1
    processor_status[1],      //Indicates the pointer that is being processed by fu0
    processor_status[0],      //Indicates the pointer that is being processed by fu1
    preset,     //Clears the path register
    ~clk         //Clock signal
  );

  always #1 clk = ~clk;

  assign processor_status[3] = 1;
  assign processor_status[2] = 1;

  initial begin
    $dumpfile("fetch.vcd");
    $dumpvars(0, Testbench);
    clk = 0;
    preset = 0;
    #0.5;
    preset = 1;
    #2.0;
    preset = 0;
    #15 $finish;
  end

endmodule // Testbench