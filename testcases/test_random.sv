program test_random_read_write(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 50;   // number of random operations

  initial begin

    env = new(intf);
    env.run();

    //----------------------------------
    // RANDOM TRAFFIC
    //----------------------------------

    repeat(NUM) begin

      tr = new();

      // randomly choose read or write
      if($urandom_range(0,1)) begin

        //----------------------------------
        // WRITE
        //----------------------------------
        tr.wr_en = 1;
        tr.rd_en = 0;
        tr.data  = $urandom_range(0,255);

        $display("TEST RANDOM WRITE %0h", tr.data);

      end
      else begin

        //----------------------------------
        // READ
        //----------------------------------
        tr.wr_en = 0;
        tr.rd_en = 1;

        $display("TEST RANDOM READ");

      end

      env.gen2drv.put(tr);

      // allow clocks to progress
      repeat(2) @(posedge intf.wclk);
      repeat(2) @(posedge intf.rclk);

    end


    //----------------------------------
    // WAIT FOR LAST OPERATIONS
    //----------------------------------

    repeat(30) @(posedge intf.rclk);

    $display("RANDOM READ WRITE TEST DONE");

    $finish;

  end

endprogram
