# === NORTH ===
createPhysicalPin in_clk                    -geom M2 490 2115.5 540 2191
createPhysicalPin  in_rst_n             -geom M2 722 2115.5 772 2191
createPhysicalPin  in_testmode_i        -geom M2 954 2115.5 1004 2191
createPhysicalPin  in_fetch_enable_i    -geom M2 1186 2115.5 1236 2191
createPhysicalPin  in_spi_clk_i         -geom M2 1418 2115.5 1468 2191
createPhysicalPin  in_spi_cs_i          -geom M2 1650 2115.5 1700 2191

# === WEST ===
createPhysicalPin  in_tck_i             -geom M2 0 287 75.5 337
createPhysicalPin  in_trstn_i           -geom M2 0 548 75.5 598
createPhysicalPin  in_tms_i             -geom M2 0 809 75.5 859
createPhysicalPin  in_tdi_i             -geom M2 0 1067 75.5 1117
createPhysicalPin  in_uart_rx           -geom M2 0 1331 75.5 1381
createPhysicalPin  in_uart_cts          -geom M2 0 1592 75.5 1642
createPhysicalPin  in_uart_dsr          -geom M2 0 1853 75.5 1903

# === SOUTH ===
createPhysicalPin  out_gpio_out8            -geom M2 549 0 599 75.5
createPhysicalPin  out_tdo_o            -geom M2 810 0 860 75.5
createPhysicalPin  out_uart_tx          -geom M2 1071 0 1121 75.5
createPhysicalPin  out_uart_rts         -geom M2 1332 0 1382 75.5
createPhysicalPin  out_uart_dtr         -geom M2 1593 0 1643 75.5

# === EAST ===
createPhysicalPin  in_spi_sdi0_i        -geom M2 2115.5 414 2191 464
createPhysicalPin  in_spi_sdi1_i        -geom M2 2115.5 792 2191 842
createPhysicalPin  in_spi_sdi2_i        -geom M2 2115.5 1170 2191 1220
createPhysicalPin  in_spi_sdi3_i        -geom M2 2115.5 1359 2191 1409
createPhysicalPin  out_spi_sdo0_o       -geom M2 2115.5 225 2191 275
createPhysicalPin  out_spi_sdo1_o       -geom M2 2115.5 603 2191 653
createPhysicalPin  out_spi_sdo2_o       -geom M2 2115.5 981 2191 1031
createPhysicalPin  out_spi_sdo3_o       -geom M2 2115.5 1737 2191 1787
createPhysicalPin  out_spi_mode_o[0]    -geom M2 2115.5 1548 2191 1598
createPhysicalPin  out_spi_mode_o[1]    -geom M2 2115.5 1926 2191 1976

# === 设置 skip routing（避免 router 自动布线时误连）===
setAttribute -net in_clk               -skip_routing true
setAttribute -net in_rst_n             -skip_routing true
setAttribute -net in_testmode_i        -skip_routing true
setAttribute -net in_fetch_enable_i    -skip_routing true
setAttribute -net in_spi_clk_i         -skip_routing true
setAttribute -net in_spi_cs_i          -skip_routing true
setAttribute -net in_tck_i             -skip_routing true
setAttribute -net in_trstn_i           -skip_routing true
setAttribute -net in_tms_i             -skip_routing true
setAttribute -net in_tdi_i             -skip_routing true
setAttribute -net in_uart_rx           -skip_routing true
setAttribute -net in_uart_cts          -skip_routing true
setAttribute -net in_uart_dsr          -skip_routing true
setAttribute -net out_gpio_out8        -skip_routing true
setAttribute -net out_tdo_o            -skip_routing true
setAttribute -net out_uart_tx          -skip_routing true
setAttribute -net out_uart_rts         -skip_routing true
setAttribute -net out_uart_dtr         -skip_routing true
setAttribute -net in_spi_sdi0_i        -skip_routing true
setAttribute -net in_spi_sdi1_i        -skip_routing true
setAttribute -net in_spi_sdi2_i        -skip_routing true
setAttribute -net in_spi_sdi3_i        -skip_routing true
setAttribute -net out_spi_sdo0_o       -skip_routing true
setAttribute -net out_spi_sdo1_o       -skip_routing true
setAttribute -net out_spi_sdo2_o       -skip_routing true
setAttribute -net out_spi_sdo3_o       -skip_routing true
setAttribute -net out_spi_mode_o[0]    -skip_routing true
setAttribute -net out_spi_mode_o[1]    -skip_routing true

