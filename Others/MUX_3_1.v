module MUX_3_1
#(parameter SIZE = 8)
(
    input wire [SIZE - 1:0] f_in,
    input wire [SIZE - 1:0] s_in,
    input wire [SIZE - 1:0] t_in,
    input[1:0] select,
    output wire [SIZE - 1:0] out
);
    assign out = (select == 2'b00) ? f_in
                :(select == 2'b01) ? s_in
                :(select == 2'b10) ? t_in
                :{SIZE{1'bz}};
endmodule