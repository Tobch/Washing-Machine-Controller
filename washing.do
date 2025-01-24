vlib work
vlog washing_machine_controller.v washing_machine_tb.v +cover -covercells
vsim -voptargs=+acc work.tb_washing_machine_controller -cover
add wave -r /*
coverage save machine.ucdb -onexit
run -all

