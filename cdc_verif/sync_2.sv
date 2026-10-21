module sync_2 #(
    parameter DATA_WIDTH = 4
)(
    input logic clk,
    input logic rst_n,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

logic [DATA_WIDTH-1:0] data_in_sync1;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_sync1 <= 1'b0;
        data_out <= 1'b0;
    end else begin
        data_in_sync1 <= data_in;
        data_out <= data_in_sync1;
    end
end


endmodule