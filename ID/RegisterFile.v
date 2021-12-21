`include "Defines.v"

module RegisterFile (
	input clk, rst, 
    input[3:0] src1, src2, Dest_wb,
	input[31:0] Result_WB,
    input writeBackEn,
	output [31:0] reg1, reg2
);
    integer i = 0;
    reg[31:0] data[0:14];

    assign reg1 = data[src1];
    assign reg2 = data[src2];

    always @(negedge clk, posedge rst) begin
		if (rst) begin
			for(i=0; i < 14; i=i+1)
				data[i] <= i;
        end
        else if (writeBackEn) data[Dest_wb] = Result_WB;
	end

endmodule