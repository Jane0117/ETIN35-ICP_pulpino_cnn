#OCV setting
setAnalysisMode -analysisType onChipVariation -cppr both
#report timing
group_path   -name In2Reg       -from  $inp -to $allregs
group_path   -name Reg2Out      -from $allregs -to $outp
group_path   -name Reg2Reg      -from $regs -to $regs

redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -slackReports -numPaths 50 -prefix top_top_postRoute -outDir timingReports
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix top_top_postRoute -outDir timingReports

#optimize
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute -hold
setOptMode -reset
setOptMode  -effort high \
            -leakagePowerEffort none \
            -dynamicPowerEffort none \
            -reclaimArea true \
            -simplifyNetlist true \
            -allEndPoints false \
            -setupTargetSlack 0.05 \
            -holdTargetSlack 0.15 \
            -maxDensity 0.9 \
            -drcMargin 0.5 
setOptMode -usefulSkew true
setOptMode -fixHoldAllowSetupTnsDegrade false
setOptMode -fixFanoutLoad true -fixTran true -fixCap true -fixDRC true
 setOptMode -holdFixingEffort high 
 setOptMode -holdSlackFixingThreshold 0.15

#####not working#####
ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_w_buffer_i/buffer_i_cg_cell/FE_PHN14809_clk_en \
               -cell HS65_LL_IVX4 -relativeDistToSink 0.1 \
               -name hold_buf_1 -newNetName 1_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_w_buffer_i/buffer_i_cg_cell/FE_PHN14809_clk_en \
               -cell HS65_LL_AND2X8 -relativeDistToSink 0.1 \
               -name hold_buf_1_1 -newNetName 1_1_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_aw_buffer_i/FE_PHN15372_buffer_i_cg_cell_clk_en \
               -cell HS65_LL_IVX4 -relativeDistToSink 0.1 \
               -name hold_buf_2 -newNetName 2_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_aw_buffer_i/FE_PHN15372_buffer_i_cg_cell_clk_en \
               -cell HS65_LL_AND2X8 -relativeDistToSink 0.1 \
               -name hold_buf_2 -newNetName 2_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_ar_buffer_i/buffer_i_cg_cell/FE_PHN14785_clk_en \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_2_2 -newNetName 2_2_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_ar_buffer_i/buffer_i_cg_cell/FE_PHN14785_clk_en \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_2_3 -newNetName 2_3_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_ar_buffer_i/buffer_i_cg_cell/FE_PHN14785_clk_en \
               -cell HS65_LL_CNBFX41 -relativeDistToSink 0.1 \
               -name hold_buf_2_5 -newNetName 2_5_fixed
####checking reports the violation net changes each time
ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_aw_buffer_i/FE_ECON73265_FE_PHN15372_buffer_i_cg_cell_clk_en \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_3_1 -newNetName 3_1_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_w_buffer_i/buffer_i_cg_cell/CTS_129_fixed \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_4_1 -newNetName 4_1_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_aw_buffer_i/3_1_fixed \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_5_1 -newNetName 5_1_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_w_buffer_i/buffer_i_cg_cell/4_1_fixed \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_6_1 -newNetName 6_1_fixed

ecoAddRepeater -net top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_aw_buffer_i/5_1_fixed \
               -cell HS65_LL_CNBFX55 -relativeDistToSink 0.1 \
               -name hold_buf_7_1 -newNetName 7_1_fixed





selectPin top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_w_buffer_i/buffer_i_cg_cell/g14/A
ecoRoute

selectPin top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_ar_buffer_i/buffer_i_cg_cell/g14/A 
ecoRoute

selectPin top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_w_buffer_i/buffer_i_cg_cell/g14/A 
ecoRoute

