module async_fifo #(
    parameter DATA_WIDTH = 4,
    parameter FIFO_DEPTH = 8

)(
    input logic wr_clk,
    input logic rd_clk,
    input logic rst_n,

    input logic wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    output logic full,

    input logic rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic empty
);

localparam PTR_WIDTH = $clog2(FIFO_DEPTH);

logic [PTR_WIDTH:0] wr_ptr, rd_ptr;
logic [PTR_WIDTH:0] wr_ptr_gray, rd_ptr_gray;
logic [PTR_WIDTH:0] wr_ptr_gray_synced, rd_ptr_gray_synced;
assign empty = wr_ptr_gray_synced == rd_ptr_gray;
assign full = (wr_ptr_gray[PTR_WIDTH] != rd_ptr_gray_synced[PTR_WIDTH]) &&  (wr_ptr_gray[PTR_WIDTH-1] != rd_ptr_gray_synced[PTR_WIDTH-1]) && (wr_ptr_gray[PTR_WIDTH-2:0] == rd_ptr_gray_synced[PTR_WIDTH-2:0]);

logic [DATA_WIDTH - 1:0] fifo [0: FIFO_DEPTH-1];

sync_2 rd_sync #(
    .DATA_WIDTH(PTR_WIDTH+1)
)(
    .clk(rd_clk),
    .rst_n(rst_n),
    .data_in(wr_ptr_gray),
    .data_out(wr_ptr_gray_synced)
);

sync_2 wr_sync #(
    .DATA_WIDTH(PTR_WIDTH+1)
)(
    .clk(wr_clk),
    .rst_n(rst_n),
    .data_in(rd_ptr_gray),
    .data_out(rd_ptr_gray_synced)
);


always_ff @(posedge wr_clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_ptr <= 'b0;
    end else begin
        if (wr_en && !full) begin
            fifo[wr_ptr[PTR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end
end
assign wr_ptr_gray = wr_ptr ^ (wr_ptr >> 1);

always_ff @(posedge rd_clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <= 'b0;
        rd_data <= 'b0;
    end else begin
        if (rd_en && !empty) begin
            rd_data <= fifo[rd_ptr[PTR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end
end
assign rd_ptr_gray = rd_ptr ^ (rd_ptr >> 1);

endmodule