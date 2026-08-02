class scoreboard;

  mailbox #(fifo_txn) mon2scb;

  // reference FIFO model
  bit [7:0] ref_fifo[$];

  int checked_count = 0;

  parameter DEPTH = 8;

  function new(mailbox #(fifo_txn) mb);
    this.mon2scb = mb;
  endfunction


  task run();

    fifo_txn tr;
    bit [7:0] exp_data;

    forever begin

      mon2scb.get(tr);

      //--------------------------------
      // WRITE observed
      //--------------------------------
      if(tr.wr_en) begin

        if(ref_fifo.size() < DEPTH) begin

          ref_fifo.push_back(tr.data);

          $display("SCB MODEL WRITE data=%0h fifo_size=%0d time=%0t",
                   tr.data, ref_fifo.size(), $time);

          if(ref_fifo.size() == DEPTH)
            $display("SCB INFO: MODEL FIFO FULL time=%0t", $time);

        end
        else begin

          $display("SCB INFO: WRITE IGNORED (MODEL FIFO FULL) time=%0t",
                   $time);

        end

      end


      //--------------------------------
      // READ observed
      //--------------------------------
      if(tr.rd_en) begin

        if(ref_fifo.size() == 0) begin
          $error("SCB ERROR: Read occurred but model empty at time %0t", $time);
        end
        else begin

          exp_data = ref_fifo.pop_front();

          if(exp_data == tr.data) begin

            $display("SCB PASS: expected=%0h actual=%0h time=%0t",
                     exp_data, tr.data, $time);

          end
          else begin

            $error("SCB FAIL: expected=%0h actual=%0h time=%0t",
                    exp_data, tr.data, $time);

          end

        end

        checked_count++;

      end

    end

  endtask

endclass
