#vsim -sdfmax /tb/top_top_i=/export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5.sdf -quiet $TB
#vsim -sdfmax /tb/top_top_i=/export/space/nobackup/lu1622pe-s/etin35_project/PNR_2/top_top_pnr2_1.sdf -quiet $TB
#vsim -sdfmax /tb/top_top_i=/export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5_test.sdf -quiet $TB
set cmd "vsim -sdfmax /tb/top_top_i=/export/space/nobackup/lu1622pe-s/etin35_project/PNR_CNN/top_top_pnr_g5.sdf -quiet $TB \
  -L pulpino_lib \
  -L CORE65LPLVT \
  -L CLOCK65LPLVT \
  -L MEMORY \
  -L PADS \
  +nowarnTRAN \
  +nowarnTSCALE \
  +nowarnTFMPC \
  +notimingchecks \
  +MEMLOAD=$MEMLOAD \
  -gUSE_ZERO_RISCY=$env(USE_ZERO_RISCY) \
  -gRISCY_RV32F=$env(RISCY_RV32F) \
  -gZERO_RV32M=$env(ZERO_RV32M) \
  -gZERO_RV32E=$env(ZERO_RV32E) \
  -t ps \
  -voptargs=\"+acc -suppress 2103\" \
  $VSIM_FLAGS"

# set cmd "$cmd -sv_lib ./work/libri5cyv2sim"
eval $cmd

# check exit status in tb and quit the simulation accordingly
proc run_and_exit {} {
  run -all
  quit -code [examine -radix decimal sim:/tb/exit_status]
}
