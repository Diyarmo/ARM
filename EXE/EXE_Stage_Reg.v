module EXE_Stage_Reg(
  input clk, rst,
  input[31:0] PC_in,
  output reg[31:0] PC
  );

  always @(posedge clk) PC <= PC_in;
    
endmodule
