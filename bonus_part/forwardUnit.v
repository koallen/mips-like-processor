`timescale 1ns / 1ps
`include "define.v"
// controlling forwarding signals
module forwardUnit(
    input [3:0] ID_EXE_rs, ID_EXE_rt, EXE_MEM_rd, MEM_WB_rd,
    input EXE_MEM_wen, MEM_WB_wen, MEM_WB_memtoreg,
    output reg [1:0] forwardA, forwardB,
    output reg forwardC
    );

always @ * begin
    // forwarding to ALU port A
    forwardA = 2'd0;
    if(EXE_MEM_wen == 1 && EXE_MEM_rd == ID_EXE_rs)
        forwardA = 2'd1;
    if(MEM_WB_wen == 1 && MEM_WB_rd == ID_EXE_rs && (EXE_MEM_rd != ID_EXE_rs || EXE_MEM_wen == 0))
        forwardA = 2'd2;
    // forwarding to ALU port B
    forwardB = 2'd0;
    if(EXE_MEM_wen == 1 && EXE_MEM_rd == ID_EXE_rt)
        forwardB = 2'd1;
    if(MEM_WB_wen == 1 && MEM_WB_rd == ID_EXE_rt && (EXE_MEM_rd != ID_EXE_rt || EXE_MEM_wen == 0))
        forwardB = 2'd2;
    // forwarding to data memory
    forwardC = 1'd0;
    if(MEM_WB_memtoreg == 1 && EXE_MEM_wen == 1)
        forwardC = 1'd1;
end

endmodule
