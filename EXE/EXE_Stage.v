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

  output[31:0] ALU_result, Br_addr,
  output[3:0] status
  );

  wire is_mem;
	assign is_mem = MEM_R_EN | MEM_W_EN;
	
	wire [31:0] Signed_EX_imm24, alu_val2;
	assign Signed_EX_imm24 = {{6{Signed_imm_24[23]}}, Signed_imm_24, 2'b0};
	assign Br_addr = Signed_EX_imm24 + PC;

  Val2Generator val2generator(
  .Val_Rm(Val_Rm),
  .Shift_operand(Shift_operand),
  .imm(imm),
  .is_mem(is_mem),
  .Val2(alu_val2)
);

  ALU alu(
  .in1(Val_Rn), 
  .in2(alu_val2),
  .EXE_CMD(EXE_CMD),
  .C_in(SR[1]),
  .result(ALU_result),
  .N(status[0]),
  .V(status[1]),
  .C(status[2]), 
  .Z(status[3])
  );
    

endmodule
