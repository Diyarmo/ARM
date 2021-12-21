module ControlUnit
(
    input [1:0] mode,
    input [3:0] opcode,
    input status,
    output reg [3:0] exe_cmd,
    output reg mem_read, mem_write, WB_Enable, branch,
    output status_update
);

  
endmodule