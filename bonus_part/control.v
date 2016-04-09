`include "define.v"

module control(
    input [3:0] inst,

    output reg wen,
    output reg alusrc,
    output reg [2:0] aluop,
    output reg regdst,
	 output reg memwrite,
	 output reg memtoreg,
	 output reg branch,
	 output reg jump,
	 output reg jr,
	 output reg jal,
     output reg memread // added to detect stall only
    );

    always @ * begin
        case(inst)
	         `ADD: begin
		          wen = 1;
		          alusrc = 0;
		          aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
	         end
             `ADDI: begin
		          wen = 1;
		          alusrc = 1;
		          aluop = 3'b000;
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
	         end
            `SUB: begin
                wen = 1;
					 alusrc = 0;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
            `AND: begin
                wen = 1;
					 alusrc = 0;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
            `XOR: begin
                wen = 1;
					 alusrc = 0;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
            `SLL: begin
                wen = 1;
					 alusrc = 1;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
            `SRL: begin
                wen = 1;
					 alusrc = 1;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
            `COM: begin
                wen = 1;
					 alusrc = 0;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
            `MUL: begin
                wen = 1;
					 alusrc = 0;
                aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
            end
				`BEQ: begin
				    wen = 0;
					 alusrc = 0;
					 aluop = inst[2:0];
					 regdst = 1;
					 branch = 1;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
				end
				`LW: begin
					 wen = 1;
					 alusrc = 1;
					 aluop = 3'b000;
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 1;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 1;
				end
				`SW: begin
					 wen = 0;
					 alusrc = 1;
					 aluop = 3'b000;
					 regdst = 1;
					 branch = 0;
					 memwrite = 1;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
				end
				`J: begin
					 wen = 0;
					 alusrc = 0;
					 aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 1;
					 jr = 0;
					 jal = 0;
                     memread = 0;
				end
				`JR: begin
					 wen = 0;
					 alusrc = 0;
					 aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 1;
					 jal = 0;
                     memread = 0;
				end
				`JAL: begin
					 wen = 0;
					 alusrc = 0;
					 aluop = inst[2:0];
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 1;
                     memread = 0;
				end
				default: begin
					 wen = 0;
					 alusrc = 0;
					 aluop = 3'b000;
					 regdst = 0;
					 branch = 0;
					 memwrite = 0;
					 memtoreg = 0;
					 jump = 0;
					 jr = 0;
					 jal = 0;
                     memread = 0;
				end
        endcase
    end

endmodule
