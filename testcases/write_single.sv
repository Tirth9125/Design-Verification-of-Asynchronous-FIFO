program test_single_write(fifo_if intf);

  environment env;

  initial begin
    env = new(intf);

    env.run();

    #50;
    $display("SINGLE WRITE TEST DONE");
    $finish;
  end

endprogram
