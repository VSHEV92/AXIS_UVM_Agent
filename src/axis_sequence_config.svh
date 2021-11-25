class axis_sequence_config extends uvm_object;
    
    `uvm_object_utils(axis_sequence_config)
    function new (string name = "");
        super.new(name);
    endfunction
    
    int unsigned trans_numb = 100; // number of transactions
    bit from_file = 0;     // get data from file
    string file_name = ""; // file name

    int unsigned max_clock_before_tvalid = 5; // maximum number of ticks before set tvalid
    int unsigned min_clock_before_tvalid = 0; // minimum number of ticks before set tvalid
    int unsigned max_clock_before_tready = 5; // maximum number of ticks before set tready
    int unsigned min_clock_before_tready = 0; // minimum number of ticks before set tready
    int unsigned max_tdata = 255;  // maximum value of tdata
    int unsigned min_tdata = 0;    // minimum value of tdata

endclass