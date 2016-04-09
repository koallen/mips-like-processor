`timescale 1ns / 1ps
`include "define.v"

module part1(clk, rst, fileid, PCOUT, INST, rdata1, rdata2, rdata1_out_ID_EXE, rdata2_out_ID_EXE, imm_out_ID_EXE,rdata2_imm_out_ID_EXE, aluop_out_ID_EXE, alusrc, waddr_out_ID_EXE,aluout,raddr1, raddr2, aluout_out_MEM_WB,waddr_out_MEM_WB,aluout_out_EXE_MEM, rdata2_out_EXE_MEM,waddr_out_EXE_MEM,dmrdata);

input clk;
input	rst;
input fileid;

output [`ISIZE-1:0] PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata1_out_ID_EXE;
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0] rdata2_out_ID_EXE;
output [`DSIZE-1:0] imm_out_ID_EXE;
output [`DSIZE-1:0] rdata2_imm_out_ID_EXE;
output [`DSIZE-1:0] INST;
output alusrc;
output [2:0] aluop_out_ID_EXE;
output [`ASIZE-1:0] waddr_out_ID_EXE;
output [`DSIZE-1:0] aluout;
output [`ASIZE-1:0] raddr1, raddr2;

//
// wire declarations
//
output [`DSIZE-1:0] aluout_out_MEM_WB;
output [`ASIZE-1:0] waddr_out_MEM_WB;
assign raddr1 = INST[7:4];
output [`DSIZE-1:0] aluout_out_EXE_MEM, rdata2_out_EXE_MEM;
output [`ASIZE-1:0] waddr_out_EXE_MEM;
output [`DSIZE-1:0] dmrdata;
wire [2:0] aluop;
wire [`DSIZE-1:0] imm = {{12{INST[3]}}, INST[3:0]};
wire [`DSIZE-1:0] rdata1_out_ID_EXE, rdata2_out_ID_EXE, rdata2_imm_out_ID_EXE, imm_out_ID_EXE;
wire [`ASIZE-1:0] waddr_out_ID_EXE;
wire [`ISIZE-1:0] nPC_out_ID_EXE;
wire [2:0] aluop_out_ID_EXE;


//
// rt/imm rd mux
//
wire [`ASIZE-1:0] raddr2 = regdst ? INST[11:8] : INST[3:0];

//
// dm regfile mux
//
wire [`DSIZE-1:0] wdata = memtoreg_out_MEM_WB ? dmrdata : aluout_out_MEM_WB; // compensate for the memory delay

//
// rdata2 imm mux
//
wire [`DSIZE-1:0] rdata2_imm = alusrc ? imm : rdata2;// mux for selecting immedaite or the rdata2 value

//
// program counter
//
wire [`ISIZE-1:0] nPC = PCOUT + 16'b1; // increments PC to PC +1
wire [`ISIZE-1:0] res = nPC_out_ID_EXE + imm_out_ID_EXE;
wire PCsrc = branch_out_ID_EXE & zero;
wire [`ISIZE-1:0] PCIN = PCsrc ? res : nPC;

PC1 pc (
    .clk(clk),
	 .rst(rst),
	 .nextPC(PCIN),
	 .currPC(PCOUT)
	 );

