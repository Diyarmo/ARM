module Hazard_Detection_Unit(
    input[3:0] src1, src2, EXE_Dest, MEM_Dest,
    input EXE_WB_EN, MEM_WB_EN, has_two_src, Ignore_Hazard, forwarding_en, MEM_R_EN_EXE,
    output hazard_detected
);
    assign hazard_EXE = ((src1 == EXE_Dest) && (EXE_WB_EN == 1'b1)) ? 1'b1
        : ((src2 == EXE_Dest) && (EXE_WB_EN == 1'b1) && (has_two_src == 1'b1)) ? 1'b1
        : 1'b0;

    assign hazard_MEM = ((src1 == MEM_Dest) && (MEM_WB_EN == 1'b1)) ? 1'b1
        : ((src2 == MEM_Dest) && (MEM_WB_EN == 1'b1) && (has_two_src == 1'b1)) ? 1'b1
        : 1'b0;

    assign hazard_detected = (Ignore_Hazard == 1'b1) ? 1'b0
        : (forwarding_en == 1'b1) ? MEM_R_EN_EXE & hazard_EXE
        : hazard_EXE | hazard_MEM;

endmodule