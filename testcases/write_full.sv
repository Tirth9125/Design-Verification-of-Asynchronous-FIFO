program test_write_when_full(fifo_if intf);

  environment env;
  fifo_txn tr;

  int DEPTH = 8;
  int EXTRA = 3;

  initial begin

    env = new(intf);
    env.run();

    //----------------------------------
    // FILL FIFO
    //----------------------------------

    repeat(DEPTH) begin

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.data  = $urandom_range(0,255);

      $display("TEST WRITE %0h", tr.data);

      env.gen2drv.put(tr);

    end


    //----------------------------------
    // WAIT UNTIL FIFO FULL
    //----------------------------------

    wait(intf.wfull == 1);

    $display("FIFO IS FULL");


    //----------------------------------
    // TRY WRITES WHEN FULL
    //----------------------------------

    repeat(EXTRA) begin

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.data  = $urandom_range(0,255);

      $display("TEST WRITE WHEN FULL %0h", tr.data);

      env.gen2drv.put(tr);

      repeat(2) @(posedge intf.wclk);

    end


    //----------------------------------
    // WAIT
    //----------------------------------

    repeat(20) @(posedge intf.wclk);

    $display("WRITE WHEN FULL TEST DONE");

    $finish;

  end

endprogram
