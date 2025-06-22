`define REG_CTRL       3'd0   // 偏移 0x00: CTRL（读写共址，写=启动，读=STATUS 返回）
`define REG_STATUS     3'd0   // STATUS 和 CTRL 共用偏移 0x00，读时输出 STATUS
`define REG_PIXEL_IN   3'd2   // 偏移 0x08: PIXEL_IN（写像素）
`define REG_SRAM       3'd3   // 偏移 0x0C: OFM_SRAM（读输出特征图）
`define REG_NEED_PIC   3'd1   // 偏移 0x04: 用于将need_pic_reg置零
`define REG_WEIGHT     3'd4   // 偏移 0x10：用于传输weight
`define REG_RECORD     3'd5   // 0x14 
module mmu_wrapper_read #(
  parameter APB_ADDR_WIDTH = 12,   // APB 地址宽度
  parameter DATA_WIDTH     = 8,
  parameter IFM_SIZE       = 28,
  parameter KSIZE          = 5
)(
  input  logic                     HCLK,
  input  logic                     HRESETn,

  // -- APB 从机接口 -- 
  input  logic [APB_ADDR_WIDTH-1:0] PADDR,
  input  logic               [31:0] PWDATA,
  input  logic                    PWRITE,
  input  logic                    PSEL,
  input  logic                    PENABLE,
  output logic              [31:0] PRDATA,
  output logic                    PREADY,
  output logic                    PSLVERR,
  output logic                    irq_o
);

  // --------------------------------------------------------------------------
  // 本地参数
  // --------------------------------------------------------------------------
  localparam OFM_DEPTH = IFM_SIZE * IFM_SIZE;
  localparam ADDR_BITS = $clog2(OFM_DEPTH);

  // --------------------------------------------------------------------------
  // 将 APB 事务对齐到寄存器索引
  // --------------------------------------------------------------------------
  logic [2:0] reg_adr;
  assign reg_adr = PADDR[4:2]; 

  //assign PREADY  = 1'b1;
  assign PSLVERR = 1'b0;
  assign irq_o = 0;
  // --------------------------------------------------------------------------
  // 与 conv_control 握手信号
  // --------------------------------------------------------------------------
  logic                   conv_start;
  logic                   need_pic;        // 来自 conv_control
  //logic                   pic_valid;       // 发给    conv_control
  logic [31:0]  pic;             // 发给    conv_control
  

  // --------------------------------------------------------------------------
  // CTRL & REG_PIXEL_IN 寄存器 (0x00 & 0x10) -- APB写 (conv_start, pic, pic_valid)
  // -------------------------------------------------------------------------
  logic conv_start_reg;
  //, conv_start_n
  logic pic_valid, pic_valid_n;
  logic weight_valid, weight_valid_n;
  logic [31:0] pic_reg, pic_reg_n;
  logic [31:0] weight, weight_n;
  logic need_pic_reg,need_pic_reg_n;

  logic [1:0] status_reg;
  logic                   conv_finish;
  logic         conv_finish_reg, conv_finish_reg_n;         // 来自 conv_control
  assign status_reg = {conv_finish_reg, need_pic_reg};
  logic [9:0] c_read_counter, c_read_counter_n;
  logic  ready_counter, ready_counter_n;
  logic [10:0] sram_addr_rd_c; 
  logic [DATA_WIDTH-1:0] ofm_read_data;
  logic ofm_read_en;
  
  logic r_reg_pic_need,r_reg_pic_need_n;
  always_ff @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn)begin             
      //conv_start_reg <= 1'b0;
      pic_valid <= 1'b0;
      weight_valid <= 1'b0;
      pic_reg <= '0;
      weight <= '0;
      conv_finish_reg <= 1'b0;
      need_pic_reg <= 1'b0;
	r_reg_pic_need <= 1'b0;
    end else begin                    
      //conv_start_reg <= conv_start_n;
      pic_reg <= pic_reg_n;
      weight <= weight_n;
      pic_valid <= pic_valid_n;
      weight_valid <= weight_valid_n;
      conv_finish_reg <= conv_finish_reg_n;
      need_pic_reg <= need_pic_reg_n;
	r_reg_pic_need <= r_reg_pic_need_n;
    end
  end
  
always_comb begin
    //conv_start_n = conv_start_reg;
    //conv_start_n = 0;
    conv_start_reg = 0;
    pic_reg_n   = pic_reg;
    weight_n = weight;
    pic_valid_n = 1'b0;
    weight_valid_n = 1'b0;
	r_reg_pic_need_n = r_reg_pic_need;
    if(conv_finish)begin
      conv_finish_reg_n = 1'b1;
    end else begin
      conv_finish_reg_n = conv_finish_reg;
    end

    if (need_pic == 1'b1) begin
      need_pic_reg_n = 1'b1;
     end else begin
      need_pic_reg_n = need_pic_reg;
     end

    if (PSEL && PENABLE && PWRITE) begin
      case (reg_adr)
	`REG_RECORD:begin
		r_reg_pic_need_n = PWDATA[0];
	end
        `REG_CTRL: begin
          conv_start_reg = PWDATA[0];
        end
        `REG_PIXEL_IN: begin
          pic_reg_n = PWDATA[31:0];
          pic_valid_n  = 1'b1;
          need_pic_reg_n = 1'b0;
        end
        `REG_NEED_PIC: begin
          //need_pic_reg = PWDATA[0];
          conv_finish_reg_n = PWDATA[0];
        end
        `REG_WEIGHT : begin
         weight_n = PWDATA[31:0];
         weight_valid_n  = 1'b1;
        end
        default: begin
          // 其他地址，不改动这两个寄存器
          //conv_start_n = conv_start_reg;
          pic_reg_n   = pic_reg;
          weight_n = weight;
        end
      endcase
    end
  end

  assign conv_start = conv_start_reg;
  assign pic        = pic_reg;
 // assign pic_valid  = (PSEL && PENABLE && PWRITE && reg_adr==`REG_PIXEL_IN);

  // --------------------------------------------------------------------------
  // STATUS 寄存器 (0x00 读) + OFM SRAM 读 (0x0C 起) APB读
  // --------------------------------------------------------------------------

