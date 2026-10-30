module FSM(Clk, ResetN,PC_Out , IR_Out, PC_clr, PC_up, IR_ld, StateOut, D_Addr, D_wr, RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0);
    input logic Clk, ResetN; //system clock 
    input logic [6:0] PC_Out;
    input logic [15:0] IR_Out;
    output logic [3:0] StateOut; //output StateOut
    //system output
    output logic PC_clr, PC_up, IR_ld; //must
    output logic [7:0] D_Addr; //Address of data sent to RAM 
	output logic D_wr, RF_s, RF_W_en; //Signal to write data from A value RF address, RF selecting value for Mux2to1, Enable writing to RF_W_addr, Clock signal 
	output logic [3:0] RF_W_addr, RF_Ra_addr, RF_Rb_addr; //Write data to this RF, A value RF address, B value RF address
	output logic [2:0] ALU_s0; //Selecting signal for ALU

    logic [3:0] opcode;
    assign opcode = IR_Out[15:12];

    localparam  Init = 4'b0000,
                Fetch = 4'b0001,
                Decode = 4'b0010,
                LoadA = 4'b0011,
                LoadB = 4'b0100,
                Store = 4'b0101,
                Add = 4'b0110,
                Sub = 4'b0111,
                Halt = 4'b1000;
    
    logic [3:0] State, NextState; //state variables
    assign StateOut = State; //the State and StateOut

    always_comb begin 
        NextState = State;
        PC_clr = 0;
        IR_ld = 0;
        PC_up = 0;
        D_Addr = 8'b0;
        D_wr = 0;
        RF_s = 0;
        RF_W_en = 0;
        RF_W_addr = 4'b0;
        RF_Ra_addr = 4'b0;
        RF_Rb_addr = 4'b0;
        ALU_s0 = 3'b0;
        case(State) 
            Init: begin
                PC_clr = 1'b1;
                NextState = Fetch;
            end
            Fetch: begin 
                IR_ld = 1'b1;
                PC_up = 1'b1;
                NextState = Decode;
            end
            Decode: begin
                case(opcode)
                    4'b0000: NextState = Fetch;  // NOOP
                    4'b0001: NextState = Store;
                    4'b0010: NextState = LoadA;
                    4'b0011: NextState = Add;
                    4'b0100: NextState = Sub;
                    4'b0101: NextState = Halt;
                    default: NextState = Fetch; 
                endcase
            end
            LoadA: begin
                D_Addr = IR_Out[11:4];
                RF_s = 1'b1;
                RF_W_addr = IR_Out[3:0];
                NextState = LoadB;
            end
            LoadB: begin
                D_Addr = IR_Out[11:4];
                RF_s = 1'b1;
                RF_W_addr = IR_Out[3:0];
                RF_W_en = 1'b1;
                NextState = Fetch;
            end
            Store: begin 
                D_Addr = IR_Out[7:0];
                D_wr = 1'b1;
                RF_Ra_addr = IR_Out[11:8];
                NextState = Fetch;
            end
            Add: begin
                RF_Ra_addr = IR_Out[11:8];
                RF_Rb_addr = IR_Out[7:4];
                RF_W_addr = IR_Out[3:0];
                RF_W_en = 1'b1;
                ALU_s0 = 3'b001;
                NextState = Fetch;
            end
            Sub: begin 
                RF_Ra_addr = IR_Out[11:8];
                RF_Rb_addr = IR_Out[7:4];
                RF_W_addr = IR_Out[3:0];
                RF_W_en = 1;
                ALU_s0 = 3'b010;
                NextState = Fetch;
            end
            Halt: begin
                NextState = Halt;
            end
            default: NextState = Init;
        endcase
    end

    always_ff @(posedge Clk, negedge ResetN) begin
    if (!ResetN)
      State <= Init ;
    else
      State <= NextState;
    end
endmodule

module FSM_tb();
    logic        Clk;
    logic        ResetN;
    logic [6:0]  PC_Out;
    logic [15:0] IR_Out;
    logic [3:0]  StateOut;
    
    logic        PC_clr, PC_up, IR_ld;
    logic [7:0]  D_Addr;
    logic        D_wr, RF_s, RF_W_en;
    logic [3:0]  RF_W_addr, RF_Ra_addr, RF_Rb_addr;
    logic [2:0]  ALU_s0;

    FSM DUT(Clk, ResetN, PC_Out, IR_Out, PC_clr, PC_up, IR_ld, StateOut, D_Addr, D_wr, RF_s, RF_W_en, RF_Ra_addr, RF_Rb_addr, RF_W_addr, ALU_s0);

    always begin  // 50 MHz Clock
        Clk = 1'b0; #10;
        Clk = 1'b1; #10;
        end
    
    initial begin
        // generate your input sequence
        //Initial -> Fetch
        ResetN = 1'b0; PC_Out = 1'b0; IR_Out = 16'b0; #25; 
        ResetN = 1'b1; #15; 
        //
        @(posedge Clk);
        IR_Out = 16'h0000; 
        #40;
         @(posedge Clk);
        IR_Out = 16'h22F4; 
        #60;
         @(posedge Clk);
        IR_Out = 16'h3567;
        #40;
         @(posedge Clk);
        IR_Out = 16'h12BC;
        #40;
         @(posedge Clk);
        IR_Out = 16'h5000;
        #60;
        $stop;
    end
    
    initial begin
        $display("State | PC | IR | PC_clr | PC_Out | IR_ld | StateOut | D_Addr | D_wr | RF_s | RF_W_en | RF_Ra_addr | RF_Rb_addr | RF_W_addr | ALU_s0");
        $monitor("%0d\t%d\t%h\t%b\t%b\t%b\t%h\t%b\t%b\t%b", 
                 $time, StateOut, IR_Out, PC_clr, PC_up, IR_ld, D_Addr, D_wr, RF_W_en, ALU_s0);
    end
endmodule
