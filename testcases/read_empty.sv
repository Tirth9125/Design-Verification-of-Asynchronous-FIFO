program test_read_until_empty(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 8;   // number of entries written (should match FIFO depth ideally)

  initial begin

    env = new(intf);
    env.run();

    repeat(5) @(posedge intf.wclk);

    //----------------------------------
    // STEP 1: FILL FIFO
    //----------------------------------

    for(int i=0;i<NUM;i++) begin

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.data = $urandom_range(0,255);

      $display("TEST: WRITE DATA=%0h", tr.data);

      env.gen2drv.put(tr);

      repeat(2) @(posedge intf.wclk);

    end


    //----------------------------------
    // STEP 2: READ ALL DATA
    //----------------------------------

    repeat(5) @(posedge intf.rclk);

    for(int i=0;i<NUM;i++) begin

      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      $display("TEST: READ DATA");

      env.gen2drv.put(tr);

      repeat(2) @(posedge intf.rclk);

    end


    //----------------------------------
    // STEP 3: EXTRA READS -> EMPTY
    //----------------------------------

    repeat(3) begin

      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      $display("TEST: READ WHEN FIFO EMPTY");

      env.gen2drv.put(tr);

      repeat(2) @(posedge intf.rclk);

    end


    //----------------------------------
    // WAIT
    //----------------------------------

    repeat(10) @(posedge intf.rclk);

    $display("READ UNTIL EMPTY TEST DONE");

    $finish;

  end

endprogram
