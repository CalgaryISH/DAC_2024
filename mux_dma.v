module mux_dma(
    input wire ip0_in,    
    input wire ip0_axi_aw_valid,
    input wire ip0_axi_ar_valid,    
    input wire clk,
    input wire reset,
    output reg rd_wr
);

always @(posedge clk)
begin
if(!reset) begin
rd_wr<=0;
end
else begin
  if(ip0_axi_ar_valid==1'b1)
      rd_wr<=1'b0;
  else if(ip0_axi_aw_valid==1'b1)
      rd_wr<=1'b1;    
end
end
endmodule

