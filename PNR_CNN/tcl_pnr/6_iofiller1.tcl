# ===========================
# IO Pad Spacing Setup
# ===========================

# Left Side IOs
#uiSetTool select
#gui_select -rect {-86.926 2285.076 1981.676 2117.749}
deselectAll
selectInst PcornerUL
selectInst PGND1
selectInst clkpad
selectInst rst_pad
selectInst spi_clk_pad
selectInst spi_cs_pad
selectInst spi_sdi0_pad
selectInst spi_sdi1_pad
selectInst PGND2
spaceIoInst -fixSide left -space 159

# Bottom Side IOs
deselectAll
selectInst uart_dsr_pad
selectInst uart_cts_pad
selectInst uart_rx_pad
selectInst tdi_i_pad
selectInst tms_i_pad
selectInst trstn_i_pad
selectInst tck_i_pad
selectInst fetch_en_pad
selectInst PcornerLL
spaceIoInst -fixSide bottom -space 159

# Right Side IOs
deselectAll
selectInst PVDD1
selectInst gpio_out8_pad
selectInst tdo_o_pad
selectInst uart_tx_pad
selectInst uart_rts_pad
selectInst uart_dtr_pad
selectInst PVDD2
selectInst PcornerLR
spaceIoInst -fixSide right -space 186

# Top Side IOs
deselectAll
selectInst PcornerUR
selectInst spi_mode_o1_pad
selectInst spi_mode_o0_pad
pan 69.965 602.779
selectInst spi_sdo3_o_pad
selectInst spi_sdo2_o_pad
selectInst spi_sdo1_o_pad
selectInst spi_sdo0_o_pad
selectInst spi_sdi3_pad
selectInst spi_sdi2_pad
spaceIoInst -fixSide top -space 159


#add IO Pads
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLE -side n -row 1
setDrawView place
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLE -side s -row 1
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLE -side w -row 1
addIoFiller -cell PADSPACE_74x1u PADSPACE_74x2u PADSPACE_74x4u PADSPACE_74x8u PADSPACE_74x16u -prefix IO_FILLE -side e -row 1
deselectAll
setDrawView place
