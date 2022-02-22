# Xilinx Vivado script
# Version: Vivado 2018.2
# Function:
#   Generate a vivado project for the rocketchip SoC on sakura X board

set project_name [lindex $argv 0]
set bsp_dir 	 [lindex $argv 1]
set work_dir 	 [lindex $argv 2]
set board		 [lindex $argv 3]
set part		 [lindex $argv 4]

# Set the directory path for the original project from where this script was exported
set orig_proj_dir [file normalize $work_dir/$project_name]

# Create project
create_project -force $project_name $work_dir/$project_name

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects $project_name]
set_property "default_lib" "xil_defaultlib" $obj
set_property "PART" $part $obj 
set_property "simulator_language" "Mixed" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set files [list]
set vfiles [glob -directory $work_dir/$project_name/rtl_sources/ *.v]
foreach item $vfiles {
	lappend files [file normalize $item]
}
add_files -norecurse -fileset [get_filesets sources_1] $files

set_property verilog_define [list FPGA Differential_clock_capable_pin] [get_filesets sources_1] 

# Set 'sources_1' fileset properties
set_property "top" "system_top_wrapper" [get_filesets sources_1]

# Clock generator
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0
set_property -dict [list \
                        CONFIG.PRIMITIVE {MMCM} \
						CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
						CONFIG.PRIM_IN_FREQ {200.000} \
						CONFIG.MMCM_COMPENSATION {ZHOLD} \
						CONFIG.MMCM_DIVCLK_DIVIDE {1} \
						CONFIG.RESET_TYPE {ACTIVE_HIGH} \
						CONFIG.RESET_PORT {reset} \
						CONFIG.CLKOUT1_DRIVES {BUFG} \
						CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000}] \
    [get_ips clk_wiz_0]
generate_target {instantiation_template} [get_files $proj_dir/$project_name.srcs/sources_1/ip/clk_wiz_0_1/clk_wiz_0.xci]

# AXI CROSS-BAR
create_ip -name axi_crossbar -vendor xilinx.com -library ip -version 2.1 -module_name axi_crossbar_0
set_property -dict [list \
                        CONFIG.NUM_SI {1} \
                        CONFIG.NUM_MI {2} \
                        CONFIG.PROTOCOL {AXI4LITE} \
						CONFIG.ADDR_WIDTH {32} \
                        CONFIG.DATA_WIDTH {32} \
                        CONFIG.ADDR_RANGES {1} \
						CONFIG.M00_A00_BASE_ADDR {0x0000000070000000} \
                        CONFIG.M00_A00_ADDR_WIDTH {16} \
                        CONFIG.M01_A00_BASE_ADDR {0x0000000070600000} \
						CONFIG.M01_A00_ADDR_WIDTH {16}] \
    [get_ips axi_crossbar_0]
generate_target {instantiation_template} [get_files $proj_dir/$project_name.srcs/sources_1/ip/axi_crossbar_0/axi_crossbar_0.xci]

#BLK MEM GEN
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name blk_mem_gen_0
set_property -dict [list \
                        CONFIG.Memory_Type {True_Dual_Port_RAM} \
                        CONFIG.Interface_Type {Native} \
                        CONFIG.Coe_File {../../../../prog-bin/bootrom.coe} \
                        CONFIG.Fill_Remaining_Memory_Locations {1} \
                        CONFIG.Assume_Synchronous_Clk {1} \
                        CONFIG.Load_Init_File {1} \
                        CONFIG.Write_Width_A {32} \
                        CONFIG.Write_Width_B {32} \
                        CONFIG.Read_Width_A {32} \
                        CONFIG.Read_Width_B {32} \
						CONFIG.Write_Depth_A {262144} \
                        CONFIG.Byte_Size {8} \
                        CONFIG.Use_Byte_Write_Enable {1} \
                        CONFIG.Enable_A {Always_Enabled} \
                        CONFIG.Enable_B {Always_Enabled} \
                        CONFIG.Operating_Mode_A {READ_FIRST} \
                        CONFIG.Operating_Mode_B {WRITE_FIRST} \
                        CONFIG.Register_PortA_Output_of_Memory_Primitives {0} \
                        CONFIG.Register_PortB_Output_of_Memory_Primitives {0} \
                        CONFIG.Reset_Memory_Latch_A {0} \
                        CONFIG.Reset_Memory_Latch_B {0} \
                        CONFIG.Use_REGCEA_Pin {0} \
                        CONFIG.Use_REGCEB_Pin {0} \
                        CONFIG.Enable_32bit_Address {0} \
                        CONFIG.ECC {0}] \
	[get_ips blk_mem_gen_0]
generate_target {instantiation_template} [get_files $proj_dir/$project_name.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci]

#GPIO-Trigger
create_ip -name axi_gpio -vendor xilinx.com -library ip -version 2.0 -module_name axi_gpio_0
set_property -dict [list \
                        CONFIG.C_ALL_INPUTS {0} \
                        CONFIG.C_ALL_OUTPUTS {1} \
						CONFIG.C_GPIO_WIDTH {2} \
						CONFIG.C_IS_DUAL {0} \
						CONFIG.C_INTERRUPT_PRESENT {0}] \
	[get_ips axi_gpio_0]
generate_target {instantiation_template} [get_files $proj_dir/$project_name.srcs/sources_1/ip/axi_gpio_0/axi_gpio_0.xci]

#UART
create_ip -name axi_uartlite -vendor xilinx.com -library ip -version 2.0 -module_name axi_uartlite_0
set_property -dict [list \
						CONFIG.C_S_AXI_ACLK_FREQ_HZ_d {50} \
						CONFIG.C_BAUDRATE {115200} \
						CONFIG.C_DATA_BITS {8} \
						CONFIG.C_USE_PARITY {0}] \
	[get_ips axi_uartlite_0]
generate_target {instantiation_template} [get_files $proj_dir/$project_name.srcs/sources_1/ip/axi_uartlite_0/axi_uartlite_0.xci]

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$bsp_dir/board/$board/constraint/ioportmap.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]

# generate all IP source code
generate_target all [get_ips]

# force create the synth_1 path (need to make soft link in Makefile)
launch_runs -scripts_only synth_1


# suppress some not very useful messages
# warning partial connection
set_msg_config -id "\[Synth 8-350\]" -suppress
# info do synthesis
set_msg_config -id "\[Synth 8-256\]" -suppress
set_msg_config -id "\[Synth 8-638\]" -suppress
# BRAM mapped to LUT due to optimization
set_msg_config -id "\[Synth 8-3969\]" -suppress
# BRAM with no output register
set_msg_config -id "\[Synth 8-4480\]" -suppress
# DSP without input pipelining
set_msg_config -id "\[Drc 23-20\]" -suppress
# Update IP version
set_msg_config -id "\[Netlist 29-345\]" -suppress


# do not flatten design
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
