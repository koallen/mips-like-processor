`include "define.v"// defines DSIZE, ADD, SUB etc


module alu(
   a,   //1st operand
   b,   //2nd operand
   op,   //3-bit operation
   out   //output
   );
 
   input [`DSIZE-1:0] a, b;
   input [2:0] op;
   output reg [`DSIZE-1:0] out;
      
always @(a or b or op )
begin
   case(op)
       `ADD: out = a+b;
       `SUB: out = a - b;
       `AND: out = a & b;
       `XOR: out = a^b;
       `SLL: out = a << b;
       `SRL: out = a >> b;
       `COM: out = a<=b;
       `MUL: out = a*b;
   endcase
end

endmodule
   
       
