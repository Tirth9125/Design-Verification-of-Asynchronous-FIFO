program test_write_faster_than_read(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 20;

  initial begin

    env = new(intf);
    env.run();

    //----------------------------------
    // TRAFFIC GENERATION
    //----------------------------------

    repeat(NUM) begin

      //----------------------------------
      // BURST OF WRITES
      //----------------------------------

      repeat(3) begin

        tr = new();
        tr.wr_en = 1;
        tr.rd_en = 0;
        tr.data  = $urandom_range(0,255);

        $display("TEST FAST WRITE %0h", tr.data);

        env.gen2drv.put(tr);

        // allow driver to complete write
        repeat(2) @(posedge intf.wclk);

      end


      //----------------------------------
      // OCCASIONAL READ
      //----------------------------------

      if($urandom_range(0,2) == 0) begin

        tr = new();
        tr.wr_en = 0;
        tr.rd_en = 1;

        $display("TEST OCCASIONAL READ");

        env.gen2drv.put(tr);

        repeat(3) @(posedge intf.rclk);

      end

    end


    //----------------------------------
    // DRAIN FIFO
    //----------------------------------

    repeat(10) begin

      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      env.gen2drv.put(tr);

      repeat(3) @(posedge intf.rclk);

    end


    //----------------------------------
    // FINISH
    //----------------------------------

    repeat(20) @(posedge intf.rclk);

    $display("WRITE FASTER THAN READ TEST DONE");

    $finish;

  end

endprogram
