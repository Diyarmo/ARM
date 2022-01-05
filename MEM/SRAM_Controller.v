module SRAM_Controller
# (parameter SRAM_WAIT_CYCLES = 6)
(
    input clk, 
    input rst,

    input write_en, read_en,
    input [31:0] address,
    input [31:0] writeData,

    output signed [31:0] readData,

    output ready,
    
    inout signed [31:0] SRAM_DQ,
    output [16:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);
        
    wire[1:0] ps, ns;
    wire [31:0] address_1024;
    wire [16:0] final_address;
    wire[2:0] counter, n_counter;


    // Unuseful outputs
    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'b0;    


    // Registers
    parameter S_IDLE = 2'b00, S_READ = 2'b01, S_WRITE = 2'b10;  // States
    Register #(2) ps_reg(.clk(clk), .rst(rst), .r_in(ns), .r_out(ps), .freeze(1'b0), .flush(1'b0));
    Register #(3) counter_reg(.clk(clk), .rst(rst), .r_in(n_counter), .r_out(counter), .freeze(1'b0), .flush(1'b0));

    
    // Generate Next State
    assign ns = (ps == S_IDLE && write_en) ? S_WRITE :
                (ps == S_WRITE && counter != SRAM_WAIT_CYCLES) ? S_WRITE :
                (ps == S_IDLE && read_en) ? S_READ :
                (ps == S_READ && counter != SRAM_WAIT_CYCLES) ? S_READ :
                S_IDLE;


    // Generate Next Counter
    assign n_counter = ((ps == S_READ | ps == S_WRITE) && counter != SRAM_WAIT_CYCLES) ? counter + 1 :
                          3'b0;


    // Address
    assign address_1024 = address - 1024;
    assign final_address = address_1024 >> 2;
 

    // Outputs
    assign SRAM_WE_N = (ps == S_WRITE && counter != SRAM_WAIT_CYCLES) ? 1'b0 : 1'b1; 
    assign SRAM_DQ = (ps == S_WRITE && counter != SRAM_WAIT_CYCLES) ? writeData : 32'bz;
    assign readData = SRAM_DQ;    
    assign SRAM_ADDR = final_address;
    assign ready = ((ps == S_READ | ps == S_WRITE) && counter != SRAM_WAIT_CYCLES) ? 1'b0 :
                   ((ps == S_IDLE) && (write_en || read_en)) ? 1'b0 :
                   1'b1;
    
endmodule