module MEM_Stage
# (parameter USE_SRAM = 1, USE_CACHE = 1)
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
    wire[31:0] sram_address, sram_wdata, sram_rdata;
    wire sram_write_en, sram_read_en, sram_ready;
     
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
        .write_en(sram_write_en), 
        .read_en(sram_read_en),
        .address(sram_address),
        .writeData(sram_wdata),

        .readData(sram_rdata),
        .ready(sram_ready),
        .SRAM_DQ(SRAM_DQ),
        .SRAM_ADDR(SRAM_ADDR),
        .SRAM_WE_N(SRAM_WE_N)
      );
      if (USE_CACHE) begin
        Cache_Controller cache_controller(
          .clk(clk), 
          .rst(rst), 

          .address(ALU_Res), 
          .wdata(Val_Rm),
          .MEM_R_EN(MEM_R_EN), 
          .MEM_W_EN(MEM_W_EN),

          //output
          .rdata(MEM_result),
          .ready(SRAM_ready),

          .sram_rdata(sram_rdata), 
          .sram_ready(sram_ready),
          //output
          .sram_address(sram_address),
          .sram_wdata(sram_wdata),
          .sram_write_en(sram_write_en),
          .sram_read_en(sram_read_en)
          
        );
      end
    else begin
      assign sram_write_en = MEM_W_EN;
      assign sram_read_en = MEM_R_EN;
      assign sram_address = ALU_Res;
      assign sram_wdata = Val_Rm;
      assign MEM_result = sram_rdata;
      assign SRAM_ready = sram_ready;
    end
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
