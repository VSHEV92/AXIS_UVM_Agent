class axis_rand_sequence extends uvm_sequence #(axis_data);
    `uvm_object_utils(axis_rand_sequence)
    function new (string name = "");
        super.new(name);
    endfunction
    
    extern task body();
    extern task pre_body();

    int unsigned trans_numb = 100;
    axis_data axis_data_h;
    
endclass

// ---------------------------------------------------------------------
task axis_rand_sequence::pre_body();
    
endtask

task axis_rand_sequence::body();
    repeat(trans_numb) begin
        axis_data_h = axis_data::type_id::create("axis_data_h");
        start_item(axis_data_h);
            assert(axis_data_h.randomize());
        finish_item(axis_data_h);
    end
endtask