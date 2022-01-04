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

    input[1:0] fu_sel_src1, fu_sel_src2,
    input[31:0] ALU_res, WB_Value, 

    output WB_EN, MEM_R_EN, MEM_W_EN,
    output[31:0] ALU_result, Br_addr,
    output[3:0] status, Dest,
    output[31:0] Val_Rm_out, PC

    );
    wire flush;
    assign flush = 1'b0;

	wire [31:0] PC_temp, ALU_result_temp, alu_src2_temp;

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

        .fu_sel_src1(fu_sel_src1),
        .fu_sel_src2(fu_sel_src2),
        .ALU_res(ALU_res),
        .WB_Value(WB_Value),

        .ALU_result(ALU_result_temp), 
        .Br_addr(Br_addr),
        .Val_Rm_out(alu_src2_temp),
        .status(status)
    );

    EXE_Stage_Reg exe_stage_reg(
        .clk(clk), 
        .rst(rst), 
        .flush(flush),
        .WB_en_IN(WB_EN_IN), 
        .MEM_R_EN_IN(MEM_R_EN_IN), 
        .MEM_W_EN_IN(MEM_W_EN_IN), 
        .ALU_result_IN(ALU_result_temp), 
        .ST_val_IN(alu_src2_temp),
        .Dest_IN(Dest_IN),
        .PC_IN(PC_IN),

        .WB_en(WB_EN), 
        .MEM_R_EN(MEM_R_EN), 
        .MEM_W_EN(MEM_W_EN),
        .ALU_result(ALU_result), 
        .ST_val(Val_Rm_out),
        .Dest(Dest),
        .PC(PC)
    );

endmodule