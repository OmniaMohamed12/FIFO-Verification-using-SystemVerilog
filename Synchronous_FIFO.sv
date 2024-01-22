module Synchronous_FIFO#(parameter width=3,parameter depth=4)
(input clk,rst_n,input read_en,write_en,input[width-1:0] data_in,
 output reg[width-1:0]data_out,output  full,empty);
  logic[$clog2(depth):0]write_ptr,read_ptr;
  logic[width-1:0] fifo [depth-1:0];
  parameter bits=$clog2(depth);
always@(posedge clk)begin
	if(!rst_n)begin
		write_ptr<=0;
		read_ptr<=0;
		data_out<=0;
	end
  else begin
    if(write_en && !full )begin
      fifo[write_ptr[bits-1:0]]<=data_in;
		write_ptr<=write_ptr+1;
	end
    if(read_en && !empty )begin
      data_out<=fifo[read_ptr[bits-1:0]];
		read_ptr<=read_ptr+1;
	end
    
  end
end
  // empty flag is asserted high when write pointer and read pointer have the same value
  assign empty= (read_ptr==write_ptr);
   // full flag is asserted high when write pointer and read pointer have the same value but the msb of write_ptr and read_ptr differs.
  assign full={~write_ptr[bits],write_ptr[bits-1:0]}=={read_ptr[bits:0]};
endmodule
