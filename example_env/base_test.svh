class base_test extends uvm_test;

    `uvm_component_utils(base_test)
    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    extern task shutdown_phase(uvm_phase phase);
    extern function string find_file_path(string file_full_name);

    test_env test_env_h; 

    axis_sequence axis_seqc_in_1;
    axis_sequence axis_seqc_in_2;
    axis_sequence axis_seqc_out;

    axis_sequence_config axis_seqc_in_1_config;
    axis_sequence_config axis_seqc_in_2_config;
    axis_sequence_config axis_seqc_out_config;

endclass

// --------------------------------------------------------------------
function void base_test::build_phase(uvm_phase phase);
    
    axis_seqc_in_1 = axis_sequence::type_id::create("axis_seqc_in_1", this);
    axis_seqc_in_2 = axis_sequence::type_id::create("axis_seqc_in_2", this);
    axis_seqc_out = axis_sequence::type_id::create("axis_seqc_out", this);

    test_env_h = test_env::type_id::create("test_env_h", this);   

    axis_seqc_in_1_config = axis_sequence_config::type_id::create("axis_seqc_in_1_config");
    axis_seqc_in_2_config = axis_sequence_config::type_id::create("axis_seqc_in_2_config");
    axis_seqc_out_config = axis_sequence_config::type_id::create("axis_seqc_out_config");

    axis_seqc_in_1.axis_seqc_config = axis_seqc_in_1_config;
    axis_seqc_in_2.axis_seqc_config = axis_seqc_in_2_config;
    axis_seqc_out.axis_seqc_config = axis_seqc_out_config;
     
endfunction

task base_test::main_phase(uvm_phase phase);
    phase.raise_objection(this);
        fork
            axis_seqc_in_1.start(test_env_h.axis_agent_in_1.axis_sequencer_h);
            axis_seqc_in_2.start(test_env_h.axis_agent_in_2.axis_sequencer_h); 
            axis_seqc_out.start(test_env_h.axis_agent_out.axis_sequencer_h);  
        join  
    phase.drop_objection(this);
endtask

task base_test::shutdown_phase(uvm_phase phase);
    phase.raise_objection(this);
        #100;    
    phase.drop_objection(this);
endtask

// функция для поиска пути расположения тестового файла
function string base_test::find_file_path(string file_full_name);
    int str_len = file_full_name.len();
    str_len--;
    while (file_full_name.getc(str_len) != "/") begin
        str_len--;
    end
    return file_full_name.substr(0, str_len); 
endfunction