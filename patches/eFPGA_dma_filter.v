module eFPGA_dma_fsm(input wire clk, input wire [31:0] io_in, output wire [31:0] io_out, io_oeb);
eFPGA_dma_filter i_eFPGA_dma_filter(
	.clk(clk),	
	.io_in(io_in),
	.io_out(io_out),
	.io_oeb(io_oeb)	
	);
endmodule

module eFPGA_dma_filter (
input wire clk,
input wire [31:0] io_in,
output wire [31:0] io_out, 
output wire [31:0] io_oeb
);

wire [31:0]   addr_i=io_in[31:0];


reg [31:0] dma_axi_req_w_data_filtered_o=32'b0;


always @(posedge clk) begin
//if (addr_i == 32'hf5209028 || addr_i == 32'hf5200028)begin    for AES0 and AES2
if (addr_i == 32'hf5206000 )begin //for REGLK
    dma_axi_req_w_data_filtered_o <= 32'b0; 
end  
else begin
dma_axi_req_w_data_filtered_o <= addr_i;
end
end                             
assign io_out=dma_axi_req_w_data_filtered_o;
assign io_oeb=32'b0;
endmodule
