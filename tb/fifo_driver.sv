/*class driver;
  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;
  
  
  function new (virtual fifo_if vif,mailbox #(fifo_txn)mb);
    this.vif = vif;
    gen2drv = mb;
  endfunction
  
  task run();
    fifo_txn tr;
    forever begin
      gen2drv.get(tr);
      
      if(tr.wr_en) begin
        @(posedge vif.wclk);
        if(!vif.wfull) begin
          vif.winc <=1;
          vif.wdata <= tr.data;
        end
        @(posedge vif.wclk);
        vif.winc <= 0;
      end
      
      if(tr.rd_en) begin
        @(posedge vif.rclk);
        if(!vif.rempty)
          vif.rinc <= 1;
        @(posedge vif.rclk);
          vif.rinc <=0 ;
      end
    end
  endtask
endclass*/


/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;

  function new (virtual fifo_if vif,
                mailbox #(fifo_txn) mb);
    this.vif = vif;
    gen2drv  = mb;
  endfunction

  task run();
    fifo_txn tr;

    // Initialize signals
    vif.winc  <= 0;
    vif.rinc  <= 0;
    vif.wdata <= 0;

    forever begin
      gen2drv.get(tr);

      // WRITE
      if (tr.wr_en) begin
        @(posedge vif.wclk);
        if (!vif.wfull) begin
          vif.wdata <= tr.data;
          vif.winc  <= 1;
        end
        @(posedge vif.wclk);
        vif.winc <= 0;
      end
      else begin
        vif.winc <= 0;
      end

      // READ
      if (tr.rd_en) begin
        @(posedge vif.rclk);
        if (!vif.rempty)
          vif.rinc <= 1;
        @(posedge vif.rclk);
        vif.rinc <= 0;
      end
      else begin
        vif.rinc <= 0;
      end
    end
  endtask

endclass*/

/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;
  event gen_done;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb,
               event done);
    this.vif = vif;
    gen2drv  = mb;
    gen_done = done;
  endfunction

  task run();
    fifo_txn tr;

    vif.winc  <= 0;
    vif.rinc  <= 0;
    vif.wdata <= 0;

    forever begin

      if (!gen2drv.try_get(tr)) begin
        if (gen_done.triggered)
          break;
        @(posedge vif.wclk);
        continue;
      end

      // WRITE
      if (tr.wr_en && !vif.wfull) begin
        @(posedge vif.wclk);
        vif.wdata <= tr.data;
        vif.winc  <= 1;
        @(posedge vif.wclk);
        vif.winc  <= 0;
      end

      // READ
      if (tr.rd_en && !vif.rempty) begin
        @(posedge vif.rclk);
        vif.rinc <= 1;
        @(posedge vif.rclk);
        vif.rinc <= 0;
      end
    end
  endtask

endclass*/

/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif = vif;
    gen2drv  = mb;
  endfunction

  task run();
    fifo_txn tr;

    // Initialize
    vif.winc  <= 0;
    vif.wdata <= 0;

    gen2drv.get(tr);

    if (tr.wr_en) begin
      @(posedge vif.wclk);

      if (!vif.wfull) begin
        vif.wdata <= tr.data;
        vif.winc  <= 1;
      end

      @(posedge vif.wclk);
      vif.winc <= 0;

      $display("DRV: Write applied data=%0h at time %0t",
                tr.data, $time);
    end

  endtask

endclass*/

/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;
  int expected_writes;
  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif = vif;
    gen2drv  = mb;
  endfunction

  task run();

    fifo_txn tr;

    // initialize
    vif.winc  <= 0;
    vif.wdata <= 0;

    forever begin

      if (gen2drv.try_get(tr)) begin

        if (tr.wr_en) begin

          @(posedge vif.wclk);

          if (!vif.wfull) begin
            vif.wdata <= tr.data;
            vif.winc  <= 1;
          end

          @(posedge vif.wclk);
          vif.winc <= 0;

          $display("DRV: Write %0h at time %0t",
                    tr.data, $time);
          
        end

      end
      else begin
       // #5;   // prevent tight 
      end

    end

  endtask

