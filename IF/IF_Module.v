module IF_Module (
	input clk, rst, flush, freeze, Branch_taken,
    wire [31:0] BranchAddr, PC, Instruction
);
	wire [31:0] PC_temp;
	wire [31:0] Instruction_temp;


    IF_Stage if_stage(
            .clk(clk),
            .rst(rst),
            .freeze(freeze),
            .Branch_taken(Branch_taken),
            .BranchAddr(BranchAddr),
        	.PC(PC_temp),
	        .Instruction(Instruction_temp)
    );
    IF_Stage_Reg if_stage_reg(
            .clk(clk),
            .rst(rst),
            .freeze(freeze),
            .flush(flush),
            .PC_in(PC_temp),
            .Instruction_in(Instruction_temp),
            .PC(PC),
            .Instruction(Instruction)
    );

endmodule