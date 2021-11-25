interface axis_if
#(
    int unsigned TDATA_BYTES = 1
)
(
    input aclk
);
    // signals
    logic [TDATA_BYTES*8-1:0] tdata;
    logic tvalid = 1'b0;
    logic tready = 1'b0;
    logic aresetn = 1'b1; 
     
    modport master
    (
        output tdata,
        output tvalid,
        input  tready,
        output aresetn
    );

    modport slave
    (
        input  tdata,
        input  tvalid,
        output tready,
        output aresetn 
    );

    // reset axis
    task reset (input int unsigned aclk_ticks);
        aresetn <= 1'b0;

        repeat(aclk_ticks)
            @(posedge aclk);

        aresetn <= 1'b1;
    endtask
    

    // write to axis
    task write (input logic [TDATA_BYTES*8-1:0] data, input int unsigned aclk_delay);
        // wait for release of reset and two ticks after that
        if (!aresetn) begin 
            wait(aresetn)
            repeat(2) @(posedge aclk);
        end

        repeat(aclk_delay)
            @(posedge aclk);
            
        tdata <= data;
        tvalid <= 1'b1;

        // wait tready 
        forever begin
            @(posedge aclk);
            if (tready) begin 
                tvalid <= 1'b0;
                return;
            end
        end
    endtask

    // read from axis
    task read (output logic [TDATA_BYTES*8-1:0] data, input int unsigned aclk_delay);
        // wait for release of reset and two ticks after that 
        if (!aresetn) begin 
            wait(aresetn)
            repeat(2) @(posedge aclk);
        end

        repeat(aclk_delay)
            @(posedge aclk);

        tready <= 1'b1;

        // wait tvalid 
        forever begin
            @(posedge aclk);
            if (tvalid) begin 
                data <= tdata;
                tready <= 1'b0;
                return;
            end
        end
    endtask

endinterface