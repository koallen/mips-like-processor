`timescale 1ns / 1ps
`include "define.v"
// MUX for data forwarding to alu port A
module forwardA(
    input [`DSIZE-1:0] rdata1, EXE_MEM_forward, MEM_WB_forward,
    input [1:0] select,
    output reg [`DSIZE-1:0] alu_A
    );

always @ *
    case(select)
        // 0 to select data coming from register file
        0: alu_A = rdata1;
        // 1 to select data forwarded from EXE_MEM pipeline register
        1: alu_A = EXE_MEM_forward;
        // 2 to select data forwarded from MEM_WB pipeline register
        2: alu_A = MEM_WB_forward;
        // default to rdata1
        default: alu_A = rdata1;
    endcase

endmodule
