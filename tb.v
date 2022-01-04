module tb();

reg clk = 1'b0, rst = 1'b0;
reg forwarding_en = 1'b1;

initial repeat(1000) #50 clk = ~clk;

ARM arm(.clk(clk), .rst(rst), .forwarding_en(forwarding_en));

initial begin
    #500
    rst = 1;
    #500
    rst = 0;
end

endmodule