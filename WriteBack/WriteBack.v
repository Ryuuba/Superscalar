 `ifndef WRITE_BACK_V
 `define WRITE_BACK_V

module WriteBack(
  ctrlword, //Signals managing the operation of registers
  dp0,      //Data pointer 0
  dp1,      //Data pointer 1
  res0,     //Result coming from the functional unit 0
  res1,     //Result coming from the functional unit 1
  addr0,    //Pointer keeping the data0 address
  addr1,    //Pointer keeping the data1 address
  data0,    //Data to be written in the result mem
  data1,    //Data to be written in the result mem
  clk       //Clock signal
);

  parameter addrsize = 5;
  parameter width = 16;

  input wire[4:0] ctrlword; //rwAR1, rwAR0, rwRR1, rwRR0, selAR
  input wire[addrsize-1:0] dp0, dp1;
  input wire[width-1:0] res0, res1;
  input wire clk;

  output wire[addrsize-1:0] addr0, addr1;
  output wire[width-1:0] data0, data1;

  reg[addrsize-1:0] ar0, ar1; //Address register zero and one
  reg[width-1:0] rr0, rr1;    //Result register zero and one

  always @(posedge clk) begin
    if (ctrlword[4]) //if write ar1 is asserted
      ar1 <= (ctrlword[0]) ? dp0 : dp1;
    if (ctrlword[3]) //if write ar0 is asserted
      ar0 <= (ctrlword[0]) ? dp1 : dp0;
    if (ctrlword[2])
      rr1 <= res1;
    if (ctrlword[1])
      rr0 <= res0;
  end

  assign addr0 = ar0;
  assign addr1 = ar1;
  assign data0 = rr0;
  assign data1 = rr1;

endmodule // WriteBack

 `endif