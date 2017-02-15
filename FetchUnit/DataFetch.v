`ifndef DATA_FETCH_V
`define DATA_FETCH_V

//Author: Adán G. Medrano-Chávez
//This module fetchs two values in the data memory. This task is accomplished
//by updating two pointers, namely dp0 and dp1, according the greatest address
//between them. A base pointer stores the greatest value

module FetchUnit(
  ctrlword, //Set of signals managing the registers and muxes of this module
  addr0,    //First operand address
  addr1,    //Second operand address
  ready,    //Indicates the registers have valid pointers
  preset,   //Sets dp0 and dp1 in their initial states
  clk       //Clock signal
);

  parameter addrsize = 5; //addrsize of operands
  //loadDP1, loadDP0, selMUXDP1
  input wire[2:0] ctrlword;
  input wire preset, clk;
  output wire ready;
  output wire[addrsize-1:0] addr0, addr1;

  //This signal is asserted when the address kept in dp0 is greater than dp1's
  reg selmuxbp; 

  //dp0 means data pointer 0
  //dp1 means data pointer 1
  //bp means base pointer, it keeps the greatest address between dp0 and dp1
  //Such direction is used to compute the 
  reg[addrsize-1:0] dp0, dp1, bp;

  //Behavioral description of the fetch unit
  //Both sequential and combinational elements are described here
  always@(posedge clk) begin
    if (preset) begin //If preset
      dp0 <= 0;
      dp1 <= 1;
      bp <= 1;
    end
    else begin
      if (ctrlword[2])  //load dp1
        dp1 <= (ctrlword[0]) ? bp + 2 : bp + 1;
      if (ctrlword[1])  //load dp0
        dp0 <= bp + 1;
    end 
  end

  //Base pointer is loaded when the negative edge of clk ocurrs
  always@(negedge clk)
    bp <= (selmuxbp) ? dp0 : dp1;

  always@(dp0 or dp1) begin
    if (dp0 > dp1)
      selmuxbp = 1;
    else
      selmuxbp = 0;
  end

  //The output of the module is described here

  assign addr0 = dp0;
  assign addr1 = dp1;
  assign ready = (dp1 > 0) ? 1 : 0;

endmodule // FetchUnit

`endif