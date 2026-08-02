program test_fifo_reset(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 4;

  initial begin

    env = new(intf);
    env.run();

    //----------------------------------
    // PHASE 1 : WRITE SOME DATA
    //----------------------------------

    repeat(NUM) begin

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.data  = $urandom_range(0,255);

      $display("TEST WRITE BEFORE RESET %0h", tr.data);

      env.gen2drv.put(tr);

    end

    // allow writes to complete
    repeat(NUM*4) @(posedge intf.wclk);
    repeat(NUM*4) @(posedge intf.rclk);

    //----------------------------------
    // PHASE 2 : ASSERT RESET
    //----------------------------------

    $display("TEST ASSERT RESET");

    intf.wrst_n = 0;
    intf.rrst_n = 0;

    repeat(5) @(posedge intf.wclk);

    //----------------------------------
    // PHASE 3 : DEASSERT RESET
    //----------------------------------

    $display("TEST DEASSERT RESET");

    intf.wrst_n = 1;
    intf.rrst_n = 1;

    repeat(5) @(posedge intf.wclk);
    repeat(5) @(posedge intf.rclk);

    //----------------------------------
    // PHASE 4 : READ AFTER RESET
    //----------------------------------

    tr = new();
    tr.wr_en = 0;
    tr.rd_en = 1;

    $display("TEST READ AFTER RESET (FIFO should be empty)");

    env.gen2drv.put(tr);

    repeat(5) @(posedge intf.rclk);

    //----------------------------------
    // FINISH
    //----------------------------------

    $display("FIFO RESET TEST DONE");

    $finish;

  end

endprogram
