module IF_Stage_Reg(
  input clk, rst, freeze, flush,
  input[31:0] PC_in, Instruction_in,
  output[31:0] PC, Instruction
);

  Register #(32) PC_reg(
      .r_in(PC_in),
      .freeze(freeze),
      .clk(clk),
      .rst(rst), 
      .flush(flush),
      .r_out(PC)
  );

  Register #(32) Instruction_reg(
      .r_in(Instruction_in),
      .freeze(freeze),
      .clk(clk),
      .rst(rst), 
      .flush(flush),
      .r_out(Instruction)
  );

endmodule
