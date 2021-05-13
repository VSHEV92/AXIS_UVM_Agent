class axis_sequence_config extends uvm_object;
    
    `uvm_object_utils(axis_sequence_config)
    function new (string name = "");
        super.new(name);
    endfunction
    
    int unsigned trans_numb = 100; // число транзакций
    bit from_file = 0; // брать данные из файла
    string file_name = ""; // имя файла с данными

    int unsigned max_clock_before_tvalid = 5; // максимальное число тактов до установки tvalid
    int unsigned min_clock_before_tvalid = 0; // минимальное число тактов до установки tvalid
    int unsigned max_clock_before_tready = 5; // максимальное число тактов до установки tready
    int unsigned min_clock_before_tready = 0; // минимальное число тактов до установки tready
    int unsigned max_tdata = 255;  // максимальное значение tdata
    int unsigned min_tdata = 0;    // минимальное значение tdata

endclass