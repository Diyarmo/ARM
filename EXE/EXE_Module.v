module EXE_Module (
    input clk, rst,
    input[3:0] EXE_CMD,
    input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, 
    input [31:0] PC_IN,
    input[31:0] Val_Rn, Val_Rm, 
    input imm,
    input[11:0] Shift_operand,
    input[23:0] Signed_imm_24,
    input[3:0] SR,
    input[3:0] Dest_IN,

    output WB_EN, MEM_R_EN, MEM_W_EN
    output[31:0] ALU_result, Br_addr,
    output[3:0] status, Dest

    );

	wire [31:0] PC_temp, ALU_result_temp;

    EXE_Stage exe_stage(
        .clk(clk),
        .rst(rst),
        .EXE_CMD(EXE_CMD),
        .MEM_R_EN(MEM_R_EN_IN), 
        .MEM_W_EN(MEM_W_EN_IN), 
        .PC(PC_IN),
        .Val_Rn(Val_Rn), 
        .Val_Rm(Val_Rm), 
        .imm(imm),
        .Shift_operand(Shift_operand),
        .Signed_imm_24(Signed_imm_24),
        .SR(SR),

        .ALU_result(ALU_result_temp), 
        .Br_addr(Br_addr),
        .status(status)
    );

    EXE_Stage_Reg exe_stage_reg(
        .clk(clk), 
        .rst(rst), 
        .WB_en_IN(WB_EN_IN), 
        .MEM_R_EN_IN(MEM_R_EN_IN), 
        .MEM_W_EN_IN(MEM_W_EN_IN), 
        .ALU_result_IN(ALU_result_temp), 
        .Dest_IN(Dest_IN),
        .WB_en(WB_EN), 
        .MEM_R_EN(MEM_R_EN), 
        .MEM_W_EN(MEM_W_EN),
        .ALU_result(ALU_result), 
        .Dest(Dest)
    );

endmodule