//
// instruction memory
//
memory im (
	 .clk(clk),
	 .rst(rst),
	 .wen(1'b0),
	 .addr(PCOUT),
	 .data_in(16'b0),
	 .fileid(4'b0),
	 .data_out(INST)
	 );

//
// data memory
//

memory dm (
    .clk(clk),
    .rst(rst),
    .wen(memwrite_out_EXE_MEM), // from control unit, implicit wire
    .addr(aluout_out_EXE_MEM), // from alu output
    .data_in(rdata2_out_EXE_MEM), // from rdata2
    .fileid(4'b1000), // 8 for data memory input
    .data_out(dmrdata) // out to aluout dmout mux
    );



//
// control unit
//

control C0 (
    .inst(INST[15:12]),
	 .wen(wen), // implicit wire
	 .alusrc(alusrc), // implicit wire
	 .aluop(aluop),
	 .regdst(regdst), // implicit wire
	 .memwrite(memwrite), // implicit wire
	 .memtoreg(memtoreg), // implicit wire
	 .branch(branch) // implicit wire
	 );



//
// register file
//
regfile RF0 (
	 .clk(clk),
	 .rst(rst),
	 .wen(wen_out_MEM_WB),
	 .raddr1(INST[7:4]),
	 .raddr2(raddr2),
	 .waddr(waddr_out_MEM_WB),
	 .wdata(wdata),
	 .rdata1(rdata1),
	 .rdata2(rdata2)
	 );



//
// ID EXE pipeline
//


ID_EXE_stage PIPE1 (
    .clk(clk),
    .rst(rst),
    .rdata1_in(rdata1),
    .rdata2_in(rdata2),
    .rdata2_imm_in(rdata2_imm),
    .imm_in(imm),
    .waddr_in(INST[11:8]),
    .nPC_in(nPC),
    .aluop_in(aluop),
    .wen_in(wen), // implicit wire
    .memwrite_in(memwrite), // implicit wire
    .memtoreg_in(memtoreg), // implicit wire
    .branch_in(branch), // implicit wire
    .rdata1_out(rdata1_out_ID_EXE),
    .rdata2_out(rdata2_out_ID_EXE),
    .rdata2_imm_out(rdata2_imm_out_ID_EXE),
    .imm_out(imm_out_ID_EXE),
    .waddr_out(waddr_out_ID_EXE),
    .nPC_out(nPC_out_ID_EXE),
    .aluop_out(aluop_out_ID_EXE),
    .wen_out(wen_out_ID_EXE), // implicit wire
    .memwrite_out(memwrite_out_ID_EXE), // implicit wire
    .memtoreg_out(memtoreg_out_ID_EXE), // implicit wire
    .branch_out(branch_out_ID_EXE) // implicit wire
    );

//
// ALU
//
alu ALU0 (
    .a(rdata1_out_ID_EXE),
	 .b(rdata2_imm_out_ID_EXE),
	 .op(aluop_out_ID_EXE),
	 .out(aluout),
	 .zero(zero) // implicit wire
	 );//ALU takes its input from pipeline register and the output of mux.

//
// EXE MEM pipeline
//
EXE_MEM_stage PIPE2 (
    .clk(clk),
    .rst(rst),
    .aluout_in(aluout),
    .rdata2_in(rdata2_out_ID_EXE),
    .waddr_in(waddr_out_ID_EXE),
    .memwrite_in(memwrite_out_ID_EXE),
    .memtoreg_in(memtoreg_out_ID_EXE),
    .wen_in(wen_out_ID_EXE),
    .aluout_out(aluout_out_EXE_MEM),
    .rdata2_out(rdata2_out_EXE_MEM),
    .waddr_out(waddr_out_EXE_MEM),
    .memwrite_out(memwrite_out_EXE_MEM), // implicit wire
    .memtoreg_out(memtoreg_out_EXE_MEM), // implicit wire
    .wen_out(wen_out_EXE_MEM) // implicit wire
    );

//
// MEM WB pipeline
//
MEM_WB_stage PIPE3 (
    .clk(clk),
    .rst(rst),
    .waddr_in(waddr_out_EXE_MEM),
    .aluout_in(aluout_out_EXE_MEM),
    .wen_in(wen_out_EXE_MEM), // implicit wire
    .memtoreg_in(memtoreg_out_EXE_MEM), // implicit wire
    .waddr_out(waddr_out_MEM_WB),
    .aluout_out(aluout_out_MEM_WB),
    .wen_out(wen_out_MEM_WB), // implicit wire
    .memtoreg_out(memtoreg_out_MEM_WB) // implicit wire
    );

endmodule
