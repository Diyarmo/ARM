module ARM(input clk, rst);

    wire [31:0] 
    PC_IF, Instruction,
    PC_ID,  
    PC_EXE, 
    PC_MEM, 
    PC_WB;
    wire B, S;
    wire WB_EN_ID, MEM_R_EN_ID, MEM_W_EN_ID;
    wire WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE;
    wire WB_WB_EN;
    wire[3:0] EXE_CMD;
    wire[31:0] Val_Rn, Val_Rm;
    wire imm;
    wire[11:0] Shift_operand;
    wire[23:0] Signed_imm_24;
    wire[3:0] Dest_ID, Dest_EXE, WB_Dest;
    wire[31:0] ALU_result, BranchAddr, WB_Value;
    wire[3:0] SR, SR_ID, SR_EXE;

    IF_Module if_module(
        .clk(clk),
        .rst(rst),
        .PC(PC_IF),
        .Instruction(Instruction)
    );
    
    ID_Module id_module(
        .clk(clk),
        .rst(rst),
        .Instruction(Instruction),
        .PC_IN(PC_IF),
        .Result_WB(WB_Value),
        .writeBackEn(WB_WB_EN),
        .Dest_wb(WB_Dest),
        .SR_IN(SR),

        .WB_EN(WB_EN_ID), 
        .MEM_R_EN(MEM_R_EN_ID), 
        .MEM_W_EN(MEM_W_EN_ID), 
        .B(B), 
        .S(S),
        .SR(SR_ID),
        .EXE_CMD(EXE_CMD),
        .PC(PC_ID),
        .Val_Rn(Val_Rn), 
        .Val_Rm(Val_Rm),
        .imm(imm),
        .Shift_operand(Shift_operand),
        .Signed_imm_24(Signed_imm_24),
        .Dest(Dest_ID)
    );

    EXE_Module exe_module(
    .clk(clk), 
    .rst(rst),
    .EXE_CMD(EXE_CMD),
    .WB_EN_IN(WB_EN_ID), 
    .MEM_R_EN_IN(MEM_R_EN_ID), 
    .MEM_W_EN_IN(MEM_W_EN_ID), 
    .PC_IN(PC_ID),
    .Val_Rn(Val_Rn), 
    .Val_Rm(Val_Rm), 
    .imm(imm),
    .Shift_operand(Shift_operand),
    .Signed_imm_24(Signed_imm_24),
    .SR(SR_ID),
    .Dest_IN(Dest_ID),

    .WB_EN(WB_EN_EXE), 
    .MEM_R_EN(MEM_R_EN_EXE), 
    .MEM_W_EN(MEM_W_EN_EXE),
    .ALU_result(ALU_result), 
    .Br_addr(BranchAddr),
    .status(SR_EXE), 
    .Dest(Dest_EXE)
    );

    StatusRegister status_register (
    .clk(clk), 
    .rst(rst),
    .S(S),
    .SR_IN(SR_EXE),
    .SR(SR)
);
    
    
    // MEM_Module mem_module(
    //     .clk(clk),
    //     .rst(rst),
    //     .PC_in(PC_EXE),
    //     .PC(PC_MEM)
    // );

    WB_Module wb_module(
        .clk(clk),
        .rst(rst),
        .WB_EN(WB_EN_EXE),
        .MEM_R_EN(MEM_R_EN_EXE),
        .ALU_result(ALU_result),
        .Mem_result(32'bz),
        .Dest(Dest_EXE),
        .WB_Dest(WB_Dest),
        .WB_Value(WB_Value),
        .WB_WB_EN(WB_WB_EN)
    );

endmodule