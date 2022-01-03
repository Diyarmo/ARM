module MEM_Stage(
  input clk, rst,
  input MEM_W_EN, MEM_R_EN,
  input[31:0] ALU_Res, Val_Rm,
  output[31:0] MEM_result
);
  
  Memory memory(
    .clk(clk), 
    .MEMread(MEM_R_EN), 
    .MEMwrite(MEM_W_EN),
    .address(ALU_Res), 
    .value(Val_Rm), 
    .MEM_result(MEM_result)
  );

endmodule
