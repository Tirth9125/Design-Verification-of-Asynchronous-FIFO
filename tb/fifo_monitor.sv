/*class monitor;
  
  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;
  
  function new( virtual fifo_if vif, mailbox #(fifo_txn) mb);
    this.vif = vif; 
    this.mon2scb = mb;
  endfunction
  
  task run();
    fifo_txn tr;
    
    forever begin
      @(posedge vif.rclk);
      
      if(vif.rinc && !vif.rempty) begin
        tr=new();
        tr.rd_en = 1;
        tr.wr_en=0;
        tr.data = vif.rdata;
        mon2scb.put(tr);
      end
      end
  endtask
      
      endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.mon2scb = mb;
  endfunction

  task run();
    fifo_txn tr;

    forever begin
      @(posedge vif.rclk);

      if (vif.rinc && !vif.rempty) begin
        tr = new();
        tr.rd_en = 1;
        tr.data  = vif.rdata;
        mon2scb.put(tr);
      end
    end
  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif = vif;
    mon2scb  = mb;
  endfunction

  task run();

    fifo_txn tr;

    forever begin

      @(posedge vif.wclk);

      if (vif.winc && !vif.wfull) begin

        tr = new();
        tr.wr_en = 1;
        tr.data  = vif.wdata;

        $display("MON: observed write %0h at %0t",
                  tr.data, $time);

        mon2scb.put(tr);

      end

    end

  endtask

endclass*/

/*class monitor;

  // Virtual interface
  virtual fifo_if vif;

  // Mailbox to scoreboard
  mailbox #(fifo_txn) mon2scb;

  // Constructor
  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);

    this.vif     = vif;
    this.mon2scb = mb;

  endfunction


  // Main monitor task
  task run();

    fifo_txn tr;

    forever begin

      @(posedge vif.wclk or posedge vif.rclk);

      // ------------------------
      // WRITE MONITORING
      // ------------------------
      if (vif.winc && !vif.wfull) begin

        tr = new();

        tr.wr_en = vif.winc;
        tr.rd_en = 0;
        tr.data  = vif.wdata;

        $display("MON: WRITE observed data=%0h time=%0t",
                  tr.data, $time);

        mon2scb.put(tr);

      end


      // ------------------------
      // READ MONITORING
      // ------------------------
      if (vif.rinc && !vif.rempty) begin

        tr = new();

        tr.wr_en = 0;
        tr.rd_en = vif.rinc;
        tr.data  = vif.rdata;

        $display("MON: READ observed data=%0h time=%0t",
                  tr.data, $time);

        mon2scb.put(tr);

      end

    end

  endtask

endclass*/

