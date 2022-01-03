module Memory(
    input clk,
    input MEMread, MEMwrite,
    input [31:0] address, value, 
    output [31:0] MEM_result
);
    reg signed [31:0] data [0:2047];
    
    wire[31:0] address_1024, final_address;
    assign address_1024 = address - 1024;
    assign final_address = address_1024 >> 2; 
    
    assign MEM_result = MEMread?data[final_address]:32'b0;  // READ
    
    integer j;
    initial begin
      for(j = 0; j < 2048; j = j + 1)
      data[j] = 0;
    end

    // WRITE
    always @(posedge clk) begin
      if(MEMwrite == 1)begin
        data[final_address] <= value;
      end
    end

endmodule