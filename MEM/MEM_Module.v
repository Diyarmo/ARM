module MEM_Module (
	input clk, rst,
    input [31:0] PC_in,
    wire [31:0] PC
    );

	wire [31:0] PC_temp;

    MEM_Stage mem_stage(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_in),
	        .PC(PC_temp)
    );

    MEM_Stage_Reg mem_stage_reg(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_temp),
            .PC(PC)
    );

endmodule