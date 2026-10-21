`ifdef COCOTB_SIM
initial begin
    $dumpfile("waves/dump.vcd");
    $dumpvars(0, sync_fifo);
end
`endif

module sync_fifo #(
    parameter FIFO_DEPTH = 4,
    parameter DATA_W = 8

)(
    input logic clk,
    input logic rst_n,

    input logic in_valid,
    output logic in_ready,
    input logic [DATA_W-1:0] w_data,


    output logic out_valid,
    input logic out_ready,
    output logic [DATA_W - 1:0] r_data

);
    localparam PTR_BITS = $clog2(FIFO_DEPTH);

    
    logic [PTR_BITS:0] w_ptr, r_ptr;
    logic full, empty;

    assign full = w_ptr[PTR_BITS] != r_ptr[PTR_BITS] && w_ptr[PTR_BITS- 1:0] == r_ptr[PTR_BITS- 1:0];
    assign empty = (w_ptr == r_ptr);
    assign in_ready = !full;
    assign out_valid = !empty;


    logic [DATA_W - 1:0] fifo [0:FIFO_DEPTH - 1];
    always_ff @ (posedge clk) begin
        if (!rst_n) begin
            for (int i = 0; i < FIFO_DEPTH; i++) begin
                fifo[i] <= 'b0;
            end
            

        end else begin
            if (in_valid && !full) begin
                fifo[w_ptr[PTR_BITS - 1:0]] <= w_data;
                w_ptr <= w_ptr + 1'b1;
            end
            if (out_ready && !empty) begin
                r_ptr <= r_ptr + 1'b1;
            end
        end
    end

    always_comb begin
        if (!empty) begin
            r_data = fifo[r_ptr[PTR_BITS - 1:0]];
        end else begin
            r_data = 'b0;
        end
    end



endmodule