/*class monitor;

  // Virtual interface
  virtual fifo_if vif;

  // Mailbox to scoreboard
  mailbox #(fifo_txn) mon2scb;

  // Constructor
  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif     = vif;
    this.mon2scb = mb;
  endfunction


  task run();

    fork

      // -------------------------
      // WRITE DOMAIN MONITOR
      // -------------------------
      forever begin
        @(posedge vif.wclk);

        if (vif.winc && !vif.wfull) begin

          fifo_txn tr;
          tr = new();

          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wdata;

          $display("MON: WRITE observed data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);

        end
      end


      // -------------------------
      // READ DOMAIN MONITOR
      // -------------------------
      forever begin
        @(posedge vif.rclk);

        if (vif.rinc && !vif.rempty) begin

          fifo_txn tr;
          tr = new();

          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = vif.rdata;

          $display("MON: READ observed data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);

        end
      end

    join_none

  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif, mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.mon2scb = mb;
  endfunction


  task run();

    fork

      // WRITE DOMAIN
      forever begin
        @(posedge vif.winc);

        if (!vif.wfull) begin
          fifo_txn tr = new();

          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wdata;

          $display("MON: WRITE observed data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);
        end
      end


      // READ DOMAIN
      forever begin
        @(posedge vif.rinc);

        if (!vif.rempty) begin
          fifo_txn tr = new();

          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = vif.rdata;

          $display("MON: READ observed data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);
        end
      end

    join_none

  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif, mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.mon2scb = mb;
  endfunction


  task run();

    bit prev_winc = 0;
    bit prev_rinc = 0;

    fork

      // -------------------------
      // WRITE DOMAIN MONITOR
      // -------------------------
      forever begin
        @(posedge vif.wclk);

        if (vif.winc && !prev_winc && !vif.wfull) begin

          fifo_txn tr = new();

          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wdata;

          $display("MON: WRITE observed data=%0h time=%0t",
                   tr.data, $time);

          mon2scb.put(tr);
        end

        prev_winc = vif.winc;

      end


      // -------------------------
      // READ DOMAIN MONITOR
      // -------------------------
      forever begin
        @(posedge vif.rclk);

        if (vif.rinc && !prev_rinc && !vif.rempty) begin

          fifo_txn tr = new();

          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = vif.rdata;

          $display("MON: READ observed data=%0h time=%0t",
                   tr.data, $time);

          mon2scb.put(tr);
        end

        prev_rinc = vif.rinc;

      end

    join_none

  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.mon2scb = mb;
  endfunction


  task run();

    fork

      // -------------------------
      // WRITE DOMAIN MONITOR
      // -------------------------
      forever begin

        @(vif.wmon_cb);

        if (vif.wmon_cb.winc && !vif.wmon_cb.wfull) begin

          fifo_txn tr = new();

          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wmon_cb.wdata;

          $display("MON: WRITE observed data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);

        end

      end


      // -------------------------
      // READ DOMAIN MONITOR
      // -------------------------
      forever begin

        @(vif.rmon_cb);

        if (vif.rmon_cb.rinc && !vif.rmon_cb.rempty) begin

          fifo_txn tr = new();

          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = vif.rmon_cb.rdata;

          $display("MON: READ observed data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);

        end

      end

    join_none

  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);

    this.vif = vif;
    this.mon2scb = mb;

  endfunction


  task run();

    fork

      // -------------------------
      // WRITE DOMAIN
      // -------------------------
      forever begin

        @(posedge vif.wclk);

        if(vif.winc && !vif.wfull) begin

          fifo_txn tr = new();

          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wdata;

          $display("MON: WRITE observed data=%0h time=%0t",
                   tr.data, $time);

          mon2scb.put(tr);

        end

      end


      // -------------------------
      // READ DOMAIN
      // -------------------------
      forever begin

        @(posedge vif.rclk);

        if(vif.rinc && !vif.rempty) begin

          fifo_txn tr = new();

          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = vif.rdata;

          $display("MON: READ observed data=%0h time=%0t",
                   tr.data, $time);

          mon2scb.put(tr);

        end

      end

    join_none

  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  function new(virtual fifo_if vif, mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.mon2scb = mb;
  endfunction

  task run();
    fork
      // WRITE DOMAIN
      forever begin
        @(posedge vif.wclk);
        #0; // wait for NBA updates from driver

        if (vif.winc && !vif.wfull) begin
          fifo_txn tr = new();
          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wdata;

          $display("MON: WRITE observed data=%0h time=%0t", tr.data, $time);
          mon2scb.put(tr);
        end
      end

      // READ DOMAIN
      forever begin
        @(posedge vif.rclk);
        #0; // same reason for read side

        if (vif.rinc && !vif.rempty) begin
          fifo_txn tr = new();
          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = vif.rdata;

          $display("MON: READ observed data=%0h time=%0t", tr.data, $time);
          mon2scb.put(tr);
        end
      end
    join_none
  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  bit prev_winc;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);
    this.vif = vif;
    this.mon2scb = mb;
  endfunction


  task run();

    fifo_txn tr;
    prev_winc = 0;

    forever begin

      @(posedge vif.wclk);

      // detect write event
      if(vif.winc && !prev_winc) begin

        tr = new();
        tr.wr_en = 1;
        tr.data  = vif.wdata;

        $display("MON: WRITE observed data=%0h time=%0t",
                  tr.data, $time);

        mon2scb.put(tr);

      end

      prev_winc = vif.winc;

    end

  endtask

endclass*/

