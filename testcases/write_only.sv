//`include "fifo_environment.sv"

/*program test_write_only(fifo_if intf);

  class my_trans extends transaction;

    function void pre_randomize();
      wr_en.rand_mode(0);
      rd_en.rand_mode(0);

      wr_en = 1;
      rd_en = 0;
      data  = $random;
    endfunction

  endclass

  environment env;
  my_trans tr;

  initial begin
    env = new(intf);
    tr  = new();

    env.gen.repeat_count = 20;
    env.gen.trans = tr;

    // Expected FIFO model update
    fork
      forever begin
        @(posedge intf.wclk);
        if (intf.winc && !intf.wfull)
          env.sb.write_expected(intf.wdata);
      end
    join_none

    env.run();
  end

endprogram*/

/*program test_write_only_random(fifo_if intf);

  environment env;
  fifo_txn tr;

  initial begin

    int NUM = 5;

    env = new(intf, NUM);
    env.run();

    repeat (NUM) begin
      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.randomize();

      $display("TEST: Sending random write %0h", tr.data);

      env.gen2drv.put(tr);
    end

    #100;
    $display("WRITE ONLY RANDOM TEST DONE");
    $finish;

  end

endprogram*/

/*program test_write_only_random(fifo_if intf);

  environment env;
  fifo_txn tr;

  initial begin

    int NUM = 5;

    env = new(intf, NUM);
    env.run();

    repeat (NUM) begin
      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      tr.randomize();

      $display("TEST: Sending random write %0h", tr.data);

      env.gen2drv.put(tr);

      // add expected data for scoreboard
      env.sb.write_expected(tr.data);
    end

    #100;
    $display("WRITE ONLY RANDOM TEST DONE");
    $finish;

  end

endprogram*/

program test_write_only_random(fifo_if intf);

  environment env;
  fifo_txn tr;
  int NUM = 5;
  initial begin

    //int NUM = 5;

    env = new(intf);
     env.run();
    // Generate transactions first
    repeat (NUM) begin
      tr = new();
      tr.wr_en = 1;
      tr.rd_en = 0;
      //tr.randomize();//dont call here again else it will override
      tr.data  = $urandom_range(0,255);
      $display("TEST: Sending random write %0h", tr.data);

      env.gen2drv.put(tr);
      //env.sb.write_expected(tr.data);
    end

    // Now start environment
    //env.run();

    //#200;
    //repeat(NUM+3) @(posedge intf.wclk);
    
    
    #500;
    //repeat(NUM*20) @(posedge intf.wclk);
     $display("WRITE ONLY RANDOM TEST DONE");
    $finish;

  end

endprogram