ecoAddRepeater - term top_inst_core_region_i/axi_slice_core2axi/WITH_SLICE.axi_slice_i_aw_buffer_i/buffer_i_cg_cell_g14/A \
              -cell{ HS65_LL_BFX106 HS65_LL_BFX13 HS65_LL_BFX142 HS65_LL_BFX18 HS65_LL_BFX2 HS65_LL_BFX213 HS65_LL_BFX22 HS65_LL_BFX27 HS65_LL_BFX284 HS65_LL_BFX31 HS65_LL_BFX35 HS65_LL_BFX4 HS65_LL_BFX40 HS65_LL_BFX44 HS65_LL_BFX49 HS65_LL_BFX53 HS65_LL_BFX62 HS65_LL_BFX7 HS65_LL_BFX71 HS65_LL_BFX9 HS65_LL_BFX106 HS65_LL_BFX13 HS65_LL_BFX142 HS65_LL_BFX18 HS65_LL_BFX2 HS65_LL_BFX213 HS65_LL_BFX22 HS65_LL_BFX27 HS65_LL_BFX284 HS65_LL_BFX31 HS65_LL_BFX35 HS65_LL_BFX4 HS65_LL_BFX40 HS65_LL_BFX44 HS65_LL_BFX49 HS65_LL_BFX53 HS65_LL_BFX62 HS65_LL_BFX7 HS65_LL_BFX71 HS65_LL_BFX9 HS65_LL_BFX106 HS65_LL_BFX13 HS65_LL_BFX142 HS65_LL_BFX18 HS65_LL_BFX2 HS65_LL_BFX213 HS65_LL_BFX22 HS65_LL_BFX27 HS65_LL_BFX284 HS65_LL_BFX31 HS65_LL_BFX35 HS65_LL_BFX4 HS65_LL_BFX40 HS65_LL_BFX44 HS65_LL_BFX49 HS65_LL_BFX53 HS65_LL_BFX62 HS65_LL_BFX7 HS65_LL_BFX71 HS65_LL_BFX9 HS65_LL_BFX106 HS65_LL_BFX13 HS65_LL_BFX142 HS65_LL_BFX18 HS65_LL_BFX2 HS65_LL_BFX213 HS65_LL_BFX22 HS65_LL_BFX27 HS65_LL_BFX284 HS65_LL_BFX31 HS65_LL_BFX35 HS65_LL_BFX4 HS65_LL_BFX40 HS65_LL_BFX44 HS65_LL_BFX49 HS65_LL_BFX53 HS65_LL_BFX62 HS65_LL_BFX7 HS65_LL_BFX71 HS65_LL_BFX9  }\
              -relativeDistToSink 0.5

#write_sdf -version 3.0 top_top_pnr2.sdf -map_file /usr/local-eit/cad2/cmpstm/oldmems/mem2010/SPHDL100909-40446@1.0/behaviour/verilog/SPHDL100909.verilog.map /usr/local-eit/cad2/cmpstm/oldmems/mem2010/SPHDL100909-40446@1.0/behaviour/verilog/SPHDL100909_allpins.v -precision 4 -min_view FF -max_view SS

write_sdf -version 3.0 top_top_pnr1.sdf -map_file {/usr/local-eit/cad2/cmpstm/oldmems/mem2010/SPHDL100909-40446@1.0/behaviour/verilog/SPHDL100909.verilog.map , /usr/local-eit/cad2/cmpstm/oldmems/mem2010/SPHDL100909-40446@1.0/behaviour/verilog/SPHDL100909_allpins.v} -precision 4 -min_view FF -max_view SS

#write_sdf -version 3.0 MATRIX_PNR.sdf -map_file /usr/local-eit/cad2/cmpstm/oldmems/mem2011/SPHD110420-48158@1.0/behaviour/verilog/SPHD110420.verilog.map -precision 4 -min_view FF -max_view SS
#write_sdf -version 2.1 MATRIX_PNR.sdf -map_file /usr/local-eit/cad2/cmpstm/oldmems/mem2011/SPHD110420-48158@1.0/behaviour/verilog/SPHD110420.verilog.map -precision 4 -min_view FF -max_view SS
