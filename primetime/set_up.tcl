####----------------------------------------------------------####
# Title : primeTime Sample Script
# Project : IC Project 1
####----------------------------------------------------------####
# File : ptime.tcl
# Module Name :
# Project Root :
# Author : Masoud Nouripayam (ma1570no@eit.lth.se)
# Company : Digital ASIC Group, EIT, LTH, Lund University
# Created : 2020-03-02
# Last Edit :
# version : 1
####----------------------------------------------------------####
# Description :
####----------------------------------------------------------####
################## remove any previous designs
#remove_design -all
################### set up power analysis mode #####################
# step 0: Define Top Module name
set TOP top_top
################### set up power analysis mode #####################
# step 1: enalbe analysis mode
set power_enable_analysis true
set power_analysis_mode time_based
##set power_analysis_mode averaged
##set power_analysis_mode vfra
####################### set up libaries ############################
# step 2: link to your design libary
### Make sure you choose the same files and paths as you have used in
### synthesis and pnr stage
##    /usr/local-eit/cad2/cmpstm/oldmems/mem2010/SPHDL100909-40446@1.0/ccs \

set search_path "\
/usr/local-eit/cad2/cmpstm/stm065v536/CORE65LPLVT_5.1/ccs \
/usr/local-eit/cad2/cmpstm/stm065v536/CORE65LPLVT_5.1/libs \
    /usr/local-eit/cad2/cmpstm/stm065v536/CLOCK65LPLVT_3.1/ccs \
    /usr/local-eit/cad2/cmpstm/oldmems/mem2010/SPHDL100909-40446@1.0/libs \
    /usr/local-eit/cad2/cmpstm/dicp18/lu_pads_65nm"

set link_path "* \
CORE65LPLVT_nom_1.20V_25C.db \
    CLOCK65LPLVT_nom_1.20V_25C.db \
    SPHDL100909_nom_1.20V_25C.db \
    Pads_Oct2012.db "
####################### design input ############################
# step 3: read your design (netlist) & link design
#read_verilog /export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_test.v
read_verilog /export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5.v
#read_verilog /export/space/nobackup/lu1622pe-s/etin35_project/primetime/VT1_POWER/top_top.v
current_design $TOP
link_design -force
####################### timing constraint ##########################
# step 4: setup timing constraint (or read sdc file)
read_sdc -version 1.7 /export/space/nobackup/lu1622pe-s/etin35_project/synthesis_cnn/outputs/top_top_pt.sdc
#read_sdc -version 1.7 /export/space/nobackup/lu1622pe-s/etin35_project/primetime/VT1_POWER/Clock_Contrains.sdc
####################### Back annotate ##########################
# step 5: back annotate delay information (read sdf file)
#read_parasitics /export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_FF_test.spef
#read_sdf -type sdf_max /export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5_pt_test.sdf
read_parasitics /export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5_FF.spef
read_sdf -type sdf_max /export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5_pt.sdf
#read_parasitics /export/space/nobackup/lu1622pe-s/etin35_project/primetime/VT1_POWER/top_top_SS.spef
#read_sdf -type sdf_max /export/space/nobackup/lu1622pe-s/etin35_project/primetime/VT1_POWER/file1.sdf
####################### ignore clock gating ##########################
#set_false_path -through [get_cell top_inst_peripherals_i/genblk1[2].core_clock_gate/clk_en_reg]
#set_false_path -through [get_cell top_inst_core_region_i/CORE.RISCV_CORE/core_clock_gate_i/clk_en_reg]
#set_false_path -through [get_cell top_inst_peripherals_i/genblk1[0].core_clock_gate/clk_en_reg]
#set_false_path -through [get_cell top_inst_peripherals_i/genblk1[5].core_clock_gate/clk_en_reg]
#set_false_path -through [get_cell top_inst_peripherals_i/genblk1[1].core_clock_gate/clk_en_reg]
#set_false_path -through [get_cell top_inst_peripherals_i/axi2apb_i/genblk1.axi2apb_i_Slave_w_buffer/buffer_i_cg_cell/clk_en_reg]
#set_disable_clock_gating_check [get_cell top_inst_peripherals_i/genblk1[1].core_clock_gate/clk_en_reg]
#set_disable_clock_gating_check [get_cell top_inst_peripherals_i/axi2apb_i/genblk1.axi2apb_i_Slave_w_buffer/buffer_i_cg_cell/clk_en_reg]

################# read switching activity file #####################
# step 6: read vcd file obtained from post-layout (syn) simulation
#read_vcd -strip_path "/tb/top_top_i" /export/space/nobackup/lu1622pe-s/etin35_project/pulpino/sw/build/apps/cnn_test/cnn_pulp.vcd
read_vcd -strip_path "tb/top_top_i" "/export/space/nobackup/lu1622pe-s/etin35_project/pulpino/sw/build/apps/cnn_test/conv_pulpino_all.vcd"
#read_vcd -strip_path "tb/top_top_i" "/export/space/nobackup/lu1622pe-s/etin35_project/pulpino/sw/build/apps/helloworld/clk_test1.vcd"
report_switching_activity
#read_vcd -strip_path "/top_tb/top_top" /export/space/nobackup/lu1622pe-s/etin35_project/primetime/VT1_POWER/wave.vcd
####################### analysis and report #################
# step 7: Analysis the power
check_power
update_power
####################### report #################
# step 8: output report
report_power -verbose -hierarchy > /export/space/nobackup/lu1622pe-s/etin35_project/primetime/reports/power_conv_pulpino_hierachy.rpt
report_timing -delay_type min -max_paths 10 > /export/space/nobackup/lu1622pe-s/etin35_project/primetime/reports/timing_hold_cnn_pulp_FF.rpt
report_timing -delay_type max -max_paths 10 > /export/space/nobackup/lu1622pe-s/etin35_project/primetime/reports/timing_setup_cnn_pulp_FF.rpt
