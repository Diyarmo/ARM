module Forwarding_Unit(
    input [3:0] src1, src2,
    input [3:0] wb_dest, mem_dest,
    input wb_wb_en, mem_wb_en,
    input forwarding_en,
    input Ignore_Hazard,
    output [1:0] sel_src1, sel_src2
);
assign sel_src1 = (forwarding_en == 1'b0)? 2'b00
                 :(src1 == mem_dest && mem_wb_en) ? 2'b01 
                 :(src1 == wb_dest && wb_wb_en) ? 2'b10 
                 :2'b00 
                 ;

assign sel_src2 = (forwarding_en == 1'b0)? 2'b00
                 :(src2 == mem_dest && mem_wb_en) ? 2'b01 
                 :(src2 == wb_dest && wb_wb_en) ? 2'b10 
                 :2'b00 
                 ;
                  
endmodule