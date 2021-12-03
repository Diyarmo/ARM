module WB_Module (
	input clk, rst,
    input [31:0] PC_in,
    wire [31:0] PC
    );

	wire [31:0] PC_temp;

    WB_Stage wb_stage(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_in),
	        .PC(PC_temp)
    );

    WB_Stage_Reg wb_stage_reg(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_temp),
            .PC(PC)
    );

endmodule