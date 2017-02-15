`ifndef GAUSS_CONTROL_UNIT
`define GAUSS_CONTROL_UNIT

module GaussControlUnit(
  status,   //Signal indicating the job is done
  ctrlword, //Signals managing the Gauss datapath
  preset,   //Set the FSM in the init state
  clk       //Clock signal
);

  input wire preset, clk;
  input wire[1:0] status; //ready, status
  output wire[2:0] ctrlword;

  wire[2:0] nextstate;
  reg[2:0] state;

  //Nextstate logic
  assign nextstate[0] = ~status[0] | state[0]&(~status[0]) | state[2]&~status[0];
  assign nextstate[1] = status[1] & (state[0]&status[0] | state[2]&status[0]);
  assign nextstate[2] = status[1] & state[1];

  //Memory
  always @(posedge clk) begin
    if (preset)
      state <= 3'b001;
    else
      state <= nextstate;
  end

  //Output logic
  assign ctrlword = state;

endmodule // GaussControlUnit

`endif