`ifndef GAUSS_UNIT_V
`define GAUSS_UNIT_V

//Author: Adán G. Medrano-Chávez
//This functional unit computes n(n+1)/2 through sums. It's silly, isn't it?
//Sorry Gauss

module Gauss(
  ctrlword,     //Manages register n, and acum as well as the output
  data,         //Input value
  status,       //Indicates whether the functional unit is available or not
  result,       //n(n+1)/2
  prediction,   //Indictes the datapath is processing the last element
  done,         //Indicates the job is done
  preset,
  clk           //Clock signal
);

  //This parameter defines the width of the operand and the result
  parameter width = 16;

  input wire[2:0] ctrlword; //control bits are dec_n, load_acum, init
  input wire[width-1:0] data; //input value
  input wire preset, clk;
  output reg status, prediction;
  output wire done;
  output wire[width-1:0] result;

  //Internal register storing the value of the variables.
  reg[width-1:0] n, acum;

  //Here the behavior of register is described according to the control word.
  //The case corresponding to state three needs 'n' tri-state buffers, so it's
  //described in a generate block
  always @(posedge clk) begin
    if (preset) begin
      n <= 0;
      acum <= 0;
    end
    else
      case (ctrlword)
        3'b001:  begin
                    n <= data;
                    acum <= 0;
                  end
        3'b010: acum <= acum + n;
        3'b100: n <= n - 1;
      endcase
  end

  always @(posedge clk) begin
    if ((ctrlword[1]) && (n==1))
      prediction = 1;
    else
      prediction = 0;
  end

  //Here the combinational blocks of the Gauss are described. The actual
  //inputs modifying the output of this block are only registers i and n as well
  //as the most significant bit of the control word
  always @(n) begin
    if (n > 0)
      status = 1; //HIGH means the datapath is working
    else
      status = 0; //LOW means the datapath is available
  end

  assign result = acum;
  assign done = ~|n;

endmodule // Gauss

`endif