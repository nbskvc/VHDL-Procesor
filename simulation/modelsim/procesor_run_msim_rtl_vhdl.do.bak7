transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/ALU.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/control_unit.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/counter.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/decoder3to8.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/memory.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/multiplexer.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/nbit_register.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/program_counter.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/lprs_processor.vhd}
vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/top.vhd}

vcom -93 -work work {C:/Users/Korisnik/Desktop/lprs_procesor_v2/top_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  top_tb

add wave *
view structure
view signals
run -all
