`timescale 1ns / 1ps
`include "define.v"

module EXE_MEM_stage(
    input clk,
    input rst,

    input [`DSIZE-1:0] aluout_in,
    input [`DSIZE-1:0] rdata2_in,
    input [`ASIZE-1:0] waddr_in,
    input memread_in,
    input memwrite_in,
    input memtoreg_in,
    input wen_in,
	 input jal_in,
	 input [`ISIZE-1:0] nPC_in,

    output reg [`DSIZE-1:0] aluout_out,
    output reg [`DSIZE-1:0] rdata2_out,
    output reg [`ASIZE-1:0] waddr_out,
    output reg memread_out,
    output reg memwrite_out,
    output reg memtoreg_out,
    output reg wen_out,
	 output reg jal_out,
	 output reg [`ISIZE-1:0] nPC_out
    );

    always @ (posedge clk) begin
    	if(rst) begin
    			aluout_out <= 0;
                rdata2_out <= 0;
    			waddr_out <= 0;
                memread_out <= 0;
                memwrite_out <= 0;
                memtoreg_out <= 0;
                wen_out <= 0;
					 jal_out <= 0;
					 nPC_out <= 0;
    	end else begin
    			aluout_out <= aluout_in;
                rdata2_out <= rdata2_in;
    			waddr_out <= waddr_in;
                memread_out <= memread_in;
                memwrite_out <= memwrite_in;
                memtoreg_out <= memtoreg_in;
                wen_out <= wen_in;
					 jal_out <= jal_in;
					 nPC_out <= nPC_in;
    	end
    end

endmodule
