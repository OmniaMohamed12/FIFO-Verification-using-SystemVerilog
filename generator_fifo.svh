class generator_fifo;
	transaction_fifo tr;
	event next_tr;
	bit finish_tr=1'b0;
	mailbox#(transaction_fifo) mb;
    virtual if_fifo vif;
	int num_tr;
  function new(virtual if_fifo vif,mailbox#(transaction_fifo) mb);
		this.mb=mb;
    	this.vif=vif;
		tr=new();
	endfunction:new 
	task run();
		repeat(num_tr)begin
			assert(tr.randomize()) else $error("Generator:randomization failded");
			mb.put(tr);
			tr.display("Generator");
            @(posedge vif.clk);
			@(next_tr);
		end
		finish_tr=1'b1;
	endtask:run
endclass:generator_fifo