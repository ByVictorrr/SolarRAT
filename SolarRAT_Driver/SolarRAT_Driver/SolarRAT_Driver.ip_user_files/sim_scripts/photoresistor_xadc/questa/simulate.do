onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib photoresistor_xadc_opt

do {wave.do}

view wave
view structure
view signals

do {photoresistor_xadc.udo}

run -all

quit -force
