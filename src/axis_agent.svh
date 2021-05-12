typedef enum {MASTER, SLAVE} agent_type_t;


class axis_agent #(int TDATA_BYTES = 1) extends uvm_agent;

    `uvm_component_utils(axis_agent #(TDATA_BYTES))
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    
    agent_type_t agent_type = MASTER; 

    virtual axis_if #(TDATA_BYTES) axis_if_h;

    axis_sequencer axis_sequencer_h;
    axis_driver_master #(TDATA_BYTES) axis_driver_m_h;
    axis_driver_slave #(TDATA_BYTES) axis_driver_s_h;
    axis_monitor #(TDATA_BYTES) axis_monitor_h;

endclass 

// ---------------------------------------------------------------------
function void axis_agent::build_phase (uvm_phase phase);

    axis_sequencer_h = axis_sequencer::type_id::create("axis_sequencer_h", this); 

    axis_monitor_h = axis_monitor #(TDATA_BYTES)::type_id::create("axis_monitor_h", this);
    axis_monitor_h.axis_if_h = this.axis_if_h;
    
    if (agent_type == MASTER) begin 
        axis_driver_m_h = axis_driver_master #(TDATA_BYTES)::type_id::create("axis_driver_m_h", this);
        axis_driver_m_h.axis_if_h = this.axis_if_h;
    end 
    else begin
        axis_driver_s_h = axis_driver_slave #(TDATA_BYTES)::type_id::create("axis_driver_s_h", this);
        axis_driver_s_h.axis_if_h = this.axis_if_h;
    end

endfunction

function void axis_agent::connect_phase (uvm_phase phase);
    if (agent_type == MASTER)
        axis_driver_m_h.seq_item_port.connect(axis_sequencer_h.seq_item_export);
    else
        axis_driver_s_h.seq_item_port.connect(axis_sequencer_h.seq_item_export);
endfunction
