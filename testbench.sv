`timescale 1ns/1ps
parameter width=3;
parameter depth=4;
`include "if_fifo.sv"
`include "transaction_fifo.svh"
`include "generator_fifo.svh"
`include "driver_fifo.svh"
`include "monitor_fifo.svh"
`include "scoreboard_fifo.svh"
`include "coverage_fifo.svh"
`include "environment_fifo.svh"
`include "Synchronous_FIFO.sv"
module tb_fifo;
  if_fifo ifc();
  environment_fifo env;
  Synchronous_FIFO#( width,depth) dut(ifc.clk,ifc.rst_n,ifc.read_en,ifc.write_en,ifc.data_in,ifc.data_out,ifc.full,ifc.empty);
  initial begin
	ifc.clk<=0;
	forever #5 ifc.clk<=~ifc.clk;
   end
  initial begin
    env=new(ifc);
	env.gen.num_tr=50;
	env.run();
	end
  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
  end
  `ifdef FSDB
  initial begin
    $fsdbDumpfile("textbench.fsdb");
    $fsdbDumpvars;
  end
  `endif
endmodule
