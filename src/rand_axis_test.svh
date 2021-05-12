class rand_axis_test extends uvm_test;

    `uvm_component_utils(rand_axis_test)
    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    test_env test_env_h; 

endclass

// --------------------------------------------------------------------
function void rand_axis_test::build_phase(uvm_phase phase);
    test_env_h = test_env::type_id::create("test_env_h", this);   
endfunction

task rand_axis_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
        #10;
        fork
            test_env_h.axis_seqc_in_1.start(test_env_h.axis_agent_in_1.axis_sequencer_h);
            test_env_h.axis_seqc_in_2.start(test_env_h.axis_agent_in_2.axis_sequencer_h); 
            test_env_h.axis_seqc_out.start(test_env_h.axis_agent_out.axis_sequencer_h);  
        join  
    phase.drop_objection(this);
endtask