endclass*/
    
   


/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;

  int expected_writes;   

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb,
               int num);
    this.vif = vif;
    gen2drv  = mb;
    expected_writes = num;
  endfunction

  task run();

    fifo_txn tr;

    vif.winc  <= 0;
    vif.wdata <= 0;

    repeat (expected_writes) begin

      gen2drv.get(tr);   // BLOCKING (safe now)

      @(posedge vif.wclk);

      if (!vif.wfull) begin
        vif.wdata <= tr.data;
        vif.winc  <= 1;
      end

      @(posedge vif.wclk);
      vif.winc <= 0;

      $display("DRV: Write %0h at time %0t",
                tr.data, $time);
    end

  endtask

endclass*/

/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;

  int expected_writes;
  bit done = 0;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb,
               int num);

    this.vif = vif;
    this.gen2drv = mb;
    this.expected_writes = num;

  endfunction


  task run();

    fifo_txn tr;

    // initialize signals
    vif.winc  <= 0;
    vif.wdata <= 0;

    repeat(expected_writes) begin

      gen2drv.get(tr);

      // wait for clock edge
      @(posedge vif.wclk);

      if(!vif.wfull) begin
        vif.wdata <= tr.data;
        vif.winc  <= 1;
                

       // Print when write actually occurs
      $display("DRV: Write %0h at time %0t", tr.data, $time);
    end     

      
      
    
      // hold write enable for one cycle
      @(posedge vif.wclk);
      vif.winc <= 0;

      //$display("DRV: Write %0h at time %0t",
               // tr.data, $time);

    end

  endtask
 
endclass*/

/*class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;

  int expected_writes;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb,
               int num);

    this.vif = vif;
    this.gen2drv = mb;
    this.expected_writes = num;

  endfunction


  task run();

    fifo_txn tr;

    // initialize signals
    vif.winc  <= 0;
    vif.wdata <= 0;

    repeat(expected_writes) begin

      gen2drv.get(tr);

      // WAIT until FIFO has space
      while(vif.wfull)
        @(posedge vif.wclk);

      @(posedge vif.wclk);

      vif.wdata <= tr.data;
      vif.winc  <= 1;

      $display("DRV: Write %0h at time %0t", tr.data, $time);

      @(posedge vif.wclk);
      vif.winc <= 0;

    end

  endtask

endclass*/

//driver to support both reads and writes

class driver;

  virtual fifo_if vif;
  mailbox #(fifo_txn) gen2drv;

  function new(virtual fifo_if vif, mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.gen2drv = mb;
  endfunction


  task run();

    fifo_txn tr;

    // reset values
    vif.winc = 0;
    vif.rinc = 0;
      
    forever begin
      gen2drv.get(tr);

      //---------------------------------
      // WRITE
      //---------------------------------
      if(tr.wr_en) begin

        //while(vif.wfull)
          @(posedge vif.wclk);
        if(vif.wfull)
         $display("DRV WARNING: FIFO FULL, write attempt data=%0h time=%0t",
             tr.data,$time); 
       
          @(posedge vif.wclk);
        // drive item
         //vif.winc  = 1;
        vif.wdata = tr.data;
        vif.winc  = 1;

        $display("DRV WRITE %0h time=%0t", tr.data,$time);

        @(posedge vif.wclk);
         

        // release
        vif.winc = 0;
        //@(posedge vif.wclk);
      end

  
      //---------------------------------
      // READ
      //---------------------------------
      if(tr.rd_en) begin
     
        //while(vif.rempty)
        @(posedge vif.rclk);
        
//        @(posedge vif.rclk);

        vif.rinc = 1;

        $display("DRV READ request time=%0t",$time);

        @(posedge vif.rclk);

        vif.rinc = 0;
        @(posedge vif.rclk); //reqd
      end

    end

  endtask

endclass
