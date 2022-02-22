`timescale 1 ps / 1 ps

module system_top_wrapper
   (
   
`ifdef Differential_clock_capable_pin
    input k_clk_osc0_clk_p,       // input clk_in1_p
    input k_clk_osc0_clk_n,       // input clk_in1_n
`else
	input k_clk_osc0_clk,         // input clk_in1_p
`endif

//  input clk_50M,  
    input k_resetb,
    input uart_rtl_0_rxd,
    output uart_rtl_0_txd,
    output [0:0] gpio_tri_o,
    output [0:0] gpio_led
    );

wire [1:0] gpio;

assign gpio_tri_o = gpio[0];
assign gpio_led   = gpio[0];
  
wire clk_50M;  
wire locked, sys_rstn;
wire rst_request;

assign sys_rstn = locked && (~rst_request);   //reset active low

int_reset int_reset_ins(
    .sys_clk(     clk_50M   ),
    .sys_rst(     k_resetb  ),
    .rst_detect(  gpio[1]    ),
    .rst_request( rst_request) );

clk_wiz_0 clk_gen
   (
    // Clock out ports
    .clk_out1(clk_50M),                // output clk_out1
    // Status and control signals
    .reset(k_resetb),   // input reset
    .locked(locked),                   // output locked
   // Clock in ports
`ifdef Differential_clock_capable_pin
    .clk_in1_p(k_clk_osc0_clk_p),      // input clk_in1_p
    .clk_in1_n(k_clk_osc0_clk_n));     // input clk_in1_n
`else
	.clk_in1(k_clk_osc0_clk));         // input clk_in1_p
