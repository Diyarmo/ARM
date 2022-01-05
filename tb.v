module tb();

reg clk = 1'b0, rst = 1'b0, MEM_CLK = 1'b0;
reg forwarding_en = 1'b1;

initial repeat(2000) #10 clk = ~clk;
initial repeat(1000) #20 MEM_CLK = ~MEM_CLK;

ARM arm(.clk(clk), .MEM_CLK(MEM_CLK), .rst(rst), .forwarding_en(forwarding_en));

initial begin
    #500
    rst = 1;
    #500
    rst = 0;
end

endmodule