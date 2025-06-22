# ALL values are in picosecond

set PERIOD 10000
set ClkTop $DESIGN
set ClkDomain $DESIGN
set Clk_jtag jtag
set Clk_spi spi

set ClkName in_clk
set ClkLatency 500
set ClkRise_uncertainty 200
set ClkFall_uncertainty 200
set ClkSlew 500
set InputDelay 500
set OutputDelay 500

# Remember to change the -port ClkxC* to the actual name of clock port/pin in your design

# ========== CLOCK DOMAIN: in_clk ==========
#$ClkLatency
define_clock -name $ClkName -period $PERIOD -design $ClkTop -domain $ClkDomain [find / -port in_clk*]

set_attribute find_takes_multiple_names true /
set_attribute clock_network_late_latency $ClkLatency $ClkName
set_attribute clock_source_late_latency  $ClkLatency $ClkName 

set_attribute clock_setup_uncertainty $ClkLatency $ClkName
set_attribute clock_hold_uncertainty $ClkLatency $ClkName 

set_attribute slew_rise $ClkRise_uncertainty $ClkName 
set_attribute slew_fall $ClkFall_uncertainty $ClkName

external_delay -input $InputDelay  -clock [find / -clock $ClkName] -name in_con_clk  [find /des* -port ports_in/in_clk]
external_delay -input $InputDelay  -clock [find / -clock $ClkName] -name in_con_rst [find /des* -port ports_in/in_rst_n]
external_delay -input $InputDelay  -clock [find / -clock $ClkName] -name in_con_fetch  [find /des* -port ports_in/in_fetch_enable_i]

external_delay -input $InputDelay  -clock [find / -clock $ClkName] -name in_con_uart_rx  [find /des* -port ports_in/in_uart_rx]
external_delay -input $InputDelay  -clock [find / -clock $ClkName] -name in_con_uart_cts  [find /des* -port ports_in/in_uart_cts]
external_delay -input $InputDelay  -clock [find / -clock $ClkName] -name in_con_uart_dsr  [find /des* -port ports_in/in_uart_dsr]


external_delay -output $OutputDelay -clock [find / -clock $ClkName] -name out_con_uart_tx [find /des* -port ports_out/out_uart_tx]
external_delay -output $OutputDelay -clock [find / -clock $ClkName] -name out_con_uart_rts [find /des* -port ports_out/out_uart_rts]
external_delay -output $OutputDelay -clock [find / -clock $ClkName] -name out_con_uart_dtr [find /des* -port ports_out/out_uart_dtr]
external_delay -output $OutputDelay -clock [find / -clock $ClkName] -name out_con_gpio8 [find /des* -port ports_out/out_gpio_out8 ]


# ========== CLOCK DOMAIN: spi_sck ==========
# SPI Slave clock
set PERIOD_SPI 100000
set ClkName_SPI clk_spi

define_clock -name $ClkName_SPI -period $PERIOD_SPI -design $ClkTop -domain $Clk_spi [find / -port in_spi_clk_i]

set_attribute clock_network_late_latency 2000 $ClkName_SPI
set_attribute clock_source_late_latency  2000 $ClkName_SPI 

set_attribute clock_setup_uncertainty 1000 $ClkName_SPI
set_attribute clock_hold_uncertainty 300 $ClkName_SPI 

set_attribute slew_rise 500 $ClkName_SPI 
set_attribute slew_fall 500 $ClkName_SPI

#set_input_transition 500 [find / -port ports_in/spi*]
external_delay -input 2000  -clock [find / -clock $ClkName_SPI] -name in_con_spi  [find /des* -port ports_in/in_spi*]
external_delay -output 2000 -clock [find / -clock $ClkName_SPI] -name out_con_spi [find /des* -port ports_out/out_spi*]


# ========== CLOCK DOMAIN: jtag_tck ==========
# JTAG clock
set PERIOD_JTAG 100000
set ClkName_JTAG clk_jtag

define_clock -name $ClkName_JTAG -period $PERIOD_JTAG -design $ClkTop -domain $Clk_jtag [find / -port in_tck_i]

set_attribute clock_network_late_latency 2000 $ClkName_JTAG
set_attribute clock_source_late_latency  2000 $ClkName_JTAG 

set_attribute clock_setup_uncertainty 1000 $ClkName_JTAG
set_attribute clock_hold_uncertainty 300 $ClkName_JTAG

set_attribute slew_rise 500 $ClkName_JTAG 
set_attribute slew_fall 500 $ClkName_JTAG

#set_input_transition 500 [find / -port ports_in/jtag*]
external_delay -input 2000  -clock [find / -clock $ClkName_JTAG] -name in_con_jtag  [find /des* -port ports_in/in_t*]
external_delay -output 2000 -clock [find / -clock $ClkName_JTAG] -name out_con_jtag [find /des* -port ports_out/out_t*]



#set_input_transition 500 [find / -port fetch_enable]
#set_input_transition 500 [find / -port uart_rx]
#set_input_transition 500 [find / -port s_rst_n]

set_clock_groups -asynchronous -group $ClkName -group $ClkName_SPI -group $ClkName_JTAG
