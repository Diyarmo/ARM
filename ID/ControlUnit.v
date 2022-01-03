module ControlUnit
(
    input [1:0] mode,
    input [3:0] opcode,
    input status,
    output reg [3:0] exe_cmd,
    output reg mem_read, mem_write, WB_Enable, branch, ignore_hazard,
    output status_update
);
    always @(*) begin
        {exe_cmd, mem_read, mem_write, WB_Enable, branch, ignore_hazard} <= 0;
        case(mode)
            2'b0: begin  // Arithmetic
                    case (opcode)
                        4'b1101: begin //MOV
                            exe_cmd <= 4'b0001;
                            WB_Enable <= 1'b1;
                            ignore_hazard <= 1'b1;
                        end
                        4'b1111: begin //MVN
                            exe_cmd <= 4'b1001;
                            WB_Enable <= 1'b1;
                            ignore_hazard <= 1'b1;
                        end
                        4'b0100: begin //ADD
                            exe_cmd <= 4'b0010;
                            WB_Enable <= 1'b1;
                        end
                        4'b0101: begin //ADC
                            exe_cmd <= 4'b0011;
                            WB_Enable <= 1'b1;
                        end
                        4'b0010: begin //SUB
                            exe_cmd <= 4'b0100;
                            WB_Enable <= 1'b1;
                        end
                        4'b0110: begin //SBC
                            exe_cmd <= 4'b0101;
                            WB_Enable <= 1'b1;
                        end
                        4'b0000: begin //AND
                            exe_cmd <= 4'b0110;
                            WB_Enable <= 1'b1;
                        end
                        4'b1100: begin //ORR
                            exe_cmd <= 4'b0111;
                            WB_Enable <= 1'b1;
                        end
                        4'b0001: begin //EOR
                            exe_cmd <= 4'b1000;
                            WB_Enable <= 1'b1;
                        end
                        4'b1010: begin //CMP
                            exe_cmd <= 4'b0100;
                        end
                        4'b1000: begin //TST
                            exe_cmd <= 4'b0110;
                        end
                        default: begin
                            exe_cmd <= 4'b0000;
                        end
                    endcase
            end
            
            2'b01: begin  // Memory
                exe_cmd <= 4'b0010;
                if (status) begin //LDR
                    {mem_read, WB_Enable} <= 2'b11;
                end else begin //STR
                    mem_write <= 1'b1;      
                end
            end
            
            2'b10: begin  // Branch
                exe_cmd <= 4'b0;
                branch <= 1'b1;
                ignore_hazard <= 1'b1;
            end
            
            default: begin
                exe_cmd <= 4'b0000;
                {mem_read, mem_write, WB_Enable, branch, ignore_hazard} <= 5'b0;
            end
            
        endcase
end

    assign status_update = (mode == 2'b00)? (
                                (opcode == 4'b0000) ? 1'b0 : //NOP
                                (opcode == 4'b1010) ? 1'b1 : //CMP
                                (opcode == 4'b1000) ? 1'b1 : //TST
                                                      status //Others
                            )
                            : status; //LDR, STR, BR

endmodule