//Monitor for both reads and writes

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  bit prev_winc;
  bit prev_rinc;
  bit [7:0] prev_rdata;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);

    this.vif     = vif;
    this.mon2scb = mb;

  endfunction


  task run();

    fifo_txn tr;

    prev_winc = 0;
    prev_rinc = 0;

    fork

      //--------------------------------
      // WRITE MONITOR (wclk domain)
      //--------------------------------

      forever begin

        @(posedge vif.wclk);

        if(vif.winc && !prev_winc) begin
          //@(posedge vif.wclk);
          
          //#5;
          tr = new();

          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = vif.wdata;

          //$display("MON WRITE data=%0h time=%0t",
                    //tr.data,$time);

          mon2scb.put(tr);

        end

        prev_winc = vif.winc;

      end


      //--------------------------------
      // READ MONITOR (rclk domain)
      //--------------------------------

      forever begin

        @(posedge vif.rclk);
        prev_rdata = vif.rdata;
        if(vif.rinc && !prev_rinc) begin
          
          //@(posedge vif.rclk);   // wait for data
          //#5;
           #0;
          tr = new();

          tr.wr_en = 0;
          tr.rd_en = 1;
          //tr.data  = vif.rdata;
          tr.data = prev_rdata;
           
          $display("MON READ data=%0h time=%0t",
                    tr.data,$time);

          mon2scb.put(tr);

        end

        prev_rinc = vif.rinc;

      end

    join

  endtask

endclass*/

/*class monitor;

  virtual fifo_if vif;
  mailbox #(fifo_txn) mon2scb;

  // Edge detection
  bit prev_winc;
  bit prev_rinc;

  bit curr_winc;
  bit curr_rinc;

  // Data capture
  bit [7:0] curr_wdata;
  bit [7:0] rdata_latched;

  // Empty tracking
  bit curr_empty;

  function new(virtual fifo_if vif,
               mailbox #(fifo_txn) mb);

    this.vif     = vif;
    this.mon2scb = mb;

  endfunction


  task run();

    fifo_txn tr;

    prev_winc = 0;
    prev_rinc = 0;

    fork

      //--------------------------------
      // WRITE MONITOR (wclk domain)
      //--------------------------------
      forever begin

        @(posedge vif.wclk);

        curr_winc  = vif.winc;
        curr_wdata = vif.wdata;

        if(curr_winc && !prev_winc) begin

          tr = new();
          tr.wr_en = 1;
          tr.rd_en = 0;
          tr.data  = curr_wdata;

          $display("MON WRITE data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);

        end

        prev_winc = curr_winc;

      end


      //--------------------------------
      // LATCH READ DATA (old address)
      //--------------------------------
      forever begin

        @(negedge vif.rclk);

        // capture data before raddr increments
        rdata_latched = vif.rdata;

      end


      //--------------------------------
      // READ MONITOR (rclk domain)
      //--------------------------------
      forever begin

        @(posedge vif.rclk);

        curr_rinc  = vif.rinc;
        curr_empty = vif.rempty;

        if(curr_rinc && !prev_rinc && !curr_empty) begin

          tr = new();
          tr.wr_en = 0;
          tr.rd_en = 1;
          tr.data  = rdata_latched;

          $display("MON READ data=%0h time=%0t",
                    tr.data, $time);

          mon2scb.put(tr);

        end

        prev_rinc = curr_rinc;

      end

    join_none

  endtask

endclass*/

//-----------------------------------------
  // WRITE SIDE COVERAGE

covergroup write_cg with function sample(bit winc,

                                         bit wfull,

                                         bit [7:0] wdata);

  option.per_instance = 1;

 

  write_cp : coverpoint winc {

    bins write = {1};

  }

 

  full_cp : coverpoint wfull {

    bins full     = {1};

    bins not_full = {0};

  }

 

  wdata_cp : coverpoint wdata {

    bins low  = {[0:63]};

    bins mid  = {[64:127]};

    bins high = {[128:255]};

  }

 

  write_full_cross : cross write_cp, full_cp;

endgroup

 

// READ SIDE COVERAGE

covergroup read_cg with function sample(bit rinc,

                                        bit rempty,

                                        bit [7:0] rdata);

  option.per_instance = 1;

 

  read_cp : coverpoint rinc {

    bins read = {1};

  }

 

  empty_cp : coverpoint rempty {

    bins empty     = {1};

    bins not_empty = {0};

  }

 

  rdata_cp : coverpoint rdata {

    bins low  = {[0:63]};

    bins mid  = {[64:127]};

    bins high = {[128:255]};

  }

 

  read_empty_cross : cross read_cp, empty_cp;

endgroup

 

