`ifndef DATAMEMORY_V
`define DATAMEMORY_V

//Author: Adán G. Medrano-Chávez
//Memory able to address two data at the same time. This feature is needed to
//concurrently load two registers, namely R0 and R1, whose value is the operand
//of the two functional units that computes the sum of n
//This memory reads its content from a file

module DataMemory(
  addr1,  //address of the second operand
  addr0,  //addres of the first operand
  data1,  //value of the second operand
  data0   //value of the first operand  
);

  parameter wordsize = 16; //the word size
  parameter addrsize = 5; //the address size
  localparam memdepth = $pow(2, addrsize); //the memory depth

  //buses conveying the operand addresses
  input wire[addrsize-1:0] addr0, addr1;
  //buses conveying the operands to be processed
  output wire[wordsize-1:0] data0, data1;

  //memory storing the values to be processed
  reg[wordsize-1:0] memory[memdepth:0];

  //This initial block initializes the memory with the data stored in data.list
  initial begin
    //$readmemh(filename, mem_array, start_addr, stop_addr);
    //The last two value are optional arguments
    $readmemh("./FetchUnit/data.list", memory, 0, 31);
  end

  assign data1 = memory[addr1];
  assign data0 = memory[addr0];

endmodule // DataMemory

`endif