module Cache(
    input clk, rst,
    input [16:0] address,
    input [63:0] write_data,

    input cache_read_en,
    input cache_write_en,
    input cache_invoke,  

    output [31:0] read_data,
    output hit
);

    // Split Address
    wire [9:0] tag;
    wire offset;
    wire [5:0] index;
    assign tag = address[16:7];
    assign index = address[6:1];
    assign offset = address[0];

    // Blocks, Tags, Valid, LRU
    reg [31:0] data0 [0:1][0:63];
    reg [31:0] data1 [0:1][0:63];
    reg [9:0] tag0 [0:63];
    reg [9:0] tag1 [0:63];
    reg valid0 [0:63];
    reg valid1 [0:63];
    reg lru [0:63];


    // Init to Zero
    integer i;
    initial begin
        for (i = 0; i <= 63; i = i + 1) begin
            tag0[i] = 10'b0;
            tag1[i] = 10'b0;
            valid0[i] = 1'b0;
            valid1[i] = 1'b0;
            lru[i] = 1'b0;
        end
    end


    // Compute Hits
    wire hit0, hit1;
    assign hit0 = (tag0[index] == tag) && valid0[index];
    assign hit1 = (tag1[index] == tag) && valid1[index];
    assign hit = hit1 || hit0;


    // Write
    wire[31:0] data_in0, data_in1;
    assign data_in0 = write_data[31:0];
    assign data_in1 = write_data[63:32];
    always @(posedge clk) begin
        if (cache_write_en) begin
            if (lru[index]) begin
                data0[0][index] <= data_in0;
                data0[1][index] <= data_in1;
                tag0[index] <= tag;
                valid0[index] <= 1'b1;
            end
            else begin
                data1[0][index] <= data_in0;
                data1[1][index] <= data_in1;
                tag1[index] <= tag;
                valid1[index] <= 1'b1;
            end
        end
    end


    // Read
    MUX_2_1 #(32) data_mux(
        .f_in(data0[offset][index]), 
        .s_in(data1[offset][index]),
        .select(hit1),
        .out(read_data) 
    );

    always @(*) begin
        if (cache_read_en && hit) lru[index] <= hit0;
    end

    // Invoke
    always @(*) begin
        if (cache_invoke && hit) begin
            lru[index] = hit0;
            if (hit0) valid0[index] = 1'b0;
            else valid1[index] = 1'b0;
        end
    end


endmodule