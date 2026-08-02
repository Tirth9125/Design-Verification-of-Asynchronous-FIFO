/*module rptr_empty #(parameter addr_w=3,parameter ptr_w = addr_w+1)(
  input rclk,
  input rrst_n,
  input rinc,
  input [ptr_w-1:0] wptr_gray_sync,
  
  output [addr_w-1:0] raddr,
  output reg[ptr_w-1:0] rptr_gray,
  output rempty
);
  
  reg [ptr_w-1:0] rbin;
  wire [ptr_w-1:0] rbin_next,rgray_next;
  
  assign rbin_next = rbin + (rinc && !rempty);
  assign rgray_next = (rbin_next >> 1) ^ rbin_next;
  
  always @ (posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
      rbin <= 0;
      rptr_gray <= 0;
    end else begin
      rbin <= rbin_next;
      rptr_gray <= rgray_next;
    end
    
  end
  
  assign raddr = rbin[addr_w-1:0];
  assign rempty = (rgray_next == wptr_gray_sync);
  
endmodule*/

module rptr_empty #(
  parameter addr_w = 3,
  parameter ptr_w  = addr_w + 1
)(
  input rclk,
  input rrst_n,
  input rinc,
  input [ptr_w-1:0] wptr_gray_sync,

  output [addr_w-1:0] raddr,
  output reg [ptr_w-1:0] rptr_gray,
  output reg rempty
);

  reg [ptr_w-1:0] rbin;

  wire [ptr_w-1:0] rbin_next;
  wire [ptr_w-1:0] rgray_next;

  //---------------------------------
  // pointer increment
  //---------------------------------
  assign rbin_next = rbin + (rinc & ~rempty);

  //---------------------------------
  // gray conversion
  //---------------------------------
  assign rgray_next = (rbin_next >> 1) ^ rbin_next;

  //---------------------------------
  // pointer register
  //---------------------------------
  always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
      rbin      <= 0;
      rptr_gray <= 0;
    end
    else begin
      rbin      <= rbin_next;
      rptr_gray <= rgray_next;
    end
  end

  //---------------------------------
  // read address
  //---------------------------------
  assign raddr = rbin[addr_w-1:0];

  //---------------------------------
  // EMPTY detection
  //---------------------------------
  wire rempty_val;

  assign rempty_val = (rgray_next == wptr_gray_sync);
  
  

  always @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
      rempty <= 1;
    else
      rempty <= rempty_val;
  end
  
  //always @(posedge rclk) begin
  //$display("DBG rclk=%0t rbin=%0d raddr=%0d rempty=%0b rinc=%0b",
           //$time, rbin, raddr, rempty, rinc);
//end

endmodule