class monitor;

 

  virtual fifo_if vif;

  mailbox #(fifo_txn) mon2scb;

 

  bit prev_winc;

  bit prev_rinc;
  
  bit curr_rinc ;

        bit curr_empty  ;

  bit [7:0] rd    ;
  int wptr_ref = 0;
  int rptr_ref = 0;
  int DEPTH = 8;

 

  write_cg w_cov;

  read_cg  r_cov;

 

  function new(virtual fifo_if vif,

               mailbox #(fifo_txn) mb);

    this.vif     = vif;

    this.mon2scb = mb;

 

    w_cov = new();

    r_cov = new();

  endfunction

 

  task run();

    fifo_txn tr;

 

    prev_winc = 0;

    prev_rinc = 0;

 

    fork

 

      // ==========================

      // WRITE MONITOR

      // ==========================

      forever begin

        bit curr_winc;

        bit [7:0] curr_wdata;

 

        @(posedge vif.wclk);

        #0;

 

        if (!vif.wrst_n) begin

          prev_winc = 0;

          continue;

        end

 

        curr_winc  = vif.winc;

        curr_wdata = vif.wdata;

 

        // Rising edge of winc

        if (curr_winc && !prev_winc) begin

          tr = new();

          tr.wr_en = 1;

          tr.rd_en = 0;

          tr.data  = curr_wdata;

 

          $display("MON WRITE data=%0h time=%0t",

                    tr.data, $time);

          mon2scb.put(tr);

 

        

          w_cov.sample(curr_winc,

                       vif.wfull,

                       curr_wdata);

        end
       
        //---------------------------------
          // Update TB write pointer
          //---------------------------------
          if(!vif.wfull) begin
            wptr_ref = (wptr_ref + 1) % DEPTH;
          end

          $display("TB PTR STATUS: wptr=%0d rptr=%0d",
                    wptr_ref,rptr_ref);

          //---------------------------------
          // Check FULL condition
          //---------------------------------
          if(((wptr_ref + 1) % DEPTH) == rptr_ref) begin

            if(!vif.wfull)
              $error("TB ERROR: FIFO SHOULD BE FULL but wfull=0 time=%0t",$time);

          end
          else begin

            if(vif.wfull)
              $error("TB ERROR: FIFO NOT FULL but wfull=1 time=%0t",$time);

          end

        
 

        prev_winc = curr_winc;

      end

 

      // ==========================

      // READ MONITOR (pre‑NBA)

      // ==========================

      forever begin

        @(vif.rc_cb);

 

        if (!vif.rrst_n) begin

          prev_rinc = 0;

          continue;

        end

 

         curr_rinc   = vif.rc_cb.rinc;

         curr_empty  = vif.rc_cb.rempty;

         rd    = vif.rc_cb.rdata; // pre‑NBA data

 

        // Rising edge of rinc

        if (curr_rinc && !prev_rinc) begin

 

          if (!curr_empty) begin

            tr = new();

            tr.wr_en = 0;

            tr.rd_en = 1;

            tr.data  = rd;

 

            $display("MON READ data=%0h time=%0t",

                      tr.data, $time);

            mon2scb.put(tr);
            
            
                 //---------------------------------
          // Update TB read pointer
          //---------------------------------
          rptr_ref = (rptr_ref + 1) % DEPTH;

          $display("TB PTR STATUS: wptr=%0d rptr=%0d",
                    wptr_ref,rptr_ref);

          //---------------------------------
          // Check EMPTY condition
          //---------------------------------
          if(wptr_ref == rptr_ref) begin

            if(!vif.rempty)
              $error("TB ERROR: FIFO SHOULD BE EMPTY but rempty=0 time=%0t",$time);

          end
          else begin

            if(vif.rempty)
              $error("TB ERROR: FIFO NOT EMPTY but rempty=1 time=%0t",$time);

          end

        end


        //---------------------------------
        // READ WHEN EMPTY
        //---------------------------------
        else if(curr_rinc && !prev_rinc && curr_empty) begin

          $display("MON READ WHEN FIFO EMPTY time=%0t",$time);

        end

          

          else begin

            $display("MON READ WHEN EMPTY time=%0t", $time);

          end

 

          // ✅ SAMPLE COVERAGE ON READ ATTEMPT

          r_cov.sample(curr_rinc,

                       curr_empty,

                       curr_empty ? '0 : rd);

        end

 

        prev_rinc = curr_rinc;

      end

 

    join_none

  endtask

 

endclass

 

 
