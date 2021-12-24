module ID_Module (
	input clk, rst,
    input [31:0] Instruction, 
    output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
    output[3:0] EXE_CMD,
    output[31:0] PC,
    output[31:0] Val_Rn, Val_Rm,
    output imm,
    output[11:0] Shift_operand,
    output[23:0] Signed_imm_24,
    output[3:0] Dest
    );

    // TODO: complete WB Stage
    wire[31:0] Result_WB;
    wire writeBackEn;
    wire[3:0] Dest_wb;
    assign {Result_WB, writeBackEn, Dest_wb} = 37'b0;

    // TODO: complete Hazard detect module
    wire hazard;
    assign hazard = 1'b0;

    // TODO: complete Status Register
    wire[3:0] SR;
    assign SR = 4'b0;


    wire WB_EN_temp, MEM_R_EN_temp, MEM_W_EN_temp, B_temp, S_temp;
    wire[3:0] EXE_CMD_temp;
    wire[31:0] Val_Rn_temp, Val_Rm_temp;
    wire imm_temp;
    wire[11:0] Shift_operand_temp;
    wire[23:0] Signed_imm_24_temp;
    wire[3:0] Dest_temp;
    wire[3:0] src1_temp, src2_temp;
    wire Two_src_temp;

    ID_Stage id_stage(
    .clk(clk), 
    .rst(rst),
    .Instruction(Instruction),
    .Result_WB(Result_WB),
    .writeBackEn(writeBackEn),
    .Dest_wb(Dest_wb),
    .hazard(hazard),
    .SR(SR),
    // outputs
    .WB_EN(WB_EN_temp), 
    .MEM_R_EN(MEM_R_EN_temp), 
    .MEM_W_EN(MEM_W_EN_temp), 
    .B(B_temp), 
    .S(S_temp),
    .EXE_CMD(EXE_CMD_temp),
    .Val_Rn(Val_Rn_temp), 
    .Val_Rm(Val_Rm_temp),
    .imm(imm_temp),
    .Shift_operand(Shift_operand_temp),
    .Signed_imm_24(Signed_imm_24_temp),
    .Dest(Dest_temp),
    .src1(src1_temp), 
    .src2(src2_temp),
    .Two_src(Two_src_temp)
    );

    ID_Stage_Reg id_stage_reg(
    .clk(clk), 
    .rst(rst), 
    .flush(flush),
    .WB_EN_IN(WB_EN_temp), 
    .MEM_R_EN_IN(MEM_R_EN_temp), 
    .MEM_W_EN_IN(MEM_W_EN_temp), 
    .B_IN(B_temp), 
    .S_IN(S_temp),
    .EXE_CMD_IN(EXE_CMD_temp),
    .PC_IN(PC_temp),
    .Val_Rn_IN(Val_Rn_temp), 
    .Val_Rm_IN(Val_Rm_temp),
    .imm_IN(imm_temp),
    .Shift_operand_IN(Shift_operand_temp),
    .Signed_imm_24_IN(Signed_imm_24_temp),
    .Dest_IN(Dest_temp),
    //outputs
    .WB_EN(WB_EN), 
    .MEM_R_EN(MEM_R_EN), 
    .MEM_W_EN(MEM_W_EN), 
    .B(B), 
    .S(S),
    .EXE_CMD(EXE_CMD),
    .PC(PC),
    .Val_Rn(Val_Rn), 
    .Val_Rm(Val_Rm),
    .imm(imm),
    .Shift_operand(Shift_operand),
    .Signed_imm_24(Signed_imm_24),
    .Dest(Dest)
    );

endmodule