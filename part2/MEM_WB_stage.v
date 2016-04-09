`timescale 1ns / 1ps
`include "define.v"

module MEM_WB_stage(
    input clk,
    input rst,

    input [`ASIZE-1:0] waddr_in,
    input [`DSIZE-1:0] aluout_in,
    input wen_in,
    input memtoreg_in,
	 input jal_in,
	 input [`ISIZE-1:0] nPC_in,

    output reg [`ASIZE-1:0] waddr_out,
    output reg [`DSIZE-1:0] aluout_out,
    output reg wen_out,
    output reg memtoreg_out,
	 output reg jal_out,
	 output reg [`ISIZE-1:0] nPC_out
    );

    always @ (posedge clk) begin
    	if(rst) begin
            waddr_out <= 0;
            aluout_out <= 0;
            wen_out <= 0;
            memtoreg_out <= 0;
				jal_out <= 0;
				nPC_out <= 0;
    	end else begin
            waddr_out <= waddr_in;
            aluout_out <= aluout_in;
            wen_out <= wen_in;
            memtoreg_out <= memtoreg_in;
				jal_out <= jal_in;
				nPC_out <= nPC_in;
    	end
    end

endmodule
