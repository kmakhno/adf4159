`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2022 11:24:23
// Design Name: 
// Module Name: control_interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_interface
(
    input wire clk_i,
    input wire rst_ni,
    input wire start_transfer_i,
    input wire [31:0] data_i,
    output wire CLK_o,
    output wire DATA_o,
    output wire LE_o,
    output wire complete_transfer_o
);
    
    
reg [3:0] clk_cnt_q;
reg CLK_q;
reg LE_q;
reg [1:0] shr_q=2'b00;
reg sh_en_q;
reg [31:0] data_q;
reg [5:0] periods_cnt_q;
reg complete_transfer_q;

always @(posedge clk_i) begin
    if (!rst_ni) begin
        LE_q <= 1'b1;
        complete_transfer_q <= 1'b0;
    end else if (start_transfer_i) begin
        LE_q <= 1'b0;
        complete_transfer_q <= 1'b0;
    end else if ((periods_cnt_q == 32) && (clk_cnt_q == 4)) begin
        LE_q <= 1'b1;
        complete_transfer_q <= 1'b1;
    end
end

always @(posedge clk_i) begin
    if (!rst_ni) begin
        CLK_q <= 1'b0;
        clk_cnt_q <= 0;
    end else if (!LE_q) begin
        clk_cnt_q <= clk_cnt_q + 1'b1;
        if (clk_cnt_q == 4) begin
            clk_cnt_q <= 0;
            CLK_q <= ~CLK_q;
        end
    end
end

always @(posedge clk_i) begin
    shr_q <= {shr_q[0], CLK_q};
end

always @(posedge clk_i) begin
    if (!rst_ni)
        data_q <= 0;
    else if (start_transfer_i)
        data_q <= data_i;
    else if (shr_q == 2'b01)
        data_q <= {data_q[30:0], 1'b0};
end

always @(posedge clk_i) begin
    if (!rst_ni)
        periods_cnt_q <= 0;
    else if (shr_q == 2'b01)
        periods_cnt_q <= periods_cnt_q + 1'b1;
    else if ((periods_cnt_q == 32) && (clk_cnt_q == 4))
        periods_cnt_q <= 0;
end
    
assign CLK_o = CLK_q;
assign LE_o  = LE_q;
assign DATA_o = data_q[31];
assign complete_transfer_o = complete_transfer_q;
    
endmodule
