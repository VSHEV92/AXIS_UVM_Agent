`timescale 1ns/1ps

module top_tb;

    import uvm_pkg::*;
    import test_pkg::*; 

    localparam TDATA_BYTES_IN = 4;
    localparam TDATA_BYTES_OUT = 10;

    bit aclk = 0;
    axis_if #(TDATA_BYTES_IN) axis_in_1 (aclk);
    axis_if #(TDATA_BYTES_IN) axis_in_2 (aclk);
    axis_if #(TDATA_BYTES_OUT) axis_out (aclk);
    
    always 
        #2 aclk = ~aclk;

cmpy_0 dut (
    .aclk(aclk),                              
    .s_axis_a_tvalid    (axis_in_1.tvalid),        
    .s_axis_a_tready    (axis_in_1.tready),        
    .s_axis_a_tdata     (axis_in_1.tdata),          
    .s_axis_b_tvalid    (axis_in_2.tvalid),       
    .s_axis_b_tready    (axis_in_2.tready),        
    .s_axis_b_tdata     (axis_in_2.tdata),          
    .m_axis_dout_tvalid (axis_out.tvalid),  
    .m_axis_dout_tready (axis_out.tready), 
    .m_axis_dout_tdata  (axis_out.tdata)   
);

    initial begin
        uvm_config_db #(virtual axis_if #(TDATA_BYTES_IN))::set(null, "uvm_test_top.*", "axis_in_1", axis_in_1);
        uvm_config_db #(virtual axis_if #(TDATA_BYTES_IN))::set(null, "uvm_test_top.*", "axis_in_2", axis_in_2);
        uvm_config_db #(virtual axis_if #(TDATA_BYTES_OUT))::set(null, "uvm_test_top.*", "axis_out", axis_out);
        run_test("rand_axis_test");
    end

endmodule