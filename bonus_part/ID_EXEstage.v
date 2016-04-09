`include "define.v"

module ID_EXE_stage (
	input clk,
	input rst,

	input [`DSIZE-1:0] rdata1_in,
	input [`DSIZE-1:0] rdata2_in,
	input [`DSIZE-1:0] rdata2_imm_in,
	input [`ASIZE-1:0] waddr_in,
	input [`ISIZE-1:0] nPC_in,
	input [2:0] aluop_in,
	input wen_in,
	input memwrite_in,
	input memread_in,
	input memtoreg_in,
	input jal_in,
    // for data forwading
    input [3:0] reg_rs_in, reg_rt_in,

	output reg [`DSIZE-1:0] rdata1_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [`DSIZE-1:0] rdata2_imm_out,
	output reg [`ASIZE-1:0] waddr_out,
	output reg [`ISIZE-1:0] nPC_out,
	output reg [2:0] aluop_out,
	output reg wen_out,
	output reg memwrite_out,
	output reg memread_out,
	output reg memtoreg_out,
	output reg jal_out,
    // for data forwarding
    output reg [3:0] reg_rs_out, reg_rt_out
);

	always @ (posedge clk) begin
		if(rst) begin
			rdata1_out <= 0;
			rdata2_out <= 0;
			rdata2_imm_out <= 0;
			waddr_out <= 0;
			nPC_out <= 0;
			aluop_out <= 0;
			wen_out <= 0;
			memwrite_out <= 0;
			memread_out <= 0;
			memtoreg_out <= 0;
			jal_out <= 0;
            reg_rs_out <= 0;
            reg_rt_out <= 0;
		end else begin
			rdata1_out <= rdata1_in;
			rdata2_out <= rdata2_in;
			rdata2_imm_out <= rdata2_imm_in;
			waddr_out <= waddr_in;
			nPC_out <= nPC_in;
			aluop_out <= aluop_in;
			wen_out <= wen_in;
			memwrite_out <= memwrite_in;
			memread_out <= memread_in;
			memtoreg_out <= memtoreg_in;
			jal_out <= jal_in;
            reg_rs_out <= reg_rs_in;
            reg_rt_out <= reg_rt_in;
		end
	end

endmodule