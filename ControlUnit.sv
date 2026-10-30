module Control_Unit(Clk, ResetN, PC_Out, IR_Out, StateOut, D_Addr, D_wr, RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0);
    input logic Clk, ResetN;
    output logic [6:0] PC_Out;
    output logic [15:0] IR_Out;
    output logic [3:0] StateOut; 

    output logic [7:0] D_Addr; //Address of data sent to RAM 
	output logic D_wr, RF_s, RF_W_en; //Signal to write data from A value RF address, RF selecting value for Mux2to1, Enable writing to RF_W_addr, Clock signal 
	output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr; //Write data to this RF, A value RF address, B value RF address
	output logic [2:0] ALU_s0; //Selecting signal for ALU

    logic PC_clr, PC_up, IR_ld;
    logic [15:0] ROM;

    //module PC(Clk, PC_clr, PC_up, PC_Out);
    PC u0(.Clk(Clk), .PC_clr(PC_clr), .PC_up(PC_up), .PC_Out(PC_Out));

    //ROM
    ROM	ROM_inst ( .address (PC_Out), .clock (Clk), .q (ROM));


    //module IR(Clk, data, IR_ld, IR_Out);
    IR u2 (.Clk(Clk), .data(ROM), .IR_ld(IR_ld), .IR_Out(IR_Out));

    //module FSM(Clk, ResetN,PC_Out , IR_Out, PC_clr, PC_up, IR_ld, StateOut, D_Addr, D_wr, RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0);
    FSM u3 (.Clk(Clk), .ResetN(ResetN), .PC_Out(PC_Out), .IR_Out(IR_Out), .PC_clr(PC_clr), .PC_up(PC_up), .IR_ld(IR_ld), .StateOut(StateOut), .D_Addr(D_Addr), .D_wr(D_wr), .RF_s(RF_s), .RF_W_en(RF_W_en), .RF_Ra_addr(RF_Ra_addr), .RF_Rb_addr(RF_Rb_addr), .RF_W_addr(RF_W_addr), .ALU_s0(ALU_s0));
endmodule

module Control_Unit_tb();
    logic Clk, ResetN;
    logic [6:0] PC_Out;
    logic [15:0] IR_Out;
    logic [3:0] StateOut;
    logic [7:0] D_Addr;
    logic D_wr, RF_s, RF_W_en;
    logic [3:0] RF_W_addr;
    logic [2:0] ALU_s0;

    Control_Unit DUT (Clk, ResetN, PC_Out, IR_Out, StateOut, D_Addr, D_wr, RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0);
endmodule