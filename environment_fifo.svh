class environment_fifo;
  
  virtual if_fifo ifc;
  event next;
  generator_fifo gen;
  driver_fifo    drv;
  monitor_fifo   mon;
  scoreboard_fifo scb;
  coverage_fifo cov;
  mailbox #(transaction_fifo) mb2drv;
  mailbox #(transaction_fifo) mb2cov;
  mailbox #(transaction_fifo) mb2scb;
  
  function new(virtual if_fifo ifc);
    this.ifc=ifc;
    mb2drv=new();
    gen=new(ifc,mb2drv);
    drv=new(ifc,mb2drv);
    mb2scb=new();
    mb2cov=new();
    mon=new(ifc,mb2scb,mb2cov);
    scb=new(ifc,mb2scb);
    cov=new(mb2cov);
    gen.next_tr=next;
    drv.next_tr=next;
    mon.next_tr=next;
  endfunction:new
  task pre_test;
  	drv.reset();
  endtask
  task test;
    fork 
       gen.run();
       drv.run();
       mon.run();
       scb.run();
       cov.run();
    join_any
  endtask
  task post_test;
    wait(gen.finish_tr==1'b1);
    $stop;
  endtask
  task run;
	pre_test();
    test();
    post_test();
  endtask
  
endclass
