module MEM_Module (
	input clk, rst, MEM_CLK, freeze,
    MEM_W_EN_IN, MEM_R_EN_IN, WB_EN_IN,
    input[31:0] ALU_result_IN, Val_Rm, PC_IN,
    input[3:0] Dest_IN, 
    output WB_EN, MEM_R_EN,
    output[31:0] ALU_result, MEM_read_value, PC,
    output[3:0] Dest,
    output SRAM_ready
    );

	wire [31:0] MEM_result_temp;
    wire flush;
    assign flush = 1'b0;

    MEM_Stage #(.USE_SRAM(1))mem_stage(
        .clk(clk),
        .MEM_CLK(MEM_CLK),
        .rst(rst),
        .MEM_W_EN(MEM_W_EN_IN), 
        .MEM_R_EN(MEM_R_EN_IN),
        .ALU_Res(ALU_result_IN), 
        .Val_Rm(Val_Rm),

        .MEM_result(MEM_result_temp),
        .SRAM_ready(SRAM_ready)
    );

    MEM_Stage_Reg mem_stage_reg(
        .clk(clk), 
        .rst(rst), 
        .flush(flush),
        .freeze(freeze), 
        .WB_EN_IN(WB_EN_IN), 
        .MEM_R_EN_IN(MEM_R_EN_IN),
        .ALU_result_IN(ALU_result_IN), 
        .MEM_read_value_IN(MEM_result_temp),
        .Dest_IN(Dest_IN),
        .PC_IN(PC_IN),

        .WB_EN(WB_EN), 
        .MEM_R_EN(MEM_R_EN),
        .ALU_result(ALU_result), 
        .MEM_read_value(MEM_read_value),
        .Dest(Dest),
        .PC(PC)
    );

endmodule