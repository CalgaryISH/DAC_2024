module eFPGA_filter_fsm(input wire clk, input wire [31:0] io_in, output wire [31:0] io_out, io_oeb);

eFPGA_aes_filter i_eFPGA_aes_filter(
	.clk(clk),
	.reset(io_in[2]),
	.rd_wr(io_in[31]),
	.io_in(io_in),
	.io_out(io_out),
	.io_oeb(io_oeb),
	.ip(io_in[1:0])
	);

endmodule

module eFPGA_aes_filter (
input wire clk,
input wire reset,
input wire rd_wr,
input wire [31:0] io_in,
input wire [1:0] ip,
output wire [31:0] io_out, 
output wire [31:0] io_oeb
);

wire [22:0]   addr_i=io_in[25:3];
wire req_addr_valid_i=io_in[26];
wire resp_addr_ready_i=io_in[27];
wire resp_r_b_valid_i=io_in[28];
wire resp_w_ready_i=io_in[29];

reg req_addr_valid_filtered_o=0;
reg resp_addr_ready_filtered_o=0;
reg resp_r_b_valid_filtered_o=0;
reg resp_w_ready_filtered_o=0;
reg [1:0] state=0;
reg [22:0] ip_addr_low;
reg [22:0] ip_addr_high;
always @(posedge clk) begin
case(ip)
2'h0:begin
ip_addr_low<=23'h200028;
ip_addr_high<=23'h2000c8;
end
2'h1:begin
ip_addr_low<=23'h204028;
ip_addr_high<=23'h2040c8;
end
2'h2:begin
ip_addr_low<=23'h209028;
ip_addr_high<=23'h2090c8;
end
default:begin
ip_addr_low<=23'h0;
ip_addr_high<=23'h1;
end
endcase
end

always @(posedge clk) begin    
    if (!reset) begin
         state <= 0;
    end 
    else begin    
	if(!rd_wr) begin            
          case (state)
              2'h0: begin
                  if (addr_i >= ip_addr_low && addr_i <= ip_addr_high && req_addr_valid_i == 1'b1)begin
                      state <= 2'h1;
                      req_addr_valid_filtered_o <= 1'b0; // dont forward valid request
                  end
                  else begin
                      state <= 2'h0;
                      // by default forward requests 
	          req_addr_valid_filtered_o <= req_addr_valid_i;
	          resp_addr_ready_filtered_o <= resp_addr_ready_i; 
	          resp_r_b_valid_filtered_o <= resp_r_b_valid_i;        
                  end
              end
              2'h1: begin
                    state <= 2'h0;
                    req_addr_valid_filtered_o <= 1'b0;
                    resp_addr_ready_filtered_o <= 1'b1; // make user think request was completed and successful
                    resp_r_b_valid_filtered_o <= 1'b1;  // make user think request was completed and successful
              end
              default: state <= 2'h0;
          endcase
          end
          else begin 
	case (state)
              2'h0: begin
                  if(addr_i >= ip_addr_low && addr_i<=ip_addr_high && req_addr_valid_i == 1'b1 )
                  begin
                      state <= 2'h1;
                      req_addr_valid_filtered_o <= 1'b0; // dont forward valid request                      
                      resp_addr_ready_filtered_o <= 1'b1; // make user think request was completed and successful                       
                  end
                  else begin
                      state <= 2'h0;
                      // by default forward requests 
	        req_addr_valid_filtered_o <= req_addr_valid_i;
        	resp_addr_ready_filtered_o <= resp_addr_ready_i;
        	resp_w_ready_filtered_o <= resp_w_ready_i;
        	resp_r_b_valid_filtered_o <= resp_r_b_valid_i;                                                                     
                  end
              end
              2'h1: begin
                    state <= 2'h2;                                                         
                    resp_addr_ready_filtered_o <= 1'b0;
                    resp_w_ready_filtered_o <= 1'b1; // make user think request was completed and successful
              end
            2'h2: begin
                state <=2'h0;                
                resp_w_ready_filtered_o <= 1'b0;  
                resp_r_b_valid_filtered_o <= 1'b1;// make user think request was completed and successful
            end
              default: state <= 2'h0;
          endcase          
          end     
    end
end
assign io_out={28'b0,
		resp_w_ready_filtered_o,
                resp_r_b_valid_filtered_o,                
                resp_addr_ready_filtered_o,
                req_addr_valid_filtered_o};
assign io_oeb=32'b0;

endmodule
