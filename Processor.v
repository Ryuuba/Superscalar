`ifndef PROCESSOR_V
`define PROCESSOR_V

`include "FetchUnit/DataFetch.v"
`include "FetchUnit/DataMemory.v"
`include "FetchUnit/Dispatcher.v"
`include "FetchUnit/DataControlUnit.v"
`include "FunctionalUnit/Gauss.v"
`include "FunctionalUnit/GaussControlUnit.v"

module Processor(
  done,
  preset,
  clk
);

  input wire preset, clk;
  output wire[1:0] done;

  wire[2:0] ctrlword_g0, ctrlword_g1;
  wire[3:0] ctrlword_d;
  wire[4:0] addr0, addr1;
  //ready, status1, status2, zer1, zer0, pre1, pre0, path1, path0
  wire[8:0] proc_status;
  wire[15:0] data0, data1, operand0, operand1, res0, res1;

  DataControlUnit ctrl_d0(
    proc_status[5:0], //Processor status
    ctrlword_d,       //Signals that manage the fetch unit
    preset,           //Set the FSM in its initial state
    clk               //Clock signal
  );

  FetchUnit fetch_u(
    ctrlword_d[3:1],      //Manages the registers and muxes of this module
    addr0,                //First operand address
    addr1,                //Second operand address
    proc_status[8],       //Indicates the registers have valid pointers
    preset,               //Sets dp0 and dp1 in their initial states
    ~clk                  //Clock signal
  );

  DataMemory data_mem(
    addr1,  //address of the second operand
    addr0,  //addres of the first operand
    data1,  //value of the second operand
    data0   //value of the first operand  
  );

  Dispatcher dispatcher_u(
    data0,          //Data pointed by dp0
    data1,          //Data pointed by dp1
    operand0,       //Conveys the operand the FU0 process
    operand1,       //Conveys the operand the FU process
    ctrlword_d[0],  //Signal routing data to an available datapath
    proc_status[5], //Indicates the data1 equals zero
    proc_status[4], //Indicates the data0 equals zero
    proc_status[1], //Indicates the pointer that is being processed by fu0
    proc_status[0], //Indicates the pointer that is being processed by fu1
    preset,         //Clears reg path
    ~clk            //Clock signal
  );

  GaussControlUnit ctrl_g1(
    {proc_status[8], proc_status[7]},   //Signal indicating the job is done
    ctrlword_g1,      //Signals managing the Gauss datapath
    preset,           //Sets the FSM in the init state
    clk               //Clock signal
  );

  GaussControlUnit ctrl_g0(
    {proc_status[8], proc_status[6]},   //Signal indicating the job is done
    ctrlword_g0,      //Signals managing the Gauss datapath
    preset,           //Sets the FSM in the init state
    clk               //Clock signal
  );

  Gauss functional_u1(
    ctrlword_g1,    //Manages register n, and acum as well as the output
    operand1,       //Input value
    proc_status[7], //Indicates whether the functional unit is available or not
    res1,           //n(n+1)/2
    proc_status[3], //Indictes the datapath is processing the last element
    done[1],        //Indicates the job is done
    preset,
    ~clk            //Clock signal
  );

  Gauss functional_u0(
    ctrlword_g0,    //Manages register n, and acum as well as the output
    operand0,       //Input value
    proc_status[6], //Indicates whether the functional unit is available or not
    res0,           //n(n+1)/2
    proc_status[2], //Indictes the datapath is processing the last element
    done[0],        //Indicates the job is done
    preset,
    ~clk            //Clock signal
  );

endmodule // Processor

`endif