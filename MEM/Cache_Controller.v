module Cache_Controller(
    input clk, rst, 

    // memory stage unit
    input[31:0] address, 
    input[31:0] wdata,
    input MEM_R_EN, 
    input MEM_W_EN,

    output reg[31:0] rdata,
    output reg ready,

    // SRAM Controller
    output reg[31:0] sram_address,
    output reg[31:0] sram_wdata,
    output reg sram_write_en,
    output reg sram_read_en,
    input[31:0] sram_rdata, 
    input sram_ready
);

    wire [16:0] cache_address;
    wire [31:0] address_1024;
    wire [63:0] cache_write_data;
    wire [31:0] cache_read_data;
    wire cache_hit;

    reg cache_write_en, cache_read_en, cache_invoke, reg_1_load, reg_2_load;
    reg [2:0] ns;
    wire [2:0] ps;


    // Address
    assign address_1024 = address - 1024;
    assign cache_address = address_1024 >> 2;


    // Registers
    Register #(3) ps_reg(.clk(clk), .rst(rst), .r_in(ns), .r_out(ps), .freeze(1'b0), .flush(1'b0));
    Register #(32) cache_write_data_reg0(.clk(clk), .rst(rst), .r_out(cache_write_data[31: 0]), .r_in(sram_rdata), .freeze(~reg_1_load), .flush(1'b0));
    Register #(32) cache_write_data_reg1(.clk(clk), .rst(rst), .r_out(cache_write_data[63:32]), .r_in(sram_rdata), .freeze(~reg_2_load), .flush(1'b0)); 

    // Parameters
    parameter IDLE = 3'b000, CACHE_READ = 3'b001, MEM_READ_1 = 3'b010, MEM_READ_2 = 3'b011, MEM_WRITE = 3'b100, CACHE_WRITE = 3'b101, CACHE_READ_WAIT = 3'b110;    

    // Generate Next State
    always @(*) begin
        case (ps)
            IDLE: begin
                ns <= MEM_R_EN ? CACHE_READ 
                    : MEM_W_EN ? MEM_WRITE
                    : IDLE;
            end 
            CACHE_READ: begin
                ns <= cache_hit ? IDLE : MEM_READ_1;
            end 
            MEM_READ_1: begin
                ns <= sram_ready ? MEM_READ_2 : MEM_READ_1;
            end 
            MEM_READ_2: begin
                ns <= sram_ready ? CACHE_WRITE : MEM_READ_2;
            end 
            CACHE_WRITE: begin
                ns <= CACHE_READ;
            end 
            MEM_WRITE: begin
                ns <= sram_ready ? IDLE : MEM_WRITE;
            end 
            default: 
                ns <= IDLE;
        endcase
    end
        
    // Generate Signals and Outputs
    always @(*) begin
        ready <= 1'b0;
        rdata <= 32'bz;
        sram_address <= 32'bz;
        sram_wdata <= 32'bz;
        sram_write_en <= 1'b0;
        sram_read_en <= 1'b0;
        cache_read_en <= 1'b0;
        cache_write_en <= 1'b0;
        cache_invoke <= 1'b0;
        reg_1_load <= 1'b0;
        reg_2_load <= 1'b0;

        case (ps)
            IDLE: begin
                ready <= ~MEM_R_EN & ~MEM_W_EN;
            end 
            CACHE_READ: begin
                ready <= cache_hit;
                if (cache_hit) rdata <= cache_read_data;
                cache_read_en <= 1'b1;
            end 
            MEM_READ_1: begin
                sram_address <= {address[31:3], 1'b0, address[1:0]};
                sram_read_en <= 1'b1;
                reg_1_load <= sram_ready;
            end 

            MEM_READ_2: begin
                sram_address <= {address[31:3], 1'b1, address[1:0]};
                sram_read_en <= 1'b1;
                reg_2_load <= sram_ready;
            end 

            CACHE_WRITE: begin
                cache_write_en <= 1'b1;
            end 

            MEM_WRITE: begin
                ready <= sram_ready;
                sram_address <= address;
                sram_wdata <= wdata;
                sram_write_en <= 1'b1;
                cache_invoke <= 1'b1;
            end 
        endcase
        
    end

    Cache cache(
        .clk(clk), 
        .rst(rst),
        .address(cache_address),
        .write_data(cache_write_data),

        .cache_read_en(cache_read_en),
        .cache_write_en(cache_write_en),
        .cache_invoke(cache_invoke),

        .read_data(cache_read_data),
        .hit(cache_hit)
    );   

endmodule