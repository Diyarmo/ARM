module Register 
# (parameter SIZE = 32)
(
    input [SIZE - 1:0] r_in,
    input clk,
    input rst, 
    input freeze, flush,
    output reg [SIZE - 1:0] r_out
);
    always @(posedge clk,posedge rst) begin
      if (rst) r_out <= 0;
      else if (!freeze) begin
        if (!flush) r_out <= r_in;
        else r_out <= 0;
      end
    end
endmodule
