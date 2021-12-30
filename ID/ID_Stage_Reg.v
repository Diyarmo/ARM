module ID_Stage_Reg(
  input clk, rst, flush,
  input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN,
  input[3:0] SR_IN, EXE_CMD_IN,
  input[31:0] PC_IN,
  input[31:0] Val_Rn_IN, Val_Rm_IN,
  input imm_IN,
  input[11:0] Shift_operand_IN,
  input[23:0] Signed_imm_24_IN,
  input[3:0] Dest_IN,

  output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output[3:0] SR, EXE_CMD,
  output[31:0] PC,
  output[31:0] Val_Rn, Val_Rm,
  output imm,
  output[11:0] Shift_operand,
  output[23:0] Signed_imm_24,
  output[3:0] Dest
);

  Register #(1) WB_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(WB_EN_IN), .r_out(WB_EN));

  Register #(1) MEM_R_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(MEM_R_EN_IN), .r_out(MEM_R_EN));

  Register #(1) MEM_W_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(MEM_W_EN_IN), .r_out(MEM_W_EN));

  Register #(1) B_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(B_IN), .r_out(B));

  Register #(1) S_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(S_IN), .r_out(S));

  Register #(4) EXE_CMD_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(EXE_CMD_IN), .r_out(EXE_CMD));

  Register #(4) SR_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(SR_IN), .r_out(SR));

  Register #(32) PC_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(PC_IN), .r_out(PC));

  Register #(32) Val_Rn_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Val_Rn_IN), .r_out(Val_Rn));

  Register #(32) Val_Rm_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Val_Rm_IN), .r_out(Val_Rm));

  Register #(1) imm_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(imm_IN), .r_out(imm));

  Register #(12) Shift_operand_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Shift_operand_IN), .r_out(Shift_operand));

  Register #(24) Signed_imm_24_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Signed_imm_24_IN), .r_out(Signed_imm_24));

  Register #(4) Dest_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Dest_IN), .r_out(Dest));

  endmodule
