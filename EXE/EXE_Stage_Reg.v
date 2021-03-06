module EXE_Stage_Reg(
  input clk, rst, flush, freeze, WB_en_IN, MEM_R_EN_IN, MEM_W_EN_IN, 
  input[31:0] ALU_result_IN, ST_val_IN, PC_IN,
  input[3:0] Dest_IN, reg_file_src_1_IN, reg_file_src_2_IN,
  output WB_en, MEM_R_EN, MEM_W_EN,
  output [31:0] ALU_result, ST_val, PC,
  output [3:0] Dest, reg_file_src_1, reg_file_src_2
  );

 Register #(1) WB_en_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(WB_en_IN), .r_out(WB_en));
 Register #(1) MEM_R_EN_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(MEM_R_EN_IN), .r_out(MEM_R_EN));
 Register #(1) MEM_W_EN_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(MEM_W_EN_IN), .r_out(MEM_W_EN));
 Register #(32) ALU_result_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(ALU_result_IN), .r_out(ALU_result));
 Register #(32) ST_val_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(ST_val_IN), .r_out(ST_val));
 Register #(4) Dest_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(Dest_IN), .r_out(Dest));
 Register #(4) src1_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(reg_file_src_1_IN), .r_out(reg_file_src_1));
 Register #(4) src2_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(reg_file_src_2_IN), .r_out(reg_file_src_2));
 Register #(32) PC_reg(.clk(clk), .rst(rst), .freeze(freeze), .flush(flush), 
                          .r_in(PC_IN), .r_out(PC));
 
    
endmodule
