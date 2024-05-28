class coverage_fifo;

	transaction_fifo tr;
	mailbox#(transaction_fifo) mb2cov;
    
covergroup cg;
  write_enable: coverpoint tr.write_en{
    bins write_en_h={1};
    bins write_en_l={0};
  }
  read_enable: coverpoint tr.read_en{
    bins read_en_h={1};
    bins read_en_l={0};
  }
  full_flag: coverpoint tr.full{
    bins full_h={1};
    bins full_l={0};
  }
  empty_flag: coverpoint tr.empty{
    bins empty_h={1};
    bins empty_l={0};
  }
  datain: coverpoint tr.data_in;
  dataout: coverpoint tr.data_out;
endgroup:cg
  
  function new(mailbox#(transaction_fifo) mb2cov);
    this.mb2cov=mb2cov;
    cg=new();
  endfunction:new
  task run();
    forever begin
      mb2cov.get(tr);
      tr.display("coverage_fifo");
      cg.sample();
      $display("                               ********************************                ");
    end
  endtask:run
endclass:coverage_fifo
