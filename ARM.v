module ARM(input clk, rst);

    wire [31:0] 
    PC_IF, Instruction,
    PC_ID,  
    PC_EXE, 
    PC_MEM, 
    PC_WB;

    IF_Module if_module(
        .clk(clk),
        .rst(rst),
        .PC(PC_IF),
        .Instruction(Instruction)
    );
    
    ID_Module id_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_IF),
        .PC(PC_ID)
    );

    
    EXE_Module exe_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_ID),
        .PC(PC_EXE)
    );
    
    MEM_Module mem_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_EXE),
        .PC(PC_MEM)
    );

    WB_Module wb_module(
        .clk(clk),
        .rst(rst),
        .PC_in(PC_MEM),
        .PC(PC_WB)
    );

endmodule