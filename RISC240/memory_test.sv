module Memory_test();
  logic [7:0] data;
  tri [7:0] bus;
  logic [1:0] addr;
  logic re, we, clock;
  BusDriver #(8) BUS (.en(we),
                      .data(data),
                      .bus(bus));

  Memory #(8,4,2) DUT (.addr(addr),
                       .re(re),
                       .we(we),
                       .clock(clock),
                       .data(bus));

  initial begin
    clock = 'b0;
    forever #10 clock = ~clock;
  end

  initial begin
    $monitor($time,, "[%s]     BUS: %d | addr: %b  data: %d",
                      (we) ? "WRITE" : "READ", bus, addr, data);
  end

  initial begin
    addr <= 2'b00;
    data <= 8'd240;
    re <= 1'b1;
    we <= 1'b0;
    @(posedge clock);
    re <= 1'b0;
    we <= 1'b1;
    @(posedge clock);
    re <= 1'b1;
    we <= 1'b0;
    @(posedge clock);
    addr <= 2'b01;
    data <= 8'd220;
    @(posedge clock);
    re <= 1'b0;
    we <= 1'b1;
    @(posedge clock);
    re <= 1'b1;
    we <= 1'b0;
    addr <= 2'b00;
    @(posedge clock);
    re <= 1'b0;
    we <= 1'b1;
    addr <= 2'b10;
    data <= 8'd250;
    @(posedge clock);
    re <= 1'b1;
    we <= 1'b0;
    @(posedge clock);
    re <= 1'b0;
    we <= 1'b1;
    addr <= 2'b11;
    data <= 8'd213;
    @(posedge clock);
    re <= 1'b1;
    we <= 1'b0;
    @(posedge clock);
    addr <= 2'b00;
    @(posedge clock);
    addr <= 2'b01;
    @(posedge clock);
    addr <= 2'b10;
    @(posedge clock);
    addr <= 2'b11;
    @(posedge clock);
    #1 $finish;
  end

endmodule : Memory_test%                   