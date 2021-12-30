module ALU(
  input[31:0] in1, in2,
  input[3:0] EXE_CMD,
  input C_in,
  output reg[31:0] result,
  output reg C, V,
  output Z, N
  );

  assign Z = &{~{result}};
  assign N = result[31];
  
  
  always@(*) begin
    {result, C, V} = 0; 
    case(EXE_CMD)
        4'b0001: begin // MOV
            result = in2;
        end
        4'b1001: begin // MVN
            result = ~in2;
        end
        4'b0010: begin // ADD
            {C, result} = {in1[31], in1} + {in2[31], in2};
            V = C ^ result[31];
        end
        4'b0011: begin // ADC
            {C, result} = {in1[31], in1} + {in2[31], in2} + C_in;
            V = C ^ result[31];
        end
        4'b0100: begin // SUB
            {C, result} = {in1[31], in1} - {in2[31], in2};
            V = C ^ result[31];
        end
        4'b0101: begin // SBC
            {C, result} = {in1[31], in1} - {in2[31], in2} - {32'b0, ~C_in};
            V = C ^ result[31];
        end
        4'b0110: begin // AND
            result = in1 & in2;
        end
        4'b0111: begin // ORR
            result = in1 | in2;
        end
        4'b1000: begin // EOR
            result = in1 ^ in2;
        end
        4'b0100: begin // CMP
            {C, result} = {in1[31], in1} - {in2[31], in2};
            V = C ^ result[31];
        end
        4'b0011: begin // TST
            result = in1 & in2;
        end
        4'b0010: begin // LDR STR
            {C, result} = {in1[31], in1} + {in2[31], in2};
            V = C ^ result[31];
        end
    endcase
  end


endmodule
