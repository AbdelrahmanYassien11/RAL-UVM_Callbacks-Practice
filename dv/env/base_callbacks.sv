// Define what callbacks are available
class driver_cb extends uvm_callback;
  `uvm_object_utils(driver_cb)
  
  // Virtual functions that can be overridden
  virtual task pre_send(uvm_driver#(seq_item) drv, seq_item item);
    // Default: do nothing
  endtask
  
  virtual task post_send(uvm_driver#(seq_item) drv, seq_item item);
    // Default: do nothing  
  endtask
  
  virtual function bit should_drop_packet(seq_item item);
    return 0; // Default: don't drop
  endfunction
endclass