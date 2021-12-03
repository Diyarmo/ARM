module IF_Stage(
  input clk, rst, freeze, Branch_taken, 
  input[31:0] BranchAddr,
  output[31:0] PC, Instruction
);

  wire [31:0] pc;
  wire [31:0] pc_out;

  Instruction_Memory ins_mem
  (
      .Address(pc_out),
      .Instruction(Instruction)
  );

  MUX_2_1 #(32) pc_mux
  (
      .f_in(PC),
      .s_in(BranchAddr),
      .select(Branch_taken),
      .out(pc)
  );
  
  Register #(32) pc_reg
  (
      .r_in(pc),
      .freeze(freeze),
      .clk(clk),
      .rst(rst), 
      .flush(1'b0),
      .r_out(pc_out)
  );


  assign PC = pc_out + 4;
  
endmodule