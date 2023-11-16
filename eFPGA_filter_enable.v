module eFPGA_filter_enable(
    input wire [63:0]   status_reg,
    input wire clk,
	input wire reset,
    output reg en
 );
 
 always @(posedge clk)
 begin
 if(!reset)
 begin
 	en <= 1'b0;
 end
 if (status_reg==64'hfff5206048)
 begin
	en <= 1'b1;
 end
 end    
endmodule