`endif  

//assign locked = ~k_resetb;
/*    

localparam MEM_DATA_WIDTH = 32;
localparam BRAM_ADDR_WIDTH = 17;     // 32 KB
localparam BRAM_LINE = 2 ** BRAM_ADDR_WIDTH  * 8 / MEM_DATA_WIDTH;
localparam BRAM_LINE_OFFSET = $clog2(MEM_DATA_WIDTH/8);

wire                       bram_clk;  
wire                       bram_ena;
wire [                3:0] bram_wea;
wire [BRAM_ADDR_WIDTH-1:0] bram_addra;
wire [               31:0] bram_dina;
wire [               31:0] bram_douta;
reg  [ MEM_DATA_WIDTH-1:0] ram [0 : BRAM_LINE-1];
initial $readmemh("prog.mem", ram);
reg [BRAM_ADDR_WIDTH-1:BRAM_LINE_OFFSET] ram_addr_dly;

always@(posedge bram_clk) begin
    if(bram_ena) begin
        ram_addr_dly <= bram_addra[BRAM_ADDR_WIDTH-1:BRAM_LINE_OFFSET];
        if(bram_wea[0]) ram[bram_addra[BRAM_ADDR_WIDTH-1:BRAM_LINE_OFFSET]][7 : 0] <= bram_dina[7 : 0];
        if(bram_wea[1]) ram[bram_addra[BRAM_ADDR_WIDTH-1:BRAM_LINE_OFFSET]][15: 8] <= bram_dina[15: 8];
        if(bram_wea[2]) ram[bram_addra[BRAM_ADDR_WIDTH-1:BRAM_LINE_OFFSET]][23:16] <= bram_dina[23:16];
        if(bram_wea[3]) ram[bram_addra[BRAM_ADDR_WIDTH-1:BRAM_LINE_OFFSET]][31:24] <= bram_dina[31:24];
    end
end
assign bram_douta = ram[ram_addr_dly];
//assign bram_douta[7 : 0] = ram[ram_addr_dly][31:24];
//assign bram_douta[15: 8] = ram[ram_addr_dly][23:16];
//assign bram_douta[23:16] = ram[ram_addr_dly][15: 8];
//assign bram_douta[31:24] = ram[ram_addr_dly][7 : 0]; 
*/ 

// Instruction connection to SRAM
wire        instr_req;
wire        instr_gnt;
reg         instr_rvalid;
wire [31:0] instr_addr;
wire [31:0] instr_rdata;

// Data connection to SRAM
wire        data_req;
wire        data_gnt;
wire        data_rvalid;
wire        data_we;
wire  [3:0] data_be;
wire [31:0] data_addr;
wire [31:0] data_wdata;
wire [31:0] data_rdata;
ibex_wrapper #(
    .PMPEnable        (1'b0),
    .RV32E            (1'b0),    //None
    .RV32M            (2),       //RV32MFast
    .DmHaltAddr       (32'h00000000),
    .DmExceptionAddr  (32'h00000000)
) crypto_ibex (
    .clk_i (clk_50M),
    .rst_ni(sys_rstn),

    .test_en_i(1'b1),
    .ram_cfg_i(1'b0),  // not in use

    .hart_id_i  (32'd0),
    .boot_addr_i(32'h00000000),

    .instr_req_o(       instr_req),
    .instr_gnt_i(       instr_gnt),
    .instr_rvalid_i(    instr_rvalid),
    .instr_addr_o(      instr_addr),
    .instr_rdata_i(     instr_rdata),
    .instr_rdata_intg_i(7'd0),
    .instr_err_i(       1'b0),

    .data_req_o(        data_req),
    .data_gnt_i(        data_gnt),
    .data_rvalid_i(     data_rvalid),
    .data_we_o(         data_we),
    .data_be_o(         data_be),
    .data_addr_o(       data_addr),
    .data_wdata_o(      data_wdata),
    .data_wdata_intg_o(),
    .data_rdata_i(      data_rdata),
    .data_rdata_intg_i(7'd0),
    .data_err_i(       1'b0),

    .debug_req_i(1'b0),
    .crash_dump_o(),

    .fetch_enable_i(1'b1),
    .alert_minor_o         (),
    .alert_major_o         (),
    .core_sleep_o          (),

    // Interrupt inputs
    .irq_software_i( 1'b0  ),
    .irq_timer_i(    1'b0  ),
    .irq_external_i( 1'b0  ),
    .irq_fast_i(    15'd0  ),
    .irq_nm_i(       1'b0  ),      // non-maskeable interrupt

    .scan_rst_ni(    1'b1  )    //unactivated
);

wire        mmio_sel = (data_addr[31:28] == 4'd7);
wire        mem_sel  = (data_addr[31:28] == 4'd0);  //
wire        mem_we   = data_we && mem_sel;
wire [31:0] mem_rdata;
  // SRAM block for instruction and data storage
blk_mem_gen_0 u_ram (
  .clka ( clk_50M               ),  // input wire clka
  .wea  ( data_be & {4{mem_we}} ),  // input wire [3 : 0] wea
  .addra( data_addr[19:2]       ),  // input wire [14 : 0] addra
  .dina ( data_wdata            ),  // input wire [31 : 0] dina
  .douta(  mem_rdata            ),  // output wire [31 : 0] douta
  
  .clkb ( clk_50M            ),     // input wire clkb
  .web  ( 4'b0000            ),     // input wire [3 : 0] wea
  .addrb( instr_addr[19:2]   ),     // input wire [14 : 0] addrb
  .dinb ( 32'h0000           ),     // input wire [31 : 0] dinb
  .doutb( instr_rdata        )      // output wire [31 : 0] doutb
);
/*  ram_2p #(
    .Depth(MEM_SIZE / 4),
    .MemInitFile(SRAMInitFile)
  ) u_ram (
    .clk_i (clk_50M),
    .rst_ni(sys_rstn),

    .a_req_i   (data_req),
    .a_we_i    (data_we),
    .a_be_i    (data_be),
    .a_addr_i  (data_addr),
    .a_wdata_i (data_wdata),
    .a_rvalid_o(data_rvalid),
    .a_rdata_o (data_rdata),

    .b_req_i   (instr_req),
    .b_we_i    (1'b0),
    .b_be_i    (4'b0),
    .b_addr_i  (instr_addr),
    .b_wdata_i (32'b0),
    .b_rvalid_o(instr_rvalid),
    .b_rdata_o (instr_rdata)
  );
*/   
// SRAM to Ibex
reg mem_gnt;
always @(posedge clk_50M or negedge sys_rstn) begin
  if (!sys_rstn) begin
    //instr_gnt    <= 1'b0;
    mem_gnt      <= 1'b0;
    instr_rvalid <= 1'b0;
  end else begin
    //instr_gnt    <= instr_req;
    instr_rvalid <= instr_gnt;
    mem_gnt     <=  data_req;
  end
end

wire           mmio_axi_lite_awvalid = (mmio_sel & data_req & data_we);
wire           mmio_axi_lite_awready;
wire [31: 0]   mmio_axi_lite_awaddr  = data_addr;
wire [ 2: 0]   mmio_axi_lite_awprot  = 3'b000; 
wire           mmio_axi_lite_wvalid  = (mmio_sel & data_we);
wire           mmio_axi_lite_wready;
wire [31: 0]   mmio_axi_lite_wdata   = data_wdata;
wire [ 3: 0]   mmio_axi_lite_wstrb   = ({4{mmio_sel}} & data_be);
wire [ 1: 0]   mmio_axi_lite_bresp; 
wire           mmio_axi_lite_bvalid;
wire           mmio_axi_lite_bready  = mmio_axi_lite_bvalid; 

wire           mmio_axi_lite_arvalid = (mmio_sel & data_req & ~data_we);
wire           mmio_axi_lite_arready;
wire [31: 0]   mmio_axi_lite_araddr  = data_addr;
wire [ 2: 0]   mmio_axi_lite_arprot  = 3'b000; 
wire [31: 0]   mmio_axi_lite_rdata;
wire [ 1: 0]   mmio_axi_lite_rresp;
wire           mmio_axi_lite_rvalid;
wire           mmio_axi_lite_rready  = mmio_axi_lite_rvalid;
assign instr_gnt   = instr_req; 
assign data_gnt    = (mem_sel) ? mem_gnt   : (mmio_axi_lite_arready | mmio_axi_lite_awready);
assign data_rvalid = (mem_sel) ? mem_gnt   : (mmio_axi_lite_rvalid | mmio_axi_lite_wready); 
assign data_rdata  = (mem_sel) ? mem_rdata : mmio_axi_lite_rdata;
 
wire                m00_axi_awvalid,m01_axi_awvalid;
wire                m00_axi_awready,m01_axi_awready;
wire    [31: 0]     m00_axi_awaddr, m01_axi_awaddr;
wire    [2 : 0]     m00_axi_awprot, m01_axi_awprot; 
wire                m00_axi_wvalid, m01_axi_wvalid;
wire                m00_axi_wready, m01_axi_wready;
wire    [31: 0]     m00_axi_wdata,  m01_axi_wdata;
wire    [3 : 0]     m00_axi_wstrb,  m01_axi_wstrb;  
wire    [1 : 0]     m00_axi_bresp,  m01_axi_bresp;
wire                m00_axi_bvalid, m01_axi_bvalid;
wire                m00_axi_bready, m01_axi_bready;
wire                m00_axi_arvalid,m01_axi_arvalid;
wire                m00_axi_arready,m01_axi_arready;
wire    [31: 0]     m00_axi_araddr, m01_axi_araddr;
wire    [2 : 0]     m00_axi_arprot, m01_axi_arprot; 
wire                m00_axi_rvalid, m01_axi_rvalid;
wire                m00_axi_rready, m01_axi_rready;
wire    [31: 0]     m00_axi_rdata,  m01_axi_rdata;
wire    [1 : 0]     m00_axi_rresp,  m01_axi_rresp;
axi_crossbar_0 axi_crossbar_ins (
  .aclk(            clk_50M),                 // input wire aclk
  .aresetn(         sys_rstn),                // input wire aresetn
  .s_axi_awaddr(    mmio_axi_lite_awaddr),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awprot(    mmio_axi_lite_awprot),    // input wire [2 : 0] s_axi_awprot
  .s_axi_awvalid(   mmio_axi_lite_awvalid),   // input wire [0 : 0] s_axi_awvalid
  .s_axi_awready(   mmio_axi_lite_awready),   // output wire [0 : 0] s_axi_awready
  .s_axi_wdata(     mmio_axi_lite_wdata),     // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(     mmio_axi_lite_wstrb),     // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid(    mmio_axi_lite_wvalid),    // input wire [0 : 0] s_axi_wvalid
  .s_axi_wready(    mmio_axi_lite_wready),    // output wire [0 : 0] s_axi_wready
  .s_axi_bresp(     mmio_axi_lite_bresp),     // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(    mmio_axi_lite_bvalid),    // output wire [0 : 0] s_axi_bvalid
  .s_axi_bready(    mmio_axi_lite_bready),    // input wire [0 : 0] s_axi_bready
  .s_axi_araddr(    mmio_axi_lite_araddr),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arprot(    mmio_axi_lite_arprot),    // input wire [2 : 0] s_axi_arprot
  .s_axi_arvalid(   mmio_axi_lite_arvalid),   // input wire [0 : 0] s_axi_arvalid
  .s_axi_arready(   mmio_axi_lite_arready),   // output wire [0 : 0] s_axi_arready
  .s_axi_rdata(     mmio_axi_lite_rdata),     // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(     mmio_axi_lite_rresp),     // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(    mmio_axi_lite_rvalid),    // output wire [0 : 0] s_axi_rvalid
  .s_axi_rready(    mmio_axi_lite_rready),    // input wire [0 : 0] s_axi_rready
  .m_axi_awaddr( {m01_axi_awaddr, m00_axi_awaddr}),    // output wire [63 : 0] m_axi_awaddr
  .m_axi_awprot( {m01_axi_awprot, m00_axi_awprot}),    // output wire [5 : 0] m_axi_awprot
  .m_axi_awvalid({m01_axi_awvalid,m00_axi_awvalid}),   // output wire [1 : 0] m_axi_awvalid
  .m_axi_awready({m01_axi_awready,m00_axi_awready}),   // input wire [1 : 0] m_axi_awready
  .m_axi_wdata(  {m01_axi_wdata,  m00_axi_wdata}),     // output wire [63 : 0] m_axi_wdata
  .m_axi_wstrb(  {m01_axi_wstrb,  m00_axi_wstrb}),     // output wire [7 : 0] m_axi_wstrb
  .m_axi_wvalid( {m01_axi_wvalid, m00_axi_wvalid}),    // output wire [1 : 0] m_axi_wvalid
  .m_axi_wready( {m01_axi_wready, m00_axi_wready}),    // input wire [1 : 0] m_axi_wready
  .m_axi_bresp(  {m01_axi_bresp,  m00_axi_bresp}),     // input wire [3 : 0] m_axi_bresp
  .m_axi_bvalid( {m01_axi_bvalid, m00_axi_bvalid}),    // input wire [1 : 0] m_axi_bvalid
  .m_axi_bready( {m01_axi_bready, m00_axi_bready}),    // output wire [1 : 0] m_axi_bready
  .m_axi_araddr( {m01_axi_araddr, m00_axi_araddr}),    // output wire [63 : 0] m_axi_araddr
  .m_axi_arprot( {m01_axi_arprot, m00_axi_arprot}),    // output wire [5 : 0] m_axi_arprot
  .m_axi_arvalid({m01_axi_arvalid,m00_axi_arvalid}),   // output wire [1 : 0] m_axi_arvalid
  .m_axi_arready({m01_axi_arready,m00_axi_arready}),   // input wire [1 : 0] m_axi_arready
  .m_axi_rdata(  {m01_axi_rdata,  m00_axi_rdata}),     // input wire [63 : 0] m_axi_rdata
  .m_axi_rresp(  {m01_axi_rresp,  m00_axi_rresp}),     // input wire [3 : 0] m_axi_rresp
  .m_axi_rvalid( {m01_axi_rvalid, m00_axi_rvalid}),    // input wire [1 : 0] m_axi_rvalid
  .m_axi_rready( {m01_axi_rready, m00_axi_rready})     // output wire [1 : 0] m_axi_rready
);

axi_uartlite_0 uartlite_ins (
  .s_axi_aclk(   clk_50M),              // input wire s_axi_aclk
  .s_axi_aresetn(sys_rstn),             // input wire s_axi_aresetn
  .interrupt( ),                        // output wire interrupt
  .s_axi_awaddr( m01_axi_awaddr[3:0]),  // input wire [3 : 0] s_axi_awaddr
  .s_axi_awvalid(m01_axi_awvalid),      // input wire s_axi_awvalid
  .s_axi_awready(m01_axi_awready),      // output wire s_axi_awready
  .s_axi_wdata(  m01_axi_wdata),        // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(  m01_axi_wstrb),        // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid( m01_axi_wvalid),       // input wire s_axi_wvalid
  .s_axi_wready( m01_axi_wready),       // output wire s_axi_wready
  .s_axi_bresp(  m01_axi_bresp),        // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid( m01_axi_bvalid),       // output wire s_axi_bvalid
  .s_axi_bready( m01_axi_bready),       // input wire s_axi_bready
  .s_axi_araddr( m01_axi_araddr[3:0]),  // input wire [3 : 0] s_axi_araddr
  .s_axi_arvalid(m01_axi_arvalid),      // input wire s_axi_arvalid
  .s_axi_arready(m01_axi_arready),      // output wire s_axi_arready
  .s_axi_rdata(  m01_axi_rdata),        // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(  m01_axi_rresp),        // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid( m01_axi_rvalid),       // output wire s_axi_rvalid
  .s_axi_rready( m01_axi_rready),       // input wire s_axi_rready
  .rx(uart_rtl_0_rxd),                  // input wire rx
  .tx(uart_rtl_0_txd)                   // output wire tx
);

axi_gpio_0 gpio_ins (
  .s_axi_aclk(   clk_50M),              // input wire s_axi_aclk
  .s_axi_aresetn(sys_rstn),             // input wire s_axi_aresetn
  .s_axi_awaddr( m00_axi_awaddr[8:0]),  // input wire [8 : 0] s_axi_awaddr
  .s_axi_awvalid(m00_axi_awvalid),      // input wire s_axi_awvalid
  .s_axi_awready(m00_axi_awready),      // output wire s_axi_awready
  .s_axi_wdata(  m00_axi_wdata),        // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(  m00_axi_wstrb),        // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid( m00_axi_wvalid),       // input wire s_axi_wvalid
  .s_axi_wready( m00_axi_wready),       // output wire s_axi_wready
  .s_axi_bresp(  m00_axi_bresp),        // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid( m00_axi_bvalid),       // output wire s_axi_bvalid
  .s_axi_bready( m00_axi_bready),       // input wire s_axi_bready
  .s_axi_araddr( m00_axi_araddr[8:0]),  // input wire [8 : 0] s_axi_araddr
  .s_axi_arvalid(m00_axi_arvalid),      // input wire s_axi_arvalid
  .s_axi_arready(m00_axi_arready),      // output wire s_axi_arready
  .s_axi_rdata(  m00_axi_rdata),        // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(  m00_axi_rresp),        // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid( m00_axi_rvalid),       // output wire s_axi_rvalid
  .s_axi_rready( m00_axi_rready),       // input wire s_axi_rready
  .gpio_io_o(gpio)                      // output wire [1 : 0] gpio_io_o
);

endmodule


module int_reset (
    sys_clk,
    sys_rst,
    rst_detect,
    rst_request );
input           sys_clk, sys_rst;
input 	        rst_detect;
output          rst_request; 

reg signal_latch;
always @(posedge sys_clk or posedge sys_rst) begin
    if (sys_rst)  signal_latch <=1'b1;
    else          signal_latch <=rst_detect;
end

assign  rst_request = (~signal_latch) && rst_detect;
endmodule

