module StatusRegister (
    input clk, rst,
    input S,
    input[3:0] SR_IN,
    output reg[3:0] SR
);

	always@(negedge clk, posedge rst) begin
		if (rst) SR <= 4'b0;
		else if (S) SR <= SR_IN;
	end
	
endmodule