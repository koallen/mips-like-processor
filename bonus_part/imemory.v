`include "define.v"

module imemory( clk, rst, wen, stall, addr, data_in, fileid, data_out);//This memory can be used as instuction as well as data memory

  input clk;
  input rst;
  input wen;
  input stall;
  input [`ISIZE-1:0] addr;      // address input is 16 bit wide 
  input [`DSIZE-1:0] data_in;          // data input
  input [3:0] fileid;//file id selects which amoung the files given below (0-7 for different inputs for imem) and (8-16 for differnt D-mem inputs) for this lab we are using fileid=0
  output [`DSIZE-1:0] data_out;    // data output

  reg [`DSIZE-1:0] memory [0:65535]; // size of the memory, 64K words
  reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */

integer fin, i, c, r;
reg [`ISIZE-1:0] t_addr;
reg [`DSIZE-1:0] t_data;

reg [`ISIZE-1:0] addr_r;

assign data_out = memory[addr_r];//Reading from the memory. Do note that there is a clock cycle delay for reading from the memory just to indicate that memories are slower.

  always @(posedge clk)
    begin
      if(rst)
        begin
	   addr_r <=0;
  	   case(fileid)
	        0: fin = $fopen("imem_test0.txt","r");//here we are using this input.txt file. but you can make different input.txt file and can check with the same program by changing the file id.
        	1: fin = $fopen("imem_test1.txt","r");
	        2: fin = $fopen("imem_test2.txt","r");
        	3: fin = $fopen("imem_test3.txt","r");
	        4: fin = $fopen("imem_test4.txt","r");
        	5: fin = $fopen("imem_test5.txt","r");
	        6: fin = $fopen("imem_test6.txt","r");
        	7: fin = $fopen("imem_test7.txt","r");
	        8: fin = $fopen("dmem_test0.txt","r");
        	9: fin = $fopen("dmem_test1.txt","r");
	        10: fin = $fopen("dmem_test2.txt","r");
        	11: fin = $fopen("dmem_test3.txt","r");
	        12: fin = $fopen("dmem_test4.txt","r");
        	13: fin = $fopen("dmem_test5.txt","r");
	        14: fin = $fopen("dmem_test6.txt","r");
	        15: fin = $fopen("dmem_test7.txt","r");
	  endcase
	  $write("Opening Fileid %d\n", fileid);

	  while(!$feof(fin)) begin
              c = $fgetc(fin);
              // check for comment
              if (c == "/" | c == "#" | c == "%")
                  r = $fgets(line, fin);
              else
                 begin
                    // Push the character back to the file then read the next time
                    r = $ungetc(c, fin);
                    r = $fscanf(fin, "%h %h",t_addr, t_data);
                    memory[t_addr]=t_data;
                 end
            end
            $fclose(fin);
	end
      else
        begin
        if(!stall)
	  addr_r <= addr;
          if (wen)// active-high write enable
            begin            
              memory[addr] <= data_in;
            end
	end
    end

endmodule
