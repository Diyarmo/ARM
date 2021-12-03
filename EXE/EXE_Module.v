module EXE_Module (
    input clk, rst,
    input [31:0] PC_in,
    wire [31:0] PC
    );

	wire [31:0] PC_temp;

    EXE_Stage exe_stage(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_in),
	    .PC(PC_temp)
    );

    EXE_Stage_Reg exe_stage_reg(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_temp),
            .PC(PC)
    );

endmodule