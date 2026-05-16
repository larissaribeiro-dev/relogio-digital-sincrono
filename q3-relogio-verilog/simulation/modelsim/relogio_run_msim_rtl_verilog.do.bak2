transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/CD4510B.v}
vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/mux2_1.v}
vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/ffjk.v}
vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/decodificador_7seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/CD4024B.v}
vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/divisor_frequencia.v}
vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/relogio.v}

vlog -vlog01compat -work work +incdir+C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus {C:/Users/jp_da/Downloads/eletrica/ED2/Projetos/Lista1/Quartus/tb_relogio.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_relogio

add wave *
view structure
view signals
run -all
