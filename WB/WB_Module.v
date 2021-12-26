module WB_Module (
	input clk, rst,
    input WB_EN,
    input MEM_R_EN,
    input [31:0] ALU_result, Mem_result,
    input [3:0] Dest,
    output[3:0] WB_Dest,
    output[31:0] WB_Value,
    output WB_WB_EN
    );

	assign WB_WB_EN = WB;
    assign WB_Dest = Dest;

    MUX_2_1 wb_mux(
        .f_in(ALU_result),
        .s_in(Mem_result),
        .select(MEM_R_EN),
        .out(WB_Value)

    )

endmodule