module EXE_Stage(
  input clk, rst,
  input[3:0] EXE_CMD,
  input MEM_R_EN, MEM_W_EN, 
  input[31:0] PC,
  input[31:0] Val_Rn, Val_Rm, 
  input imm,
  input[11:0] Shift_operand,
  input[23:0] Signed_imm_24,
  input[3:0] SR,

  input[1:0] fu_sel_src1, fu_sel_src2,
  input[31:0] ALU_res, WB_Value, 

  output[31:0] ALU_result, Br_addr, Val_Rm_out,
  output[3:0] status
  );

  wire is_mem;
	assign is_mem = MEM_R_EN | MEM_W_EN;
	
	wire [31:0] Signed_EX_imm24, alu_val2;
	assign Signed_EX_imm24 = {{6{Signed_imm_24[23]}}, Signed_imm_24, 2'b0};
	assign Br_addr = Signed_EX_imm24 + PC;

  wire[31:0] alu_src1_out, alu_src2_out;

  MUX_3_1 #(32) alu_src1_mux(
    .f_in(Val_Rn),
    .s_in(ALU_res),
    .t_in(WB_Value),
    .select(fu_sel_src1),
    .out(alu_src1_out)
  );

  MUX_3_1 #(32) alu_src2_mux(
    .f_in(Val_Rm),
    .s_in(ALU_res),
    .t_in(WB_Value),
    .select(fu_sel_src2),
    .out(alu_src2_out)
  );

  assign Val_Rm_out = alu_src2_out;

  Val2Generator val2generator(
  .Val_Rm(alu_src2_out),
  .Shift_operand(Shift_operand),
  .imm(imm),
  .is_mem(is_mem),
  .Val2(alu_val2)
);

  ALU alu(
  .in1(alu_src1_out), 
  .in2(alu_val2),
  .EXE_CMD(EXE_CMD),
  .C_in(SR[2]),
  .result(ALU_result),
  .N(status[0]),
  .V(status[1]),
  .C(status[2]), 
  .Z(status[3])
  );
    

endmodule
