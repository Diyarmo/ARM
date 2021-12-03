module MUX_2_1
#(parameter SIZE = 8)
(
    input wire [SIZE - 1:0] f_in,
    input wire [SIZE - 1:0] s_in,
    input select,
    output wire [SIZE - 1:0] out
);
    assign out = (select) ? s_in:f_in;
endmodule