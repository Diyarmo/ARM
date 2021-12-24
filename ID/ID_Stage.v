module ID_Stage(
  input clk, rst,
  //from IF Reg
  input[31:0] Instruction,
  //from WB stage
  input[31:0] Result_WB,
  input writeBackEn,
  input[3:0] Dest_wb,
  //from hazard detect module
  input hazard,
  //from Status Register
  input[3:0] SR,
  // t0 next stage
  output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output[3:0] EXE_CMD,
  output[31:0] Val_Rn, Val_Rm,
  output imm,
  output[11:0] Shift_operand,
  output[23:0] Signed_imm_24,
  output[3:0] Dest,
  output[3:0] src1, src2,
  output Two_src
);

  wire[1:0] mode;
  wire[3:0] opcode, exe_cmd, cond, Rn, Rm, Rd, RF_src2;
  wire status, mem_read, mem_write, wb_en, branch, status_update, cond_check, control_unit_mux_select;
  wire CU_mux_select;

  assign cond = Instruction[31:28];
  assign mode = Instruction[27:26];
  assign imm = Instruction[25];
  assign opcode = Instruction[24:21];
  assign Signed_imm_24 = Instruction[23:0];
  assign status = Instruction[20];
  assign Rn = Instruction[19:16];
  assign Rd = Instruction[15:12];
  assign Shift_operand = Instruction[11:0];
  assign Rm = Instruction[3:0];

  assign src1 = Rn;
  assign src2 = RF_src2;
  assign Two_src = ~imm | mem_write;
  // ================={Condition Check}=================
  
  ConditionCheck conditionCheck 
(
    .cond(cond),
    .z(SR[3]), 
    .c(SR[2]), 
    .v(SR[1]), 
    .n(SR[0]), 
    .check(cond_check)
);
// ===============END================

// ================={Control Unit}=================

  ControlUnit controlUnit(
    .mode(mode),
    .opcode(opcode),
    .status(status),
    .exe_cmd(exe_cmd),
    .mem_read(mem_read), 
    .mem_write(mem_write), 
    .WB_Enable(wb_en), 
    .branch(branch),
    .status_update(status_update)
);

  assign CU_mux_select = hazard | (~cond_check);

  MUX_2_1 #(9) CU_mux
  (
    .f_in({exe_cmd, mem_read, mem_write, wb_en, branch, status_update}),
    .s_in(9'b0),
    .select(~cond_check),
    .out({EXE_CMD, MEM_R_EN, MEM_W_EN, WB_EN, B, S})
  );

// ===============END================

// ================{Register File}==================

  MUX_2_1 #(4) RF_src2_mux
  (
    .f_in(Rm),
    .s_in(Rd),
    .select(~mem_write),
    .out(RF_src2)
  );

  RegisterFile registerFile(      
    .clk(clk), 
    .rst(rst), 
    .src1(Rn), 
    .src2(RF_src2),
    .Dest_wb(Dest_wb),
	  .Result_WB(Result_WB),
    .writeBackEn(writeBackEn),
	  .reg1(Val_Rn), 
    .reg2(Val_Rm)
    );
// ===============END================


endmodule
