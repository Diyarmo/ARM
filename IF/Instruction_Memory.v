module Instruction_Memory(
  output reg[31 : 0] Instruction, 
  input[31: 0] Address
  );

  reg [31:0] data[0:6];

  
  initial begin
    data[0] = 32'b000000_00001_00010_00000_00000000000; 
    data[1] = 32'b000000_00011_00100_00000_00000000000; 
    data[2] = 32'b000000_00101_00110_00000_00000000000; 
    data[3] = 32'b000000_00111_01000_00010_00000000000; 
    data[4] = 32'b000000_01001_01010_00011_00000000000; 
    data[5] = 32'b000000_01011_01100_00000_00000000000; 
    data[6] = 32'b000000_01101_01110_00000_00000000000; 
  end

  always @(Address) begin
    Instruction = data[Address[31:2]];
  end

endmodule