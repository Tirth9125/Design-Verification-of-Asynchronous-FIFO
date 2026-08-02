program test_alternate_write_read(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 5;

  initial begin

    env = new(intf);
    env.run();

    
    
    //----------------------------------
    // ALTERNATE WRITE / READ
    //----------------------------------

    repeat(NUM) begin

      //----------------------------------
      // WRITE
      //----------------------------------

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.data  = $urandom_range(0,255);

      $display("TEST WRITE %0h", tr.data);

      env.gen2drv.put(tr);
      @(posedge intf.wclk);


      //----------------------------------
      // READ
      //----------------------------------

      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      $display("TEST READ");

      env.gen2drv.put(tr);
      repeat(2) @(posedge intf.rclk);

    end


    //----------------------------------
    // WAIT FOR COMPLETION
    //----------------------------------

    repeat(NUM*10) @(posedge intf.rclk);

    $display("ALTERNATE WRITE READ TEST DONE");

    $finish;

  end

endprogram
