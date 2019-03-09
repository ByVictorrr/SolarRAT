vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../SolarRAT_Driver.srcs/sources_1/ip/photoresistor_xadc/photoresistor_xadc.v" \


vlog -work xil_defaultlib \
"glbl.v"

