module mux_key_sel(
    input wire ip0_in,    
    input wire ip0_axi_aw_valid,
    input wire ip0_axi_ar_valid,    
    input wire ip1_in,    
    input wire ip1_axi_aw_valid,
    input wire ip1_axi_ar_valid,    
    input wire ip2_in,    
    input wire ip2_axi_aw_valid,
    input wire ip2_axi_ar_valid,    
    output reg [1:0] key_o,
    input wire clk,
    input wire reset,
    output reg rd_wr
);
parameter AES0 = 2'h0;
parameter AES1 = 2'h1;
parameter AES2 = 2'h2;
//wire rd_wr_temp;
always @(posedge clk)
begin
if(!reset) begin
key_o<=AES0;
end
else if(ip0_in==1'h1) begin
key_o<=AES0;
end
else if(ip1_in==1'h1) begin
key_o<=AES1; 
end
else if(ip2_in==1'h1) begin
key_o<=AES2;
end
end

always @(posedge clk)
begin
if(!reset) begin
rd_wr<=0;
end
else begin
    case(key_o) 
        AES0: begin
            if(ip0_axi_ar_valid==1'b1)
            rd_wr<=1'b0;
            else if(ip0_axi_aw_valid==1'b1)
            rd_wr<=1'b1;
        end
        AES1: begin
            if(ip1_axi_ar_valid==1'b1)
            rd_wr<=1'b0;
            else if(ip1_axi_aw_valid==1'b1)
            rd_wr<=1'b1;
        end        
        AES2: begin
            if(ip2_axi_ar_valid==1'b1)
            rd_wr<=1'b0;
            else if(ip2_axi_aw_valid==1'b1)
            rd_wr<=1'b1;
        end        
    endcase
end
end
endmodule

