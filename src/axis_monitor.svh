class axis_monitor #(int TDATA_BYTES = 1) extends uvm_monitor;
    `uvm_component_utils(axis_monitor #(TDATA_BYTES))
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task get_tdata (output bit [1024-1:0] data);
    
    virtual axis_if #(TDATA_BYTES) axis_if_h;
    
    uvm_analysis_port #(axis_data) analysis_port_h; 

    axis_data axis_data_h;

endclass

// ---------------------------------------------------------------------
function void axis_monitor::build_phase (uvm_phase phase);
    analysis_port_h = new("analysis_port_h", this);
endfunction

task axis_monitor::run_phase (uvm_phase phase);
    forever begin
        axis_data_h = axis_data::type_id::create("axis_data_h");
        get_tdata(axis_data_h.tdata);
        analysis_port_h.write(axis_data_h);
    end
endtask

task axis_monitor::get_tdata (output bit [1024-1:0] data);
    forever begin
        @(posedge axis_if_h.aclk)
        if (axis_if_h.tvalid && axis_if_h.tready) begin
            data = axis_if_h.tdata;
            return;
        end
    end
endtask
