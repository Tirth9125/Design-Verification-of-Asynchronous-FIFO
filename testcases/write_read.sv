program test_write_read(fifo_if intf);

  class my_trans extends transaction;

    int count;

    function void pre_randomize();
      wr_en.rand_mode(0);
      rd_en.rand_mode(0);

      if (count < 10) begin
        wr_en = 1;
        rd_en = 0;
        data  = count;
      end
      else begin
        wr_en = 0;
        rd_en = 1;
      end
      count++;
    endfunction

  endclass

  environment env;
  my_trans tr;

  initial begin
    env = new(intf);
    tr  = new();

    env.gen.repeat_count = 20;
    env.gen.trans = tr;

    fork
      forever begin
        @(posedge intf.wclk);
        if (intf.winc && !intf.wfull)
          env.sb.write_expected(intf.wdata);
      end
    join_none

    env.run();
  end

endprogram
