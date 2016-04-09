`timescale 1ns / 1ps
`include "define.v"
// MUX for data forwarding to alu port B
module forwardB(
    input [`DSIZE-1:0] rdata2_imm, EXE_MEM_forward, MEM_WB_forward,
    input [1:0] select,
    output reg [`DSIZE-1:0] alu_B
    );

always @ *
    case(select)
        // 0 to select data coming from register file
        0: alu_B = rdata2_imm;
        // 1 to select data forwarded from EXE_MEM pipeline register
        1: alu_B = EXE_MEM_forward;
        // 2 to select data forwarded from MEM_WB pipeline register
        2: alu_B = MEM_WB_forward;
        // default to rdata2_imm
        default: alu_B = rdata2_imm;
    endcase
    
endmodule
