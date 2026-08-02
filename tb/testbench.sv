`include "fifo_transaction.sv"
`include "generator.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_scoreboard.sv"
`include "fifo_environment.sv"
//`include "test_random.sv"
//`include "write_single.sv"
//`include "write_only.sv"
//`include "read_only.sv"
//`include "read_empty.sv";
//`include "alternate_write_read.sv"
//`include "write_full.sv";
//`include "test_random.sv";
`include "pointer_wrap_around.sv"
//`include "fifo_reset.sv";
//`include "write_faster_than_read.sv"
interface fifo_if #(parameter DATA_W = 8);

  logic wclk, rclk;
  logic wrst_n, rrst_n;

  logic winc;
  logic [DATA_W-1:0] wdata;
  logic wfull;

  logic rinc;
  logic [DATA_W-1:0] rdata;
  logic rempty;
  
  clocking rc_cb @(posedge rclk);

    default input #1step output #0;

    input rinc;

    input rempty;

    input rdata;

  endclocking
  
  //-----------------------------------------
// TB PROTOCOL ASSERTIONS
//-----------------------------------------

// Write enable should be a single cycle pulse
property p_winc_single_cycle;
  @(posedge wclk)
  winc |=> !winc;
endproperty

assert property(p_winc_single_cycle)
else $error("ASSERT FAIL: winc held more than one cycle");


// Read enable should be a single cycle pulse
property p_rinc_single_cycle;
  @(posedge rclk)
  rinc |=> !rinc;
endproperty

assert property(p_rinc_single_cycle)
else $error("ASSERT FAIL: rinc held more than one cycle");


// Write data must remain stable during write
/*property p_wdata_stable;
  @(posedge wclk)
  winc |-> $stable(wdata);
endproperty

assert property(p_wdata_stable)
else $error("ASSERT FAIL: wdata changed during write");*/


// Read data should never be unknown
property p_rdata_valid;
  @(posedge rclk)
  rinc |-> !$isunknown(rdata);
endproperty

assert property(p_rdata_valid)
else $error("ASSERT FAIL: rdata contains X/Z");


  
endinterface
module tb_top;

  fifo_if intf();

  async_fifo_top dut (
    .wclk(intf.wclk),
    .wrst_n(intf.wrst_n),
    .winc(intf.winc),
    .wdata(intf.wdata),
    .wfull(intf.wfull),
    .rclk(intf.rclk),
    .rrst_n(intf.rrst_n),
    .rinc(intf.rinc),
    .rdata(intf.rdata),
    .rempty(intf.rempty)
  );
  
  //test_random test(intf);
  //test_single_write(intf);
  //test_write_only_random(intf);
  //test_read_only(intf);
  //test_alternate_write_read(intf);
  //test_read_until_empty(intf);
   //test_write_when_full(intf);
  //test_random_read_write(intf);
  test_pointer_wraparound(intf);
  //test_fifo_reset(intf);
  //test_write_faster_than_read(intf);
  // WRITE CLOCK
  initial begin
    intf.wclk = 0;
    forever #5 intf.wclk = ~intf.wclk;
  end

  // READ CLOCK
  initial begin
    intf.rclk = 0;
    forever #15 intf.rclk = ~intf.rclk;
  end

  // RESET
  initial begin
    intf.wrst_n = 0;
    intf.rrst_n = 0;
    #20 intf.wrst_n = 1;
    #7  intf.rrst_n = 1;
  end
  
  initial begin $dumpvars; $dumpfile("dump.vcd"); end

endmodule