always_ff @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn)begin             
      c_read_counter <= 10'd0;
      ready_counter <= 1'b0;
    end else begin                    
      c_read_counter <= c_read_counter_n;
      ready_counter <= ready_counter_n;
      //ofm_read_data_reg <= ofm_read_data;
    end
  end

always_comb begin
    sram_addr_rd_c = c_read_counter;
    c_read_counter_n = c_read_counter;
    ready_counter_n = ready_counter;
    PRDATA = 32'b0;
    ofm_read_en = 1'b0;
    if (PSEL && PENABLE && !PWRITE) begin
      case (reg_adr)
	`REG_RECORD:begin
		PRDATA = r_reg_pic_need;
	end
        `REG_STATUS:begin // 偏移 0x00,将conv_finish, conv_res_valid, need_pic送到总线
         PRDATA = {29'b0, status_reg};
         end
        `REG_SRAM:begin   // 偏移 0x0C，将SRAM中的结果送入总线
          PRDATA = {24'b0, ofm_read_data};
          if ( ready_counter==1'b1) begin
             ready_counter_n = 1'b0;
           if (c_read_counter == OFM_DEPTH ) begin
              c_read_counter_n = 10'd0;
           end else begin
              c_read_counter_n = c_read_counter + 1;
           end
         end else begin
             ready_counter_n = ready_counter + 1;
        end
        end
        default: begin
          PRDATA = 32'b0;
         end
      endcase
    end
  if(reg_adr == `REG_SRAM)begin
        ofm_read_en = 1'b1;
      end else begin
        ofm_read_en = 1'b0;
      end
  end
  
 always_comb begin
    if(reg_adr == `REG_SRAM)begin
        PREADY = ready_counter;
     end else begin
        PREADY = 1'b1;
    end
 end
  
  // --------------------------------------------------------------------------
  // 写ofm_sram
  // --------------------------------------------------------------------------
logic [10:0]            sram_addr,sram_addr_n;
//logic [1:0]             channel_counter,channel_counter_n;     // 通道选择（00, 01, 10, 11）
logic                   conv_res_valid;      // 来自 conv_control
logic [DATA_WIDTH-1:0]  conv_res, conv_res_reg;            // 来自 conv_control
logic [ADDR_BITS-1:0]   conv_res_addr,conv_res_addr_reg;       // 来自 conv_control
logic                   sram_we, sram_we_n;             // SRAM 写使能

assign conv_res_addr_reg = conv_res_addr;

// --------------------------------------------------------------------------
// 通道切换和计数控制
// --------------------------------------------------------------------------
always_ff @(posedge HCLK or negedge HRESETn) begin
  if (!HRESETn) begin             
    conv_res_reg <= '0;
    //conv_res_addr_reg <= '0;
    sram_we <= 1'b0;
   // channel_counter <= 2'b00;
    sram_addr <= '0;

  end else begin
    conv_res_reg <= conv_res;
    //conv_res_addr_reg <= conv_res_addr_n;
    sram_we <= sram_we_n;
    //channel_counter <= channel_counter_n;
    sram_addr <= sram_addr_n;
    
  end
end
//assign sram_w_data = conv_res_reg;
// --------------------------------------------------------------------------
// 地址选择（根据通道选择）
// --------------------------------------------------------------------------
always_comb begin
  //channel_counter_n = channel_counter;
  sram_addr_n = sram_addr;
  sram_we_n = sram_we;
  //conv_res_addr_n = conv_res_addr_reg;
  sram_addr_n = conv_res_addr_reg;

   if (conv_res_valid) begin
      sram_we_n = 1;  // 写入使能
    end else begin
      sram_we_n = 0;
    end
end

// --------------------------------------------------------------------------
// 读 ofm_sram
// --------------------------------------------------------------------------
logic                    read_sram_enable; // conv_ctrl发来的读使能
logic                    sram_data_valid, sram_data_valid_n;  // SRAM发给conv_ctrl的valid
//logic                    sram_rd_en, sram_rd_en_n;
logic [DATA_WIDTH - 1:0] sram_data;
logic [10:0]             sram_addr_rd, sram_addr_rd_rtl; 
//sram_addr_rd_n;  
//sram_addr_rd_reg;

always_ff @(posedge HCLK or negedge HRESETn) begin
  if (!HRESETn) begin             
    sram_data_valid <= 1'b0;
    //sram_addr_rd <= '0;
  end else begin
    //sram_addr_rd <= sram_addr_rd_n;
    sram_data_valid <= sram_data_valid_n;
  end
end

// SRAM 读取地址寄存器，延迟 28 地址
//assign sram_addr_rd_reg = conv_res_addr_reg - 28;
//assign sram_addr_rd_reg = conv_res_addr_reg;
  assign sram_addr_rd_rtl = conv_res_addr_reg;
always_comb begin
  sram_data_valid_n = sram_data_valid;
  //sram_rd_en_n = sram_rd_en;

  if (read_sram_enable) begin
   // sram_rd_en_n = 1'b1; // 启用读使能
    sram_data_valid_n = 1'b1;
    //sram_addr_rd_n = conv_res_addr_reg;

  end else begin
    //sram_rd_en_n = 1'b0;
    //sram_addr_rd_n = 0;
    sram_data_valid_n = 1'b0;
  end

end

assign sram_data = ofm_read_data;

//读写使能信号选择
logic  write_en, rd_en ;
assign rd_en = read_sram_enable || ofm_read_en;
assign write_en = rd_en ? 1'b0 : sram_we;

logic  [10:0] addr;
assign sram_addr_rd = (reg_adr == `REG_SRAM) ? sram_addr_rd_c : sram_addr_rd_rtl;
assign addr = rd_en? sram_addr_rd : sram_addr;

logic ry;

// --------------------------------------------------------------------------
// 实例化 ofm_sram，直接写入
// --------------------------------------------------------------------------
ofm_sram_1 #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_BITS (11)  // SPHDL100909，每个11位地址，一共4KB
) u_ofm (
  .clk      (HCLK),
  //.write_en (sram_rd_en),
  //.write_en (sram_we),
  .write_en (write_en),
  .addr     (addr),
  //.addr     (sram_addr),
  //.addr     (sram_addr_rd),
  .wdata    (conv_res_reg),
  .rdata    (ofm_read_data),
  .ry_out   (ry)
);

  // --------------------------------------------------------------------------
  // 将握手信号连给 conv_control
  // --------------------------------------------------------------------------
  //fake_
  serial_conv_control_integer u_conv (
    .clk                (HCLK),
    .rst_n              (HRESETn),
    .parallel_pic       (pic),
    .parallel_pic_valid (pic_valid),
    .parallel_weight_data            (weight),
    .parallel_weight_data_valid      (weight_valid), 
    .conv_start        (conv_start),
    .need_pic          (need_pic),
    .conv_finish       (conv_finish),
    .conv_result_valid (conv_res_valid),
    .conv_result       (conv_res),
    .conv_result_addr  (conv_res_addr),
    .read_previous_result_enable  (read_sram_enable),
    .previous_result_valid   (sram_data_valid),
    .previous_result         (sram_data)
  );
endmodule
