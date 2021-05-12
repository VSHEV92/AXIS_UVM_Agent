class axis_monitor #(int TDATA_BYTES = 1) extends uvm_monitor;
    `uvm_component_utils(axis_monitor #(TDATA_BYTES))
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    
    virtual axis_if #(TDATA_BYTES) axis_if_h;
    
    uvm_analysis_port #(axis_data) analysis_port_h; 

endclass

// ---------------------------------------------------------------------
function void axis_monitor::build_phase (uvm_phase phase);
    analysis_port_h = new("analysis_port_h", this);
endfunction

task axis_monitor::run_phase (uvm_phase phase);
endtask