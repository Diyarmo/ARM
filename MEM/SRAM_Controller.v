module SRAM_Controller
# (parameter SRAM_WAIT_CYCLES = 5)
(
    input clk, 
    input rst,

    input write_en, read_en,
    input [31:0] address,
    input [31:0] writeData,

    output signed [31:0] readData,

    output reg ready,
    
    inout signed [31:0] SRAM_DQ,
    output [16:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output reg SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);
        
    reg[1:0] ns;
    wire[1:0] ps;
    wire [31:0] address_1024;
    wire [16:0] final_address;
    wire[2:0] counter, n_counter;
    reg count_en, DQ_out_en;
    reg signed[31:0] SRAM_DQ_temp;

    // Unuseful outputs
    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'b0;    


    // Registers
    parameter S_IDLE = 2'b00, S_READ = 2'b01, S_WRITE = 2'b10;
    Register #(2) ps_reg(.clk(clk), .rst(rst), .r_in(ns), .r_out(ps), .freeze(1'b0), .flush(1'b0));
    Register #(3) counter_reg(.clk(clk), .rst(rst), .r_in(n_counter), .r_out(counter), .freeze(1'b0), .flush(1'b0));

    
    // Generate Next State
    always @(*) begin
        case (ps)
            S_IDLE: begin
                ns <= write_en ? S_WRITE 
                    : read_en ? S_READ : S_IDLE;
            end 
            S_READ: begin
                ns <= (counter != SRAM_WAIT_CYCLES) ? S_READ : S_IDLE;
            end 
            S_WRITE: begin
                ns <= (counter != SRAM_WAIT_CYCLES) ? S_WRITE : S_IDLE;
            end 
            default: 
                ns <= S_IDLE;
        endcase
    end

    // Generate Next Counter
    assign n_counter = (count_en) ? counter + 1 :
                          3'b0;


    // Address
    assign address_1024 = address - 1024;
    assign final_address = address_1024 >> 2;
    assign readData = SRAM_DQ;    
    assign SRAM_ADDR = final_address;

    // Outputs
    always @(*) begin
        SRAM_DQ_temp <= 32'bz;
        SRAM_WE_N <= 1'b1;
        ready <= 1'b1;
        count_en <= 1'b0;
        DQ_out_en <= 1'b0;
        case (ps)
            S_IDLE: begin
                if (write_en || read_en)
                    ready <= 1'b0;
            end 
            S_READ: begin
                if (counter != SRAM_WAIT_CYCLES)
                    ready <= 1'b0;
                count_en <= (counter != SRAM_WAIT_CYCLES);
            end 
            S_WRITE: begin
                if (counter != SRAM_WAIT_CYCLES)
                    ready <= 1'b0;
                count_en <= (counter != SRAM_WAIT_CYCLES);
                SRAM_WE_N <= (counter == SRAM_WAIT_CYCLES);
                // SRAM_DQ_temp <= writeData;
                SRAM_DQ_temp <= (counter != SRAM_WAIT_CYCLES) ? writeData : 32'bz;
            end 
        endcase
    end
    assign SRAM_DQ = SRAM_DQ_temp;
    
endmodule