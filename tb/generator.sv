/*class generator;
  
  mailbox #(fifo_txn) gen2drv;
  fifo_txn trans;
  int repeat_count;
  
  function new(mailbox #(fifo_txn)mb);
    gen2drv = mb;
  endfunction
  
  task run();
    repeat (repeat_count) begin
      trans = new(); //always create object
      trans.randomize();
      gen2drv.put(trans);
    end
  endtask
  
endclass*/

/*class generator;

  mailbox #(fifo_txn) gen2drv;
  int repeat_count;
  event done;

  function new(mailbox #(fifo_txn) mb);
    gen2drv = mb;
  endfunction

  task run();
    fifo_txn tr;

    repeat (repeat_count) begin
      tr = new();
      assert(tr.randomize());
      gen2drv.put(tr);
    end

    -> done;   // signal completion
  endtask

endclass*/

/*class generator;

  mailbox #(fifo_txn) gen2drv;

  function new(mailbox #(fifo_txn) mb);
    gen2drv = mb;
  endfunction

  task run();
    fifo_txn tr;

    tr = new();

    // HARD CODED VALUES
    tr.wr_en = 1;
    tr.rd_en = 0;
    tr.data  = 8'hA5;

    $display("GEN: Sending one write txn data=%0h", tr.data);

    gen2drv.put(tr);

  endtask

endclass*/

class generator;

  mailbox #(fifo_txn) gen2drv;

  function new(mailbox #(fifo_txn) mb);
    gen2drv = mb;
  endfunction

  // Generator does nothing active
  task run();
    // passive in this controlled mode
  endtask

endclass
