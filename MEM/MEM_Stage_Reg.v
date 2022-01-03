module MEM_Stage_Reg(
  input clk, rst, flush, WB_EN_IN, MEM_R_EN_IN,
  input[31:0] ALU_result_IN, MEM_read_value_IN, PC_IN,
  input[3:0] Dest_IN, 
  output WB_EN, MEM_R_EN,
  output [31:0] ALU_result, MEM_read_value, PC,
  output [3:0] Dest
);
  
Register #(1) WB_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(WB_EN_IN), .r_out(WB_EN));

Register #(1) MEM_R_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(MEM_R_EN_IN), .r_out(MEM_R_EN));

Register #(32) ALU_result_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(ALU_result_IN), .r_out(ALU_result));

Register #(32) MEM_read_value_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(MEM_read_value_IN), .r_out(MEM_read_value));

Register #(4) Dest_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Dest_IN), .r_out(Dest));

Register #(32) PC_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(PC_IN), .r_out(PC));

endmodule
