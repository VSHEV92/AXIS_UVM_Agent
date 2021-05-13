# ------------------------------------------------------
# ----- Cкрипт для автоматического запуска тестов ------
# ------------------------------------------------------

# создаем проект
source ./tcl/create_project.tcl

# обновляем иерархию файлов проекта
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# устанавливаем максимальное время моделирования 
set_property -name {xsim.simulate.runtime} -value {100s} -objects [get_filesets sim_1]

# получаем и устанавливаем имя теста
if {$argc == 0} {
    set test_name base_test
} else {
    set test_name [lindex $argv 0]
}
set_property generic "TEST_NAME=$test_name" [get_filesets sim_1]

# запуск моделирования
launch_simulation
close_sim -quiet
    