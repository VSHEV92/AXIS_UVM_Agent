class test_env extends uvm_env;
    `uvm_component_utils(test_env)
    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

    localparam TDATA_BYTES_IN = 4;
    localparam TDATA_BYTES_OUT = 10;

    virtual axis_if #(TDATA_BYTES_IN) axis_in_1;
    virtual axis_if #(TDATA_BYTES_IN) axis_in_2;
    virtual axis_if #(TDATA_BYTES_OUT) axis_out;

    axis_agent #(TDATA_BYTES_IN) axis_agent_in_1;
    axis_agent #(TDATA_BYTES_IN) axis_agent_in_2;
    axis_agent #(TDATA_BYTES_OUT) axis_agent_out;

    test_scoreboard #(TDATA_BYTES_IN) test_scoreboard_h;

endclass

function void test_env::build_phase(uvm_phase phase);
    
    // получение интерфейсов из базы данных
    if (!uvm_config_db #(virtual axis_if #(TDATA_BYTES_IN))::get(this, "", "axis_in_1", axis_in_1))
        `uvm_fatal("GET_DB", "Can not get axis_in_1")

    if (!uvm_config_db #(virtual axis_if #(TDATA_BYTES_IN))::get(this, "", "axis_in_2", axis_in_2))
        `uvm_fatal("GET_DB", "Can not get axis_in_2")

    if (!uvm_config_db #(virtual axis_if #(TDATA_BYTES_OUT))::get(this, "", "axis_out", axis_out))
        `uvm_fatal("GET_DB", "Can not get axis_out")            

    // создание scoreboard
    test_scoreboard_h = test_scoreboard #(TDATA_BYTES_IN)::type_id::create("test_scoreboard_h", this);

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

function void test_env::connect_phase(uvm_phase phase);

    axis_agent_in_1.axis_monitor_h.analysis_port_h.connect(test_scoreboard_h.analysis_port_in_1);
    axis_agent_in_2.axis_monitor_h.analysis_port_h.connect(test_scoreboard_h.analysis_port_in_2);
    axis_agent_out.axis_monitor_h.analysis_port_h.connect(test_scoreboard_h.analysis_port_out);

endfunction