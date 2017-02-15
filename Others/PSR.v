`ifndef PSR_V
`define PSR_V

module ProcessorStatusRegister(
  newstatus,  //value overwritting the current status
  status,     //Processor status
  preset,     //Signal setting the intial conf
  clk         //Clock signal
);

  //data_ready, status1, status0, path1, path0

  parameter status_width = 5;

  input wire[status_width-1:0] newstatus;
  input wire preset, clk;

  output wire[status_width-1:0] status;

  reg[status_width-1:0] psr; //Stores the processor status

  always @(posedge clk) begin
    if (preset)
      psr <= 5'b00000;
    else
      psr <= newstatus;
  end

  assign status = psr;

endmodule // ProcessorStatusRegister

`endif