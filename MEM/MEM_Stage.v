module MEM_Stage
# (parameter USE_SRAM = 1)
(
  input clk, rst, MEM_CLK,
  input MEM_W_EN, MEM_R_EN,
  input[31:0] ALU_Res, Val_Rm,
  output[31:0] MEM_result,
  output SRAM_ready
);
  generate
    wire SRAM_WE_N;
    wire[16:0] SRAM_ADDR;
    wire[31:0] SRAM_DQ;
     
    if (USE_SRAM) begin
      SRAM_Memory sram_memory(
        .clk(MEM_CLK),
        .rst(rst),
        .SRAM_WE_N(SRAM_WE_N),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_DQ(SRAM_DQ)
      );

      SRAM_Controller sram_controller(
        .clk(clk), 
        .rst(rst),
        .write_en(MEM_W_EN), 
        .read_en(MEM_R_EN),
        .address(ALU_Res),
        .writeData(Val_Rm),

        .readData(MEM_result),

        .ready(SRAM_ready),

        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_WE_N(SRAM_WE_N)
      );
    end
    else begin
      Memory memory(
        .clk(clk), 
        .MEMread(MEM_R_EN), 
        .MEMwrite(MEM_W_EN),
        .address(ALU_Res), 
        .value(Val_Rm), 
        .MEM_result(MEM_result)
      ); 
      assign SRAM_ready = 1'b1;
    end
  endgenerate

endmodule
