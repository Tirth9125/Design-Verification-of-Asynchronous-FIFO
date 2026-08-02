module fifo_mem #(
  parameter data_w = 8,
  parameter depth  = 8,
  parameter addr_w = 3
)(
  input wclk,
  input we,
  input [addr_w-1:0] waddr,
  input [data_w-1:0] wdata,

  //input rclk,
  input [addr_w-1:0] raddr,
  output reg [data_w-1:0] rdata
);

reg [data_w-1:0] mem [0:depth-1];
assign rdata = mem[raddr];
always @(posedge wclk)
  if (we)begin
     mem[waddr] <= wdata;
  $display("MEM WRITE addr=%0d data=%0h time=%0t",
              waddr, wdata, $time);
    if(waddr == depth-1)
       $display("MEM INFO: FIFO MEMORY REACHED LAST ADDRESS (FULL) time=%0t",
                $time);

  end



 

endmodule
