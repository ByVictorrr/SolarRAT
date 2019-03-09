vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../SolarRAT_Driver.srcs/sources_1/ip/photoresistor_xadc/photoresistor_xadc.v" \


vlog -work xil_defaultlib \
"glbl.v"

