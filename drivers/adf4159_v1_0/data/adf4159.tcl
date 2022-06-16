

proc generate {drv_handle} {
	::hsi::utils::define_include_file $drv_handle "xparameters.h" "adf4159" "NUM_INSTANCES" "DEVICE_ID" "C_S0_AXI_BASEADDR" "C_S0_AXI_HIGHADDR"
	::hsi::utils::define_config_file $drv_handle  "adf4159_g.c" "Adf4159" "DEVICE_ID" "C_S0_AXI_BASEADDR"

}
