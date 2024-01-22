class monitor_fifo;
	transaction_fifo tr;
	virtual if_fifo ifc;
	mailbox#(transaction_fifo) mb2scb;
	mailbox#(transaction_fifo) mb2cov;
	event next_tr;
	function new(virtual if_fifo ifc,mailbox#(transaction_fifo) mb2scb,mailbox#(transaction_fifo) mb2cov);
		this.ifc=ifc;
		this.mb2cov=mb2cov;
		this.mb2scb=mb2scb;
		tr=new();
	endfunction:new
	task run();
	    forever begin
          @(posedge ifc.clk);
		@(negedge ifc.clk);
         
		tr.read_en = ifc.read_en;
		tr.write_en = ifc.write_en;
		tr.data_in = ifc.data_in;
		tr.data_out = ifc.data_out;
		tr.full = ifc.full;
		tr.empty = ifc.empty;
		mb2scb.put(tr);
		mb2cov.put(tr);
		tr.display("Monitor");
		->next_tr;
		end
	endtask:run	


endclass:monitor_fifo