class driver_fifo;
	virtual if_fifo vif;
	transaction_fifo tr;
	mailbox#(transaction_fifo) mb;
	event next_tr;
	function new(virtual if_fifo vif,mailbox#(transaction_fifo) mb);
		this.vif=vif;
		this.mb=mb;
	endfunction:new 
	task reset();
      $display("%0t  reset phase",$time);
		vif.read_en <=1'b0;
		vif.write_en <=1'b0;
		//vif.data_in <=0;
		vif.rst_n <=1'b0;
		@(posedge vif.clk);
		vif.rst_n <=1'b1;
        @(posedge vif.clk);
      $display("%0t reset phase is done",$time);
	endtask:reset
	task run();
		forever begin
			mb.get(tr);
			tr.display("Driver");
			vif.read_en<=tr.read_en;
			vif.write_en<=tr.write_en;
			vif.data_in<=tr.data_in;
			->next_tr;
			@(posedge vif.clk);
		end
	endtask:run
endclass:driver_fifo