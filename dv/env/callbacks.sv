class derived_cb extends driver_cb;
  `uvm_object_utils(derived_cb)
  
  // Override callback methods
  virtual task pre_send(uvm_driver#(seq_item) drv, seq_item item);
    `uvm_info("CALLBACK", $sformatf("About to send: %s", item.sprint()), UVM_LOW)
    
    // Modify the item before sending!
    if(item.addr inside {[0:5]}) begin
      item.data = 'hDEADBEEF; // Force specific data
      `uvm_info("CALLBACK", "Modified data to DEADBEEF", UVM_LOW)
    end
  endtask
  
  virtual task post_send(uvm_driver#(seq_item) drv, seq_item item);
    `uvm_info("CALLBACK", "Transaction completed", UVM_LOW)
  endtask
  
//   virtual function bit should_drop_packet(seq_item item);
//     //
//     if(item.addr inside {[0:5]}) begin
//       `uvm_info("CALLBACK", "Dropping packet to addr 0x200", UVM_LOW)
//       return 1;
//     end
//     return 0;
//   endfunction
endclass