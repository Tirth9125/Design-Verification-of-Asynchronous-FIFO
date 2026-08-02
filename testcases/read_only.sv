/*program test_read_only(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 5;

  initial begin

    env = new(intf);

    // Start environment first
    env.run();

    //----------------------------------
    // PHASE 1 : PRELOAD FIFO
    //----------------------------------

    repeat(NUM) begin

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.randomize();

      $display("TEST: Preload write %0h", tr.data);

      env.gen2drv.put(tr);
      env.sb.write_expected(tr.data);

    end

    // allow writes to complete
    repeat(NUM*4) @(posedge intf.wclk);


    //----------------------------------
    // PHASE 2 : READ ONLY
    //----------------------------------

    repeat(NUM) begin

      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      $display("TEST: Sending READ request");

      env.gen2drv.put(tr);

    end


    // allow reads to complete
    repeat(NUM*4) @(posedge intf.rclk);

    $display("READ ONLY TEST DONE");

    $finish;

  end

endprogram*/

/*program test_read_only(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 5;

  initial begin

    env = new(intf);
    env.run();

    //----------------------------------
    // PHASE 1 : PRELOAD FIFO (WRITES)
    //----------------------------------

    repeat(NUM) begin
      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.randomize();

      $display("TEST: Preload write %0h", tr.data);

      env.gen2drv.put(tr);          // send to driver
      env.sb.write_expected(tr.data); // update reference model
    end

    // Wait until driver consumes all writes
    wait(env.gen2drv.num() == 0);

    // Allow driver pipeline to finish last write
    repeat(NUM*2) @(posedge intf.wclk);


    //----------------------------------
    // PHASE 2 : READ ONLY
    //----------------------------------

    repeat(NUM) begin
      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      $display("TEST: Sending READ request");

      env.gen2drv.put(tr);
    end

    // Wait until driver consumes all reads
    wait(env.gen2drv.num() == 0);

    // Allow monitor + scoreboard to process reads
    repeat(NUM*2) @(posedge intf.rclk);

    $display("READ ONLY TEST DONE");

    $finish;

  end

endprogram*/

program test_read_only(fifo_if intf);

  environment env;
  fifo_txn tr;

  int NUM = 6;

  initial begin

    env = new(intf);
    env.run();

    //----------------------------------
    // PHASE 1 : PRELOAD FIFO
    //----------------------------------

    repeat(NUM) begin

      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.data  = $urandom_range(0,255);

      $display("TEST: Preload write %0h", tr.data);

      env.gen2drv.put(tr);
      //env.sb.write_expected(tr.data);

    end


    //----------------------------------
    // WAIT FOR WRITES TO COMPLETE
    //----------------------------------

    repeat(NUM*3) @(posedge intf.wclk);
    repeat(NUM*3) @(posedge intf.rclk);
    // Wait until FIFO is definitely non-empty in read domain
   //wait(intf.rempty == 0);

// wait extra cycles for pointer sync
  //repeat(3) @(posedge intf.rclk);

    //----------------------------------
    // PHASE 2 : READ
    //----------------------------------

    repeat(NUM) begin
      

      tr = new();
      tr.wr_en = 0;
      tr.rd_en = 1;

      $display("TEST: Sending READ request");

      env.gen2drv.put(tr);

    end


    //----------------------------------
    // WAIT FOR READS
    //----------------------------------
    
     repeat(NUM*4) @(posedge intf.rclk);
   
    
    $display("READ ONLY TEST DONE");
    
    $display("\n---------------- COVERAGE REPORT ----------------");

$display("WRITE COVERAGE = %0.2f %%", env.mon.w_cov.get_inst_coverage());
$display("READ COVERAGE  = %0.2f %%", env.mon.r_cov.get_inst_coverage());

$display("-------------------------------------------------\n");

    $finish;

  end

endprogram
