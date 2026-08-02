/*class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sb;
  
  mailbox #(fifo_txn) gen2drv;
  mailbox #(fifo_txn) mon2scb;
  
  virtual fifo_if vif;
  
  function new(virtual fifo_if vif);
    this.vif = vif;
    
    gen2drv = new();
    mon2scb = new();
    
    gen = new(gen2drv);
    drv = new(vif,gen2drv);
    mon = new(vif,mon2scb);
    sb = new(mon2scb);
    
  endfunction
  
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      sb.run();
    join_none
  endtask
  
  endclass*/

/*class environment;

  generator gen;
  driver drv;
  monitor mon;
  scoreboard sb;

  mailbox #(fifo_txn) gen2drv;
  mailbox #(fifo_txn) mon2scb;

  event gen_done;
  virtual fifo_if vif;

  function new(virtual fifo_if vif, int repeat_count);
    this.vif = vif;

    gen2drv = new();
    mon2scb = new();

    gen = new(gen2drv);
    gen.repeat_count = repeat_count;
    gen.done = gen_done;

    drv = new(vif, gen2drv, gen_done);
    mon = new(vif, mon2scb);
    sb  = new(mon2scb, repeat_count);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      sb.run();
    join_none
     
    
    disable fork;

    $display("ENV finished .");
  endtask

endclass*/

/*class environment;

  generator gen;
  driver drv;

  mailbox #(fifo_txn) gen2drv;

  virtual fifo_if vif;

  function new(virtual fifo_if vif);
    this.vif = vif;

    gen2drv = new();

    gen = new(gen2drv);
    drv = new(vif, gen2drv);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
    join
  endtask

endclass*/

/*class environment;

  generator gen;
  driver drv;

  mailbox #(fifo_txn) gen2drv;
  virtual fifo_if vif;

  function new(virtual fifo_if vif);
    this.vif = vif;

    gen2drv = new();
    gen = new(gen2drv);
    drv = new(vif, gen2drv);
  endfunction

  task run();
    fork
      drv.run();
    join_none
  endtask

endclass*/

/*class environment;

  driver drv;
  monitor mon;
  scoreboard sb;

  mailbox #(fifo_txn) gen2drv;
  mailbox #(fifo_txn) mon2scb;

  virtual fifo_if vif;

  int num_writes;

  function new(virtual fifo_if vif, int n);

    this.vif = vif;
    this.num_writes = n;

    gen2drv = new();
    mon2scb = new();

    drv = new(vif, gen2drv, num_writes);
    mon = new(vif, mon2scb);
    sb  = new(mon2scb);

  endfunction


  task run();

    fork
      drv.run();
      mon.run();
      sb.run();
    join_none

  endtask

endclass*/

class environment;

  // components
  driver drv;
  monitor mon;
  scoreboard sb;

  // mailboxes
  mailbox #(fifo_txn) gen2drv;
  mailbox #(fifo_txn) mon2scb;

  // virtual interface
  virtual fifo_if vif;

  function new(virtual fifo_if vif);

    this.vif = vif;

    // create mailboxes
    gen2drv = new();
    mon2scb = new();

    // create components
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
    sb  = new(mon2scb);

  endfunction


  task run();

    fork
      drv.run();
      mon.run();
      sb.run();
    join_none

  endtask

endclass
