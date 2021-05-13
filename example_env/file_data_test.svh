class file_data_test extends base_test;

    `uvm_component_utils(file_data_test)
    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    
endclass

// --------------------------------------------------------------------
function void file_data_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    axis_seqc_in_1_config.from_file = 1;
    axis_seqc_in_1_config.file_name = {find_file_path(`__FILE__), "data.txt"};

    axis_seqc_in_1_config.trans_numb = 100;
    axis_seqc_in_2_config.trans_numb = 100;
    axis_seqc_out_config.trans_numb = 100;

    axis_seqc_in_1_config.max_clock_before_tvalid = 1;
    axis_seqc_in_2_config.max_clock_before_tvalid = 0;
    axis_seqc_out_config.max_clock_before_tready = 2;     
endfunction