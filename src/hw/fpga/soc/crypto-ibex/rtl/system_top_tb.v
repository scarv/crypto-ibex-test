`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2022 14:46:20
// Design Name: 
// Module Name: system_top_tb
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


module system_top_tb;


reg clock, rst;

always #10 clock <= (clock === 1'b0);
initial begin
	clock = 0;
	rst   = 1;
	#50;
	rst   = 0;
end
wire rxd = 1'b0;
wire txd;
system_top_wrapper DUT(
    .clk_50M (clock),
    .k_resetb (rst ),
    .uart_rtl_0_rxd(rxd),
    .uart_rtl_0_txd(txd),
    .gpio_tri_o(),
    .gpio_led()
    );
	
endmodule
