`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2022 11:30:32
// Design Name: 
// Module Name: control_interface_tb
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


module control_interface_tb;

reg clk_i;
reg rst_ni;
reg start_transfer_i;
reg [31:0] data_i;
wire CLK_o;
wire DATA_o;
wire LE_o;

control_interface control_interface_inst (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .start_transfer_i(start_transfer_i),
    .data_i(data_i),
    .CLK_o(CLK_o),
    .DATA_o(DATA_o),
    .LE_o(LE_o)
);

initial begin
    clk_i <= 0;
    forever #5 clk_i <= ~clk_i;
end

initial begin
    rst_ni <= 0;
    start_transfer_i=0;
    data_i = 32'h0A0B0C0D;
    repeat (10) @(posedge clk_i);
    rst_ni <= 1;
    @(posedge clk_i);
    start_transfer_i=1;
    @(posedge clk_i);
    start_transfer_i=0;
    repeat (1000) @(posedge clk_i);
    $finish();
end

endmodule
