
`timescale 1 ns / 1 ps

	module adf4159_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S0_AXI
		parameter integer C_S0_AXI_DATA_WIDTH	= 32,
		parameter integer C_S0_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here
		input  wire ref_clk_i,
		output wire ref_clk_o,
        output wire CLK_o,
        output wire DATA_o,
        output wire LE_o,
        input  wire MUXOUT_i, //Ramp completion strobe
        output wire MUXOUT_o,
        input  wire TX_Ramp_Clk_i, //External ramp control clock
        output wire TX_Ramp_Clk_o,
//        output wire CE_o,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S0_AXI
		input wire  s0_axi_aclk,
		input wire  s0_axi_aresetn,
		input wire [C_S0_AXI_ADDR_WIDTH-1 : 0] s0_axi_awaddr,
		input wire [2 : 0] s0_axi_awprot,
		input wire  s0_axi_awvalid,
		output wire  s0_axi_awready,
		input wire [C_S0_AXI_DATA_WIDTH-1 : 0] s0_axi_wdata,
		input wire [(C_S0_AXI_DATA_WIDTH/8)-1 : 0] s0_axi_wstrb,
		input wire  s0_axi_wvalid,
		output wire  s0_axi_wready,
		output wire [1 : 0] s0_axi_bresp,
		output wire  s0_axi_bvalid,
		input wire  s0_axi_bready,
		input wire [C_S0_AXI_ADDR_WIDTH-1 : 0] s0_axi_araddr,
		input wire [2 : 0] s0_axi_arprot,
		input wire  s0_axi_arvalid,
		output wire  s0_axi_arready,
		output wire [C_S0_AXI_DATA_WIDTH-1 : 0] s0_axi_rdata,
		output wire [1 : 0] s0_axi_rresp,
		output wire  s0_axi_rvalid,
		input wire  s0_axi_rready
	);
	
	wire start_transfer_d;
	wire [31:0] data_d;
	wire LE_d;
	wire CLK_d;
	wire DATA_d;
	wire complete_transfer_d;
	wire TX_Ramp_Clk_d;
	wire Ramp_Completion_d;
	wire ref_clk_d;
	
// Instantiation of Axi Bus Interface S0_AXI
	adf4159_v1_0_S0_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S0_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S0_AXI_ADDR_WIDTH)
	) adf4159_v1_0_S0_AXI_inst (
		.S_AXI_ACLK(s0_axi_aclk),
		.S_AXI_ARESETN(s0_axi_aresetn),
		.S_AXI_AWADDR(s0_axi_awaddr),
		.S_AXI_AWPROT(s0_axi_awprot),
		.S_AXI_AWVALID(s0_axi_awvalid),
		.S_AXI_AWREADY(s0_axi_awready),
		.S_AXI_WDATA(s0_axi_wdata),
		.S_AXI_WSTRB(s0_axi_wstrb),
		.S_AXI_WVALID(s0_axi_wvalid),
		.S_AXI_WREADY(s0_axi_wready),
		.S_AXI_BRESP(s0_axi_bresp),
		.S_AXI_BVALID(s0_axi_bvalid),
		.S_AXI_BREADY(s0_axi_bready),
		.S_AXI_ARADDR(s0_axi_araddr),
		.S_AXI_ARPROT(s0_axi_arprot),
		.S_AXI_ARVALID(s0_axi_arvalid),
		.S_AXI_ARREADY(s0_axi_arready),
		.S_AXI_RDATA(s0_axi_rdata),
		.S_AXI_RRESP(s0_axi_rresp),
		.S_AXI_RVALID(s0_axi_rvalid),
		.S_AXI_RREADY(s0_axi_rready),
		
        .start_transfer_o(start_transfer_d),
        .data_o(data_d),
        .complete_transfer_i(complete_transfer_d),
        .MUXOUT_i(MUXOUT_i)
	);

    control_interface control_interface_inst
    (
        .clk_i(s0_axi_aclk),
        .rst_ni(s0_axi_aresetn),
        .start_transfer_i(start_transfer_d),
        .data_i(data_d),
        .CLK_o(CLK_d),
        .DATA_o(DATA_d),
        .LE_o(LE_d),
        .complete_transfer_o(complete_transfer_d)
    );

   OBUF OBUF_LE (
      .O(LE_o),     // Buffer output (connect directly to top-level port)
      .I(LE_d)      // Buffer input
   );

   OBUF OBUF_CLK (
      .O(CLK_o),     // Buffer output (connect directly to top-level port)
      .I(CLK_d)      // Buffer input
   );
   
   OBUF OBUF_DATA (
      .O(DATA_o),     // Buffer output (connect directly to top-level port)
      .I(DATA_d)      // Buffer input
   );

   IBUF TX_RAMP_CLK_I (
      .O(TX_Ramp_Clk_d),     // Buffer output
      .I(TX_Ramp_Clk_i)      // Buffer input (connect directly to top-level port)
   );

   OBUF TX_RAMP_CLK_O (
      .O(TX_Ramp_Clk_o),     // Buffer output (connect directly to top-level port)
      .I(TX_Ramp_Clk_d)      // Buffer input
   );
   
   IBUF RAMP_COMPLETION_I (
      .O(Ramp_Completion_d),     // Buffer output
      .I(MUXOUT_i)      // Buffer input (connect directly to top-level port)
   );
   
   OBUF RAMP_COMPLETION_O (
      .O(MUXOUT_o),     // Buffer output (connect directly to top-level port)
      .I(Ramp_Completion_d)      // Buffer input
   );
   
   BUFG REF_CLK_I (
      .O(ref_clk_d), // 1-bit output: Clock output
      .I(ref_clk_i)  // 1-bit input: Clock input
   );
   
   BUFG REF_CLK_O (
      .O(ref_clk_o), // 1-bit output: Clock output
      .I(ref_clk_d)  // 1-bit input: Clock input
   );
   
   
	endmodule
