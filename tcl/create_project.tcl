# ------------------------------------------------------
# ---- Cкрипт для автоматического создания проекта -----
# ------------------------------------------------------

# -----------------------------------------------------------
set Project_Name axis_agent_test

# если проект с таким именем существует удаляем его
close_project -quiet
if { [file exists $Project_Name] != 0 } { 
	file delete -force $Project_Name
}

# создаем проект
create_project $Project_Name ./$Project_Name -part xcku060-ffva1156-2-e

# добавляем исходники axis_agent к проекту
add_files [glob -nocomplain -- ./src/*.svh]
add_files [glob -nocomplain -- ./src/*.sv]

# добавляем файлы тестового окружения к проекту
add_files [glob -nocomplain -- ./example_env/*.svh]
add_files ./example_env/test_pkg.sv
add_files -fileset sim_1 ./example_env/top_tb.sv

# если папка уже существует удаляем её
if { [file exists IPs] != 0 } { 
	file delete -force IPs
	file mkdir IPs
} else {
    file mkdir IPs
}

# создание ядра комплексного умножителя, которое будет тестироваться
create_ip -name cmpy -vendor xilinx.com -library ip -version 6.0 -module_name cmpy_0 -dir ./IPs
set_property -dict [list CONFIG.FlowControl {Blocking} CONFIG.MinimumLatency {9}] [get_ips cmpy_0]
generate_target {instantiation_template} [get_files ./IPs/cmpy_0/cmpy_0.xci]
generate_target {simulation} [get_files ./IPs/cmpy_0/cmpy_0.xci]

# подключение uvm библиотек к проекту
set_property -name {xsim.compile.xvlog.more_options} -value {-L uvm} -objects [get_filesets sim_1]
set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]