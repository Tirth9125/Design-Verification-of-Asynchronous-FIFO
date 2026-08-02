module sync #(
  parameter width = 4
)(
  input clk,
  input rst_n,
  input [width-1:0] din,
  output [width-1:0] dout
);
  
  reg [width-1:0] q1,q2;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q1 <= 0;
      q2 <= 0;
    end else begin
      q1 <= din;
      q2 <= q1;
    end
   
  end
  
  assign dout = q2;
  
endmodule
