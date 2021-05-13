------

### AXIS_UVM_Agent

UVM агент для верификации ядер с AXI-Stream интерфейсом

------

#### Иерархия файлов

- example_env - пример окружения и тестов с использованием агента
- src - исходные файлы агента
- tcl - скрипты для запуска тестов

------

#### Создание проекта

Необходимо запустить Vivado Tcl Shell, перейти в директорию, где расположен README файл, и запустить скрипт с помощью представленного ниже выражения:

```
vivado -mode batch –source tcl/create_project.tcl -notrace
```

Будет создан проект, в который добавлены все необходимые исходники.

------

#### Запуск тестов
Необходимо запустить Vivado Tcl Shell, перейти в директорию, где расположен README файл, и запустить скрипты с помощью представленных ниже выражений:

- Запуск базового теста (base_test.svh):

```
  vivado -mode batch –source tcl/run_test.tcl -notrace
```
- Запуск теста с конфигурированным sequence (rand_data_test.svh):

```
  vivado -mode batch –source tcl/run_test.tcl -tclargs rand_data_test -notrace
```

- Запуск теста со считыванием данных из файла (file_data_test.svh):

```
  vivado -mode batch –source tcl/run_test.tcl -tclargs file_data_test -notrace
```

------

