module ARM(input clk, rst, MEM_CLK, forwarding_en);

    wire [31:0] PC_IF, Instruction, PC_ID, PC_EXE, PC_MEM;
    wire Branch_taken, S;
    wire WB_EN_ID, MEM_R_EN_ID, MEM_W_EN_ID;
    wire WB_EN_EXE, MEM_R_EN_EXE, MEM_W_EN_EXE;
    wire WB_EN_MEM, MEM_R_EN_MEM;
    wire WB_WB_EN;
    wire[3:0] EXE_CMD;
    wire[31:0] Val_Rn, Val_Rm, Val_Rm_EXE;
    wire imm;
    wire[11:0] Shift_operand;
    wire[23:0] Signed_imm_24;
    wire[3:0] Dest_ID, Dest_EXE, Dest_MEM, WB_Dest, reg_file_src_1_out, reg_file_src_2_out, reg_file_src_1_EXE, reg_file_src_2_EXE;
    wire[31:0] ALU_result_EXE, ALU_result_MEM, BranchAddr, WB_Value, MEM_read_value;
    wire[3:0] SR, SR_ID, SR_EXE;
    wire has_two_src, hazard_detected, Ignore_Hazard, SRAM_ready;
    wire[1:0] fu_sel_src1, fu_sel_src2;

    IF_Module if_module(
        .clk(clk),
        .rst(rst),
        .flush(Branch_taken),
        .freeze(hazard_detected | ~SRAM_ready),
        .Branch_taken(Branch_taken),
        .BranchAddr(BranchAddr),
        .PC(PC_IF),
        .Instruction(Instruction)
    );
    
    ID_Module id_module(
        .clk(clk),
        .rst(rst),
        .flush(Branch_taken),
        .freeze(~SRAM_ready),
        .hazard(hazard_detected),
        .Instruction(Instruction),
        .PC_IN(PC_IF),
        .Result_WB(WB_Value),
        .writeBackEn(WB_WB_EN),
        .Dest_wb(WB_Dest),
        .SR_IN(SR),

        .WB_EN(WB_EN_ID), 
        .MEM_R_EN(MEM_R_EN_ID), 
        .MEM_W_EN(MEM_W_EN_ID), 
        .B(Branch_taken), 
        .S(S),
        .SR(SR_ID),
        .EXE_CMD(EXE_CMD),
        .PC(PC_ID),
        .Val_Rn(Val_Rn), 
        .Val_Rm(Val_Rm),
        .imm(imm),
        .Shift_operand(Shift_operand),
        .Signed_imm_24(Signed_imm_24),
        .Dest(Dest_ID),
        .reg_file_src_1_out(reg_file_src_1_out),
        .reg_file_src_2_out(reg_file_src_2_out),
        .has_two_src(has_two_src),
        .Ignore_Hazard(Ignore_Hazard)
    );

    EXE_Module exe_module(
        .clk(clk), 
        .rst(rst),
        .freeze(~SRAM_ready),
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
        .reg_file_src_1_IN(reg_file_src_1_out),
        .reg_file_src_2_IN(reg_file_src_2_out),
        
        .fu_sel_src1(fu_sel_src1),
        .fu_sel_src2(fu_sel_src2),
        .ALU_res(ALU_result_EXE),
        .WB_Value(WB_Value),

        .PC(PC_EXE),
        .WB_EN(WB_EN_EXE), 
        .MEM_R_EN(MEM_R_EN_EXE), 
        .MEM_W_EN(MEM_W_EN_EXE),
        .ALU_result(ALU_result_EXE), 
        .Br_addr(BranchAddr),
        .Val_Rm_out(Val_Rm_EXE),
        .status(SR_EXE), 
        .Dest(Dest_EXE),
        .reg_file_src_1(reg_file_src_1_EXE),
        .reg_file_src_2(reg_file_src_2_EXE)
    );
    
    MEM_Module mem_module(
        .clk(clk),
        .MEM_CLK(MEM_CLK),
        .rst(rst),
        .freeze(~SRAM_ready),
        .PC_IN(PC_EXE),        
   	    .MEM_W_EN_IN(MEM_W_EN_EXE), 
        .MEM_R_EN_IN(MEM_R_EN_EXE), 
        .WB_EN_IN(WB_EN_EXE),
        .ALU_result_IN(ALU_result_EXE), 
        .Val_Rm(Val_Rm_EXE),
        .Dest_IN(Dest_EXE),

        .PC(PC_MEM),
        .WB_EN(WB_EN_MEM), 
        .MEM_R_EN(MEM_R_EN_MEM),
        .ALU_result(ALU_result_MEM), 
        .MEM_read_value(MEM_read_value),
        .Dest(Dest_MEM),
        .SRAM_ready(SRAM_ready)
    );

    WB_Module wb_module(
        .clk(clk),
        .rst(rst),
        .WB_EN(WB_EN_MEM),
        .MEM_R_EN(MEM_R_EN_MEM),
        .ALU_result(ALU_result_MEM),
        .Mem_result(MEM_read_value),
        .Dest(Dest_MEM),
        .WB_Dest(WB_Dest),
        .WB_Value(WB_Value),
        .WB_WB_EN(WB_WB_EN)
    );

    StatusRegister status_register(
        .clk(clk), 
        .rst(rst),
        .S(S),
        .SR_IN(SR_EXE),
        .SR(SR)
    );    

    Hazard_Detection_Unit hazard_detection_unit(
        .src1(reg_file_src_1_out), 
        .src2(reg_file_src_2_out), 
        .EXE_Dest(Dest_ID), 
        .MEM_Dest(Dest_EXE),
        .EXE_WB_EN(WB_EN_ID), 
        .MEM_WB_EN(WB_EN_EXE), 
        .has_two_src(has_two_src),
        .Ignore_Hazard(Ignore_Hazard),
        .forwarding_en(forwarding_en),
        .hazard_detected(hazard_detected),
        .MEM_R_EN_EXE(MEM_R_EN_EXE)
    );

    Forwarding_Unit forwarding_unit(
        .src1(reg_file_src_1_EXE), 
        .src2(reg_file_src_2_EXE),
        .wb_dest(Dest_MEM), 
        .mem_dest(Dest_EXE),
        .wb_wb_en(WB_EN_MEM), 
        .mem_wb_en(WB_EN_EXE),
        .forwarding_en(forwarding_en),
        .Ignore_Hazard(Ignore_Hazard),
        .sel_src1(fu_sel_src1), 
        .sel_src2(fu_sel_src2)
    );

endmodule