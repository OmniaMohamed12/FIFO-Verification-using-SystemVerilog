/*covergroup c @(posedge clk);
   
  option.per_instance = 1;
    
   coverpoint empty {
     bins empty_l = {0};
     bins empty_h = {1};
   }
   
      coverpoint full {
     bins full_l = {0};
     bins full_h = {1};
   }
  
     coverpoint rst {
     bins rst_l = {0};
     bins rst_h = {1};
   }
  
   
  
    coverpoint din
   {
     bins lower = {[0:84]};
     bins mid = {[85:169]};
     bins high = {[170:255]};
   }
   
     coverpoint dout
   {
     bins lower = {[0:84]};
     bins mid = {[85:169]};
     bins high = {[170:255]};
   }
  
  cross_Wr_din: cross wr,din 
   {
     ignore_bins unused_wr = binsof(wr) intersect {0};
   }
  
   cross_rd_dout: cross rd,dout
   {
     ignore_bins unused_rd = binsof(rd) intersect {0};
   }
  
 endgroup
 */
class coverage_fifo;

	transaction_fifo tr;
	mailbox#(transaction_fifo) mb2cov;
    
covergroup cg;
  write_enable: coverpoint tr.write_en{
    bins write_en_h={1};
    bins write_en_l={0};
  }
  read_enable: coverpoint tr.read_en{
    bins readen_h={1};
    bins readen_l={0};
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
  