class driver_cb extends uvm_callback;
  `uvm_object_utils(driver_cb)
  
  seq_item pkt;
  function new(string name = "driver_cb");
    super.new(name);
  endfunction
  
  virtual task modify_pkt();
  endtask
endclass

class derived_cb extends driver_cb;
  `uvm_object_utils(derived_cb)
  
  function new(string name = "derived_cb");
    super.new(name);
  endfunction
  
  task modify_pkt; // callback method implementation
    `uvm_info(get_full_name(),"Inside modify_pkt method: Injecting data = aef0_8888",UVM_LOW);
    pkt.randomize() with {data == 'h_aef0_8888;};
  endtask
endclass