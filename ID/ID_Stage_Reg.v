module ID_Stage_Reg(
  input clk, rst, flush,
  input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN,
  input[3:0] EXE_CMD_IN,
  input[31:0] PC_IN,
  input[31:0] Val_Rn_IN, Val_Rm_IN,
  input imm_IN,
  input[11:0] Shift_operand_IN,
  input[23:0] Signed_imm_24_IN,
  input[3:0] Dest_IN,

  output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output[3:0] EXE_CMD,
  output[31:0] PC,
  output[31:0] Val_Rn, Val_Rm,
  output imm,
  output[11:0] Shift_operand,
  output[23:0] Signed_imm_24,
  output[3:0] Dest
);

  always @(posedge clk) PC <= PC_IN;

endmodule
