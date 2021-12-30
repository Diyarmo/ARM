module EXE_Stage_Reg(
  input clk, rst, flush, WB_en_IN, MEM_R_EN_IN, MEM_W_EN_IN, 
  input[31:0] ALU_result_IN, ST_val_IN,
  input[3:0] Dest_IN,
  output WB_en, MEM_R_EN, MEM_W_EN,
  output [31:0] ALU_result, ST_val,
  output [3:0] Dest
  );

 Register #(1) WB_en_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(WB_en_IN), .r_out(WB_en));
 Register #(1) MEM_R_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(MEM_R_EN_IN), .r_out(MEM_R_EN));
 Register #(1) MEM_W_EN_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(MEM_W_EN_IN), .r_out(MEM_W_EN));
 Register #(32) ALU_result_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(ALU_result_IN), .r_out(ALU_result));
 Register #(32) ST_val_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(ST_val_IN), .r_out(ST_val));
 Register #(4) Dest_reg(.clk(clk), .rst(rst), .freeze(1'b0), .flush(flush), 
                          .r_in(Dest_IN), .r_out(Dest));

    
endmodule
