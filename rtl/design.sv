`include "synchroniser.v"
`include "wptr_full.v"
`include "rptr_empty.v"
`include "top_asynch_fifo.sv"

module async_fifo_top #(
  parameter data_w = 8,
  parameter depth = 8,
  parameter addr_w =3,
  parameter ptr_w = addr_w+1
)(
  input wclk,
  input wrst_n,
  input winc,
  input [data_w-1:0] wdata,
  output wfull,
  
  input rclk,
  input rrst_n,
  input rinc,
  output [data_w-1:0] rdata,
  output rempty
);
  
  wire [addr_w-1:0] waddr,raddr;
  wire [ptr_w-1:0] wptr_gray,rptr_gray;
  wire [ptr_w-1:0] wptr_gray_sync,rptr_gray_sync;
  
  fifo_mem # (data_w,depth,addr_w) mem (
    wclk,(winc && !wfull),waddr,wdata,raddr,rdata
  );
  
  wptr_full #(addr_w,ptr_w) wptr(
    wclk,wrst_n,winc,rptr_gray_sync,
    waddr,wptr_gray,wfull
  );
  
  rptr_empty #(addr_w,ptr_w) rptr(
    rclk,rrst_n,rinc,wptr_gray_sync,raddr,rptr_gray,rempty
  );
  
  sync #(ptr_w) sync_r2w (wclk,wrst_n,rptr_gray,rptr_gray_sync);
  sync #(ptr_w) sync_w2r (rclk,rrst_n,wptr_gray,wptr_gray_sync);
  
  //----------------------------------
// ASSERTIONS
//----------------------------------

// Write should not happen when FIFO is full
property p_no_write_when_full;
  @(posedge wclk)
  winc |-> !wfull;
endproperty

assert property(p_no_write_when_full)
else $error("ASSERT FAIL: Write attempted while FIFO FULL at time %0t", $time);


// Read should not happen when FIFO empty
property p_no_read_when_empty;
  @(posedge rclk)
  rinc |-> !rempty;
endproperty

assert property(p_no_read_when_empty)
else $error("ASSERT FAIL: Read attempted while FIFO EMPTY at time %0t", $time);


// Write data must be valid
property p_write_data_valid;
  @(posedge wclk)
  winc |-> !$isunknown(wdata);
endproperty

assert property(p_write_data_valid)
else $error("ASSERT FAIL: Write data is X/Z");
  
endmodule
