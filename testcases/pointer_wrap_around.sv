/*program test_pointer_wraparound(fifo_if intf);

  environment env;
  fifo_txn tr;

  int DEPTH = 8;
  int ITER  = 3;

  initial begin

    env = new(intf);
    env.run();

    repeat(ITER) begin

      //--------------------------------
      // PHASE 1 : FILL FIFO
      //--------------------------------
      $display("\n---- FILL FIFO ----");

      repeat(DEPTH) begin

        tr = new();
        tr.wr_en = 1;
        tr.rd_en = 0;
        tr.data  = $urandom_range(0,255);

        $display("TEST WRITE %0h", tr.data);

        env.gen2drv.put(tr);

      end


      //--------------------------------
      // WAIT FOR WRITES
      //--------------------------------
      repeat(DEPTH*3) @(posedge intf.wclk);


      //--------------------------------
      // PHASE 2 : DRAIN FIFO
      //--------------------------------
      $display("---- DRAIN FIFO ----");

      repeat(DEPTH) begin

        tr = new();
        tr.wr_en = 0;
        tr.rd_en = 1;

        $display("TEST READ");

        env.gen2drv.put(tr);

      end


      //--------------------------------
      // WAIT FOR READS
      //--------------------------------
      repeat(DEPTH*4) @(posedge intf.rclk);

    end


    $display("POINTER WRAP TEST COMPLETE");
    $finish;

  end

endprogram*/

program test_pointer_wraparound(fifo_if intf);

  environment env;
  fifo_txn tr;

  int DEPTH = 8;
  int ITER  = 40;

  initial begin

    env = new(intf);
    env.run();

    $display("START PARALLEL WRAP TEST");

    fork

      //--------------------------------
      // WRITE THREAD
      //--------------------------------
      begin
        repeat(ITER) begin

          tr = new();
          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = $urandom_range(0,255);

          $display("WRITE THREAD: WRITE %0h", tr.data);

          env.gen2drv.put(tr);

          @(posedge intf.wclk);

        end
      end


      //--------------------------------
      // READ THREAD
      //--------------------------------
      begin
        repeat(ITER) begin

          tr = new();
          tr.wr_en = 0;
          tr.rd_en = 1;

          $display("READ THREAD: READ");

          env.gen2drv.put(tr);

          @(posedge intf.rclk);

        end
      end

    join

    repeat(20) @(posedge intf.rclk);

    $display("PARALLEL WRAP TEST DONE");
    $display("\n---------------- COVERAGE REPORT ----------------");

$display("WRITE COVERAGE = %0.2f %%", env.mon.w_cov.get_inst_coverage());
$display("READ COVERAGE  = %0.2f %%", env.mon.r_cov.get_inst_coverage());

$display("-------------------------------------------------\n");


    $finish;

  end

endprogram
