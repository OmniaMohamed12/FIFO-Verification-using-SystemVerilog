class transaction_fifo;
parameter width=3;
rand bit read_en,write_en;
rand bit[width-1:0]data_in;
logic[width-1:0]data_out;
logic full,empty;
constraint c_en{
	read_en!=write_en;
  read_en dist{0:/50,1:/50};
  write_en dist{0:/40,1:/60};
}
function void display(input string class_name);
	$display("%0t %0s :read_en=%0b,write_en=%0b,data_in=%0x,data_out=%0x ,full=%0b,empty=%0b",$time,class_name,
	           read_en,write_en,data_in,data_out,full,empty);
endfunction:display

endclass:transaction_fifo

