`ifndef PREDICTOR_V
`define PREDICTOR_V

module Predictor(
  workload0,    //Workload of the datapath0
  workload1,    //Workload of the datapath1
  prediction    //Indicates which of the datapaths finish its workload
);

  parameter width = 16;

  input wire[width-1:0] workload0, workload1;
  output reg[1:0] prediction;

  always @(*) begin
    if (workload0 > workload1)
      prediction = 2'b10; //update dp1
    else if (workload0 == workload1)
      prediction = 2'b11; //update both pointers
    else
      prediction = 2'b01; //update dp0
  end

endmodule // Predictor 

`endif