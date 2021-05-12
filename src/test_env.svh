class test_env extends uvm_env;
    `uvm_component_utils(test_env)
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    extern function void build_phase(uvm_phase phase);

    localparam TDATA_BYTES_IN = 4;
    localparam TDATA_BYTES_OUT = 10;

    axis_rand_sequence axis_seqc_in_1;
    axis_rand_sequence axis_seqc_in_2;
    axis_rand_sequence axis_seqc_out;

    virtual axis_if #(TDATA_BYTES_IN) axis_in_1;
    virtual axis_if #(TDATA_BYTES_IN) axis_in_2;
    virtual axis_if #(TDATA_BYTES_OUT) axis_out;

    axis_agent #(TDATA_BYTES_IN) axis_agent_in_1;
    axis_agent #(TDATA_BYTES_IN) axis_agent_in_2;
    axis_agent #(TDATA_BYTES_OUT) axis_agent_out;

endclass

function void test_env::build_phase(uvm_phase phase);
    
    // получение интерфейсов из базы данных
    if (!uvm_config_db #(virtual axis_if #(TDATA_BYTES_IN))::get(this, "", "axis_in_1", axis_in_1))
        `uvm_fatal("GET_DB", "Can not get axis_in_1")

    if (!uvm_config_db #(virtual axis_if #(TDATA_BYTES_IN))::get(this, "", "axis_in_2", axis_in_2))
        `uvm_fatal("GET_DB", "Can not get axis_in_2")

    if (!uvm_config_db #(virtual axis_if #(TDATA_BYTES_OUT))::get(this, "", "axis_out", axis_out))
        `uvm_fatal("GET_DB", "Can not get axis_out")            

    // создание sequence
    axis_seqc_in_1 = axis_rand_sequence::type_id::create("axis_seqc_in_1", this);
    axis_seqc_in_2 = axis_rand_sequence::type_id::create("axis_seqc_in_2", this);
    axis_seqc_out = axis_rand_sequence::type_id::create("axis_seqc_out", this);

    // создание агентов
    axis_agent_in_1 = axis_agent #(TDATA_BYTES_IN)::type_id::create("axis_agent_in_1", this);
    axis_agent_in_2 = axis_agent #(TDATA_BYTES_IN)::type_id::create("axis_agent_in_2", this);
    axis_agent_out = axis_agent #(TDATA_BYTES_OUT)::type_id::create("axis_agent_out", this);

    // выбор типов агентов
    axis_agent_in_1.agent_type = MASTER;
    axis_agent_in_2.agent_type = MASTER;
    axis_agent_out.agent_type = SLAVE;

    // соединение интерфейсов
    axis_agent_in_1.axis_if_h = this.axis_in_1;
    axis_agent_in_2.axis_if_h = this.axis_in_2;
    axis_agent_out.axis_if_h = this.axis_out;

endfunction