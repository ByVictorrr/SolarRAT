vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../SolarRAT_Driver.srcs/sources_1/ip/photoresistor_xadc/photoresistor_xadc.v" \


vlog -work xil_defaultlib \
"glbl.v"

