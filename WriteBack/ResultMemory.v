`ifndef RESULT_MEMORY_V
`define RESULT_MEMORY_V

//$writememh ( " file_name " , memory_name [ , start_addr [ , finish_addr ] ] );

module ResultMemory(
  data0,  //input value 0
  data1,  //input value 1
  addr0,  //Destination address of input value 0
  addr1,  //Destination address of input value 1
  rw1,    //Signal enabling the writing of data1 
  rw0,    //Signal enabling the writing of data0 
  clk     //Clock signal
);

  parameter wordsize = 16; //the word size
  parameter addrsize = 5; //the address size
  localparam memdepth = $pow(2, addrsize); //the memory depthddr

  input wire[wordsize-1:0] data0, data1;
  input wire[addrsize-1:0] addr0, addr1;
  input wire rw0, rw1, clk;

  reg[wordsize-1:0] mem[memdepth-1:0];

  always @(posedge clk) begin
    if (rw0)
      mem[addr0] <= data0;
    if (rw1)
      mem[addr1] <= data1;
  end

endmodule // ResultMemory

`endif