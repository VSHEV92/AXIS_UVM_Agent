`uvm_analysis_imp_decl(_in_1)
`uvm_analysis_imp_decl(_in_2)
`uvm_analysis_imp_decl(_out)

class test_scoreboard #(int TDATA_BYTES = 1) extends uvm_scoreboard;
    `uvm_component_param_utils(test_scoreboard #(TDATA_BYTES))
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    extern function void build_phase (uvm_phase phase);

    extern virtual function void write_in_1 (axis_data axis_data_h);
    extern virtual function void write_in_2 (axis_data axis_data_h);
    extern virtual function void write_out (axis_data axis_data_h);
    
    uvm_analysis_imp_in_1 #(axis_data, test_scoreboard #(TDATA_BYTES)) analysis_port_in_1;
    uvm_analysis_imp_in_2 #(axis_data, test_scoreboard #(TDATA_BYTES)) analysis_port_in_2;
    uvm_analysis_imp_out #(axis_data, test_scoreboard #(TDATA_BYTES)) analysis_port_out;

    bit [8*TDATA_BYTES-1:0] axis_data_q_in_1[$];
    bit [8*TDATA_BYTES-1:0] axis_data_q_in_2[$];
    
endclass

// -------------------------------------------------------------------
function void test_scoreboard::build_phase (uvm_phase phase);
    analysis_port_in_1 = new("analysis_port_in_1", this);
    analysis_port_in_2 = new("analysis_port_in_2", this);
    analysis_port_out = new("analysis_port_out", this);
endfunction

function void test_scoreboard::write_in_1 (axis_data axis_data_h);
    axis_data_q_in_1.push_back(axis_data_h.tdata);
endfunction

function void test_scoreboard::write_in_2 (axis_data axis_data_h);
    axis_data_q_in_2.push_back(axis_data_h.tdata);
endfunction

function void test_scoreboard::write_out (axis_data axis_data_h);
    bit result;
    
    bit [8*TDATA_BYTES-1:0] data_in_1;
    bit [8*TDATA_BYTES-1:0] data_in_2;
    bit [8*(2*TDATA_BYTES+2)-1:0] data_out;

    bit [8*TDATA_BYTES/2-1:0] data_in_1_i, data_in_1_q, data_in_2_i, data_in_2_q;
    bit [8*(TDATA_BYTES+1)-1:0] data_out_i, data_out_q, data_out_i_gold, data_out_q_gold;

    data_in_1 = axis_data_q_in_1.pop_front();
    data_in_2 = axis_data_q_in_2.pop_front();
    data_out = axis_data_h.tdata;

    // ------------------------------------------------------------------
    data_in_1_i = data_in_1[8*TDATA_BYTES/2-1:0];
    data_in_1_q = data_in_1[8*TDATA_BYTES-1:8*TDATA_BYTES/2];
    
    data_in_2_i = data_in_2[8*TDATA_BYTES/2-1:0];
    data_in_2_q = data_in_2[8*TDATA_BYTES-1:8*TDATA_BYTES/2];
    
    data_out_i = data_out[8*(TDATA_BYTES+1)-1:0];
    data_out_q = data_out[8*(2*TDATA_BYTES+2)-1:8*(TDATA_BYTES+1)];

    data_out_i_gold = data_in_1_i*data_in_2_i - data_in_1_q*data_in_2_q;
    data_out_q_gold = data_in_1_i*data_in_2_q + data_in_1_q*data_in_2_i;
    
    // ------------------------------------------------------------------
    if (data_out_i_gold == data_out_i && data_out_q_gold == data_out_q)
        `uvm_info("PASS", "Check pass", UVM_LOW)
    else
        `uvm_error("FAIL", "Check fail")
    
endfunction