module SRAM_Memory(
    input clk,
    input rst,
    input SRAM_WE_N,
    input[16:0] SRAM_ADDR,
    inout[31:0] SRAM_DQ
);
    reg[31:0] data[0:511];

    assign #30 SRAM_DQ = SRAM_WE_N ? data[SRAM_ADDR]: 32'bz;

    always @(posedge clk) begin
        if(~SRAM_WE_N) begin
            data[SRAM_ADDR] = SRAM_DQ;
        end
    end
endmodule