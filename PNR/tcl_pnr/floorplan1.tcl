# 禁用 IO flow 引导
setIoFlowFlag 0
#
# # Floorplan 设置
fpiSetSnapRule -grid MG -for DIE 
fpiSetSnapRule -grid MG -for CORE 
floorPlan -site CORE -s 1450.0 1500.0 20.0 20.0 20.0 20.0
#
# #######################################################
# # SRAM 宏块布局（data_mem 区域）
# #######################################################
#R
setObjFPlanBox Instance top_inst_core_region_i/data_mem/sp_ram_i_four_sram_wrapper0/sram_inst0 95.751 1424.738 198.951 1594.938

set SRAM_data_MACRO [dbGet top.insts.name */data_mem/sp_ram_i_four_sram_wrapper*/sram_inst*];

for {set i 1} {$i <= 13} {incr i} {
        set prev [expr {$i - 1}]
        set idx [expr {$i}]
        create_relative_floorplan -place [lindex $SRAM_data_MACRO $i]  -orient R0 -ref_type object -ref [lindex $SRAM_data_MACRO $prev] -bbox both -horizontal_edge_separate {0 0 0} -vertical_edge_separate {3 0 1}
        puts "Placed SRAM_instr_MACRO($i)"
    }

placeInstance top_inst_core_region_i/data_mem/sp_ram_i_four_sram_wrapper3/sram_inst2 3395.4 0.0 R90
pan 553.035 -506.949

setObjFPlanBox Instance top_inst_core_region_i/data_mem/sp_ram_i_four_sram_wrapper3/sram_inst2 95.817 748.48 266.017 851.68

create_relative_floorplan -place [lindex $SRAM_data_MACRO 15]  -orient R90 -ref_type object -ref [lindex $SRAM_data_MACRO 14] -bbox both -horizontal_edge_separate {1 0 3} -vertical_edge_separate {0 0 0}



# #######################################################
# # SRAM 宏块布局（instr_mem 区域）
# #######################################################
#
setObjFPlanBox Instance top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper0/sram_inst0 1441.55 96.022 1544.75 266.222

placeInstance top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper0/sram_inst0 1441.55 96.02 R180

set SRAM_instr_MACRO [dbGet top.insts.name */instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper*/sram_inst*];

for {set i 1} {$i <= 13} {incr i} {
        set prev [expr {$i - 1}]
        set idx [expr {$i}]
        create_relative_floorplan -place [lindex $SRAM_instr_MACRO $i]  -orient R180 -ref_type object -ref [lindex $SRAM_instr_MACRO $prev] -bbox both -horizontal_edge_separate {0 0 0} -vertical_edge_separate {-3 0 -1}
        puts "Placed SRAM_instr_MACRO($i)"
    }
#
selectInst top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper3/sram_inst2
placeInstance top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper3/sram_inst2 1744.2 0.0 R270

setObjFPlanBox Instance top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper3/sram_inst2 1372.203 744.818 1542.403 848.018

create_relative_floorplan -place [lindex $SRAM_instr_MACRO 15]  -orient R270 -ref_type object -ref [lindex $SRAM_instr_MACRO 14] -bbox both -horizontal_edge_separate {1 0 3} -vertical_edge_separate {0 0 0}

#######################################################
# Halo设置和布局初始化
#######################################################
addHaloToBlock {10 10 10 10} -allBlock

#######################################################
# Step 1: 选中所有宏块并清除原有 row（cutRow）
#######################################################
foreach inst {
    top_inst_core_region_i/data_mem/sp_ram_i_four_sram_wrapper*/sram_inst*
    top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper*/sram_inst*
} {
    selectInst $inst
}
cutRow -selected
