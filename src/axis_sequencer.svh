class axis_sequencer extends uvm_sequencer #(axis_data);
    `uvm_component_utils(axis_sequencer)
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass