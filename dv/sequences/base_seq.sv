class base_seq extends uvm_sequence#(seq_item);
  seq_item req;
  `uvm_object_utils(base_seq)
  
  function new (string name = "base_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    `uvm_do(req);
  endtask
endclass

class reg_seq extends uvm_sequence#(seq_item);
  seq_item              req;
  RegModel_SFR          reg_model;
  uvm_status_e          status;
  uvm_reg_data_t        read_data;

  rand bit              r_or_w;

  uvm_reg          all_regs[$];
  // uvm_reg               all_regs[2];

  `uvm_object_utils(reg_seq)

  function new (string name = "reg_seq");
    super.new(name);
  endfunction

  task body();
    uvm_reg temp_reg;
    `uvm_info(get_type_name(), "Reg seq: Inside Body", UVM_LOW);
    if(!uvm_config_db#(RegModel_SFR) :: get(uvm_root::get(), "", "reg_model", reg_model))
      `uvm_fatal(get_type_name(), "reg_model is not set at top level");

    req = seq_item::type_id::create("req");
    reg_model.get_registers(all_regs);
    // all_regs.push_back(reg_model.mod_reg.control_reg);
    // all_regs.push_back(reg_model.mod_reg.intr_sts_reg);
    // all_regs.push_back(reg_model.mod_reg.intr_msk_reg);

    reg_model.mod_reg.control_reg.write(status, 32'h1234_1234);
    reg_model.mod_reg.control_reg.read(status, read_data);
    
    reg_model.mod_reg.control_reg.write(status, 32'habac_abac);
    reg_model.mod_reg.control_reg.read(status, read_data);

    reg_model.mod_reg.intr_sts_reg.write(status, 32'heeee_eeee);
    reg_model.mod_reg.intr_sts_reg.read(status, read_data);

    reg_model.mod_reg.intr_msk_reg.write(status, 32'h5555_5555, UVM_BACKDOOR, reg_model.mod_reg.default_map);
    if (status != UVM_IS_OK) `uvm_error("BD_WRITE","backdoor write failed");
    reg_model.mod_reg.intr_msk_reg.read(status, read_data);

    `uvm_info(get_type_name(), "Starting randomized reads/writes", UVM_LOW);

    repeat(10) begin
      if(!(req.randomize())) begin
        `uvm_fatal(get_type_name(), "COULDN'T Randomize Item for READ in RAL MODEL");
      end
      // if(!(std::randomize(all_regs))) begin
      //   `uvm_fatal(get_type_name(), "COULDN'T Randomize reg queue");
      // end
      temp_reg = all_regs[$urandom_range(all_regs.size()-1)];
      case(req.rd_or_wr)
      0: begin
        /*reg_model.mod_reg.*/temp_reg.write(status, req.data);
        `uvm_info(get_type_name(), $sformatf("data written = %0h", req.data), UVM_LOW)        
      end
      1: begin
        /*reg_model.mod_reg.*/temp_reg.read(status, req.data);
        `uvm_info(get_type_name(), $sformatf("data read = %0h", req.data), UVM_LOW)        
      end
      endcase
    end


    // reg_model.mod_reg.intr_msk_reg.poke(status, 32'hcafe_bee, /*UVM_BACKDOOR, reg_model.mod_reg.default_map*/);
    // if (status != UVM_IS_OK) `uvm_error("BD_WRITE","backdoor write failed");
    // reg_model.mod_reg.intr_msk_reg.read(status, read_data);
    // `uvm_info(get_type_name(),$sformatf("Read_Data_Value from DUT = %h", read_data),UVM_LOW)

    // read_data = reg_model.mod_reg.intr_msk_reg.get_mirrored_value();
    // `uvm_info(get_type_name(),$sformatf("Read_Data_Value from RAL without update = %h", read_data),UVM_LOW)

  endtask
endclass