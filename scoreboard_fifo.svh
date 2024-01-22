class scoreboard_fifo;
	parameter width=3;
  	parameter depth=4;
	transaction_fifo tr;
	virtual if_fifo ifc;
	mailbox#(transaction_fifo) mb2scb;
  logic [width-1:0] exp_queue[$];
	logic [width-1:0] exp_data;
  	logic exp_full,exp_empty;
	function new(virtual if_fifo ifc,mailbox#(transaction_fifo) mb2scb);
		this.ifc=ifc;
		this.mb2scb=mb2scb;
	endfunction:new
	task run();
	forever begin
		mb2scb.get(tr);
		tr.display("scoreboard");
		if(tr.write_en)begin
          if(exp_queue.size()<depth)begin
			exp_queue.push_back(tr.data_in);
			$display("%0d is stored in the queue",tr.data_in);
			end 
          else begin
            exp_full=1'b1;
            exp_empty=1'b0;
			assert(exp_full==tr.full || exp_empty==tr.empty)
			$display("****************CORRECT:exp_full=%0b,full=%0b  exp_empty=%0b,empty=%0b*************",exp_full,tr.full,exp_empty,tr.empty);
  else $error("****************FAILED:exp_full=%0b,full=%0b ,exp_empty=%0b,empty=%0b*************",exp_full,tr.full,exp_empty,tr.empty);
			$display("the fifo is full");
			end
		end
		if(tr.read_en) begin
          if(exp_queue.size()!=0)begin
				exp_data=exp_queue.pop_front;
				assert(exp_data==tr.data_out)
		$display("****************CORRECT:exp_data=%0x,data_out=%0x ****************",exp_data,tr.data_out);
  else $error("****************FAILED:exp_data=%0x,data_out=%0x ****************",exp_data,tr.data_out);
            end
          else
             begin
            exp_full=1'b0;
            exp_empty=1'b1;
			assert(exp_full==tr.full || exp_empty==tr.empty)
			$display("****************CORRECT:exp_full=%0b,full=%0b  exp_empty=%0b,empty=%0b*************",exp_full,tr.full,exp_empty,tr.empty);
  else $error("****************FAILED:exp_full=%0b,full=%0b ,exp_empty=%0b,empty=%0b*************",exp_full,tr.full,exp_empty,tr.empty);
		
			$display("****************the fifo is empty****************");
             end
		end
      
	end
	endtask:run

endclass