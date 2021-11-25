// master driver
class axis_driver_master #(int TDATA_BYTES = 1) extends uvm_driver #(axis_data);
    `uvm_component_param_utils(axis_driver_master #(TDATA_BYTES))
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern task run_phase (uvm_phase phase);
    
    virtual axis_if #(TDATA_BYTES) axis_if_h;

    axis_data axis_data_h;

endclass

task axis_driver_master::run_phase (uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(axis_data_h);
        axis_if_h.write(axis_data_h.tdata, axis_data_h.clock_before_tvalid);
        seq_item_port.item_done();
    end
endtask



// slave driver
class axis_driver_slave #(int TDATA_BYTES = 1) extends uvm_driver #(axis_data);
    `uvm_component_param_utils(axis_driver_slave #(TDATA_BYTES))
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern task run_phase (uvm_phase phase);

    virtual axis_if #(TDATA_BYTES) axis_if_h;

    axis_data axis_data_h;
    
endclass

task axis_driver_slave::run_phase (uvm_phase phase);
    forever begin
        bit [TDATA_BYTES*8-1:0] data;
        seq_item_port.get_next_item(axis_data_h);
        axis_if_h.read(data, axis_data_h.clock_before_tready);
        seq_item_port.item_done();
    end
endtask

