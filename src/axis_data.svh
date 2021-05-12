class axis_data extends uvm_sequence_item;

    `uvm_object_utils(axis_data)
    function new (string name = "");
        super.new(name);
    endfunction

    int unsigned max_clock_before_tvalid = 5;
    int unsigned min_clock_before_tvalid = 0;
    int unsigned max_clock_before_tready = 5;
    int unsigned min_clock_before_tready = 0;
    int unsigned max_tdata = 255;
    int unsigned min_tdata = 0;

    rand bit [1024-1:0] tdata;
    rand int unsigned clock_before_tvalid; // число тактов до установки tvalid
    rand int unsigned clock_before_tready; // число тактов до установки tready

    // ограничения на рандомизацию
    constraint tdata_const {
        tdata <= max_tdata;
        tdata >= min_tdata;
    }
    constraint clock_before_tvalid_const {
        clock_before_tvalid <= max_clock_before_tvalid;
        clock_before_tvalid >= min_clock_before_tvalid;
    }
    constraint clock_before_tready_const {
        clock_before_tready <= max_clock_before_tready;
        clock_before_tready >= min_clock_before_tready;
    }

    extern function string convert2string();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);

endclass

// ------------------------------------------------------------------------------
function string axis_data::convert2string();
    return $sformatf("tdata = %0h, \t clock_before_tvalid = %0d, \t clock_before_tready = %0d", tdata, clock_before_tvalid, clock_before_tready);
endfunction

function bit axis_data::do_compare(uvm_object rhs, uvm_comparer comparer);
    axis_data RHS;
    bit same;

    same = super.do_compare(rhs, comparer);
    $cast(RHS, rhs);
    same = (tdata == RHS.tdata) && same;
    return same;
endfunction