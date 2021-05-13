class axis_sequence extends uvm_sequence #(axis_data);
    `uvm_object_utils(axis_sequence)
    function new (string name = "");
        super.new(name);
    endfunction
    
    extern task pre_body();
    extern task body();
    extern task post_body();

    extern function void config_item();

    int unsigned trans_numb;
    bit from_file;
    string file_name;

    int file_ID;

    axis_data axis_data_h;

    axis_sequence_config axis_seqc_config;
    
endclass

// ---------------------------------------------------------------------
task axis_sequence::pre_body();
    trans_numb = axis_seqc_config.trans_numb;
    from_file = axis_seqc_config.from_file;
    file_name = axis_seqc_config.file_name;

    if (from_file) begin
        file_ID = $fopen(file_name, "r");
        if (file_ID == 0)
            `uvm_fatal("SEQC", "Can not open file")
    end

endtask

task axis_sequence::body();
    repeat(trans_numb) begin
        axis_data_h = axis_data::type_id::create("axis_data_h");
        start_item(axis_data_h);
            config_item();
            assert(axis_data_h.randomize());
            if (from_file)
                $fscanf(file_ID, "%h\n", axis_data_h.tdata);
        finish_item(axis_data_h);
    end
endtask

task axis_sequence::post_body();
    if (from_file)
        $fclose(file_ID);
endtask

function void axis_sequence::config_item();
    axis_data_h.max_clock_before_tvalid = axis_seqc_config.max_clock_before_tvalid;
    axis_data_h.min_clock_before_tvalid = axis_seqc_config.min_clock_before_tvalid;
    axis_data_h.max_clock_before_tready = axis_seqc_config.max_clock_before_tready;
    axis_data_h.min_clock_before_tready = axis_seqc_config.min_clock_before_tready;
    axis_data_h.max_tdata = axis_seqc_config.max_tdata;
    axis_data_h.min_tdata = axis_seqc_config.min_tdata;
endfunction