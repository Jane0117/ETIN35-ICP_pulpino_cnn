# 禁用 IO flow 引导
setIoFlowFlag 0
#
# # Floorplan 设置
fpiSetSnapRule -grid MG -for DIE 
fpiSetSnapRule -grid MG -for CORE 
floorPlan -site CORE -s 1800.0 1800.0 20.0 20.0 20.0 20.0
#floorplan -site CORE -coreMarginsBy die -s 1800.0 1800.0 20.0 20.0 20.0 20.0
#
# #######################################################
# # SRAM 宏块布局（data_mem 区域）
# #######################################################
#
setObjFPlanBox Instance top_inst_core_region_i/data_mem/sp_ram_i_four_sram_wrapper0/sram_inst0 160.222 1724.084 263.422 1894.284

set SRAM_data_MACRO [dbGet top.insts.name */data_mem/sp_ram_i_four_sram_wrapper*/sram_inst*];

for {set i 1} {$i <= 15} {incr i} {
        set prev [expr {$i - 1}]
        set idx [expr {$i}]
        create_relative_floorplan -place [lindex $SRAM_data_MACRO $i]  -orient R0 -ref_type object -ref [lindex $SRAM_data_MACRO $prev] -bbox both -horizontal_edge_separate {2 0 2} -vertical_edge_separate {3 0 1}
        puts "Placed SRAM_instr_MACRO($i)"
    }

# #######################################################
# # SRAM 宏块布局（instr_mem 区域）
# #######################################################
#
setObjFPlanBox Instance top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper0/sram_inst0 116.862 96.475 220.062 266.675

placeInstance top_inst_core_region_i/instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper0/sram_inst0 116.862 96.475 R180

set SRAM_instr_MACRO [dbGet top.insts.name */instr_mem/sp_ram_wrap_i_sp_ram_i_four_sram_wrapper*/sram_inst*];
lappend SRAM_instr_MACRO "top_inst_peripherals_i/mmu_wrapper_read_i/u_ofm/u_sram";

for {set i 1} {$i <= 16} {incr i} {
        set prev [expr {$i - 1}]
        set idx [expr {$i}]
        create_relative_floorplan -place [lindex $SRAM_instr_MACRO $i]  -orient R180 -ref_type object -ref [lindex $SRAM_instr_MACRO $prev] -bbox both -horizontal_edge_separate {2 0 2} -vertical_edge_separate {3 0 1}
        puts "Placed SRAM_instr_MACRO($i)"
    }
#

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
    top_inst_peripherals_i/mmu_wrapper_read_i/u_ofm/u_sram
} {
    selectInst $inst
}
cutRow -selected
