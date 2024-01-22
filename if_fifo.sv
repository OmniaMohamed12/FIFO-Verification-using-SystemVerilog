interface if_fifo;
parameter width=3;
logic clk,rst_n;
logic read_en,write_en;
logic[width-1:0]data_in;
logic[width-1:0]data_out;
logic full,empty;
endinterface
