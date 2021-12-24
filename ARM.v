module ARM(input clk, rst);

    wire [31:0] 
    PC_IF, Instruction,
    PC_ID,  
    PC_EXE, 
    PC_MEM, 
    PC_WB;
    wire WB_EN, MEM_R_EN, MEM_W_EN, B, S;
    wire[3:0] EXE_CMD;
    wire[31:0] Val_Rn, Val_Rm;
    wire imm;
    wire[11:0] Shift_operand;
    wire[23:0] Signed_imm_24;
    wire[3:0] Dest;

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
        .WB_EN(WB_EN), 
        .MEM_R_EN(MEM_R_EN), 
        .MEM_W_EN(MEM_W_EN), 
        .B(B), 
        .S(S),
        .EXE_CMD(EXE_CMD),
        .PC(PC_ID),
        .Val_Rn(Val_Rn), 
        .Val_Rm(Val_Rm),
        .imm(imm),
        .Shift_operand(Shift_operand),
        .Signed_imm_24(Signed_imm_24),
        .Dest(Dest)
    );
    
    EXE_Module exe_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_ID),
        .PC(PC_EXE)
    );
    
    MEM_Module mem_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_EXE),
        .PC(PC_MEM)
    );

    WB_Module wb_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_MEM),
        .PC(PC_WB)
    );

endmodule