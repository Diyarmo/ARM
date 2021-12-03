module ID_Module (
	input clk, rst,
    input [31:0] PC_in,
    wire [31:0] PC
    );

	wire [31:0] PC_temp;

    ID_Stage id_stage(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_in),
	        .PC(PC_temp)
    );

    ID_Stage_Reg id_stage_reg(
            .clk(clk),
            .rst(rst),
            .PC_in(PC_temp),
            .PC(PC)
    );

endmodule