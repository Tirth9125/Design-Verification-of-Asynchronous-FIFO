/*module wptr_full #(
  parameter addr_w = 3,
  parameter ptr_w  = addr_w + 1
)(
  input  wclk,
  input  wrst_n,
  input  winc,
  input  [ptr_w-1:0] rptr_gray_sync,

  output [addr_w-1:0] waddr,
  output reg [ptr_w-1:0] wptr_gray,
  output wfull
);

  // binary write pointer
  reg [ptr_w-1:0] wbin;

  // next state signals
  wire [ptr_w-1:0] wbin_next;
  wire [ptr_w-1:0] wgray_next;

  //---------------------------------
  // pointer increment
  //---------------------------------
  assign wbin_next = wbin + (winc & ~wfull);

  //---------------------------------
  // gray code conversion
  //---------------------------------
  assign wgray_next = (wbin_next >> 1) ^ wbin_next;

  //---------------------------------
  // write address (current pointer)
  //---------------------------------
  assign waddr = wbin[addr_w-1:0];

  //---------------------------------
  // pointer registers
  //---------------------------------
  always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      wbin      <= 0;
      wptr_gray <= 0;
    end
    else begin
      wbin      <= wbin_next;
      wptr_gray <= wgray_next;
    end
  end

  //---------------------------------
  // full detection
  //---------------------------------
  assign wfull =
      (wgray_next ==
      {~rptr_gray_sync[ptr_w-1:ptr_w-2],
        rptr_gray_sync[ptr_w-3:0]});

endmodule*/

module wptr_full #(
  parameter addr_w = 3,
  parameter ptr_w  = addr_w + 1
)(
  input  wclk,
  input  wrst_n,
  input  winc,
  input  [ptr_w-1:0] rptr_gray_sync,

  output [addr_w-1:0] waddr,
  output reg [ptr_w-1:0] wptr_gray,
  output reg wfull
);

  reg [ptr_w-1:0] wbin;

  wire [ptr_w-1:0] wbin_next;
  wire [ptr_w-1:0] wgray_next;

  //---------------------------------
  // pointer increment
  //---------------------------------
  assign wbin_next = wbin + (winc & ~wfull);

  //---------------------------------
  // gray conversion
  //---------------------------------
  assign wgray_next = (wbin_next >> 1) ^ wbin_next;

  //---------------------------------
  // memory address
  //---------------------------------
  assign waddr = wbin[addr_w-1:0];

  //---------------------------------
  // pointer register
  //---------------------------------
  always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      wbin      <= 0;
      wptr_gray <= 0;
    end
    else begin
      wbin      <= wbin_next;
      wptr_gray <= wgray_next;
    end
  end

  //---------------------------------
  // FULL detection
  //---------------------------------
  wire wfull_val;

  assign wfull_val =
        (wgray_next ==
        {~rptr_gray_sync[ptr_w-1:ptr_w-2],
          rptr_gray_sync[ptr_w-3:0]});

  always @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n)
      wfull <= 0;
    else
      wfull <= wfull_val;
  end

endmodule
