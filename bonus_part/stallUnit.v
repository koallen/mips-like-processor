`timescale 1ns / 1ps
`include "define.v"
// Stall control unit
module stallUnit(
    input ID_EXE_memread, clk,
    input [3:0] ID_EXE_rd, IF_ID_rt, IF_ID_rs,
    output reg stallPC, nop
    );

always @ * begin
    stallPC = 1'd0;
    nop = 1'd0;
    if(ID_EXE_memread == 1 && (ID_EXE_rd == IF_ID_rt || ID_EXE_rd == IF_ID_rs)) begin
        stallPC = 1'd1;
        nop = 1'd1;
    end
end

endmodule
