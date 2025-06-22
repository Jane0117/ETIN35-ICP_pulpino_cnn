`define REG_CTRL       2'd0   // 偏移 0x00: CTRL（读写共址，写=启动，读=STATUS 返回）
`define REG_STATUS     2'd0   // STATUS 和 CTRL 共用偏移 0x00，读时输出 STATUS

module test_wrapper (
  input  logic                     HCLK,
  input  logic                     HRESETn,

  // -- APB 从机接口 -- 
  input  logic               [31:0] PADDR,
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

  // --------------------------------------------------------------------------
  // 将 APB 事务对齐到寄存器索引
  // --------------------------------------------------------------------------
  logic [1:0] reg_adr;
  assign reg_adr = PADDR[3:2];
  assign PSLVERR = 1'b0;
    assign PREADY = 1'b1;
assign irq_o = 0;
  // --------------------------------------------------------------------------
  // 与 conv_control 握手信号
  // --------------------------------------------------------------------------
  logic                   need_pic, need_pic_n;        // 来自 conv_control

  always_ff @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn)begin             
      need_pic <= 1'b0;     
    end else begin                    
      need_pic <= need_pic_n;
    end
  end
  
always_comb begin
    
    if (PSEL && PENABLE && PWRITE && reg_adr == `REG_CTRL) begin
          need_pic_n = PWDATA[0];
    end
    
    if (PSEL && PENABLE && !PWRITE && reg_adr ==`REG_STATUS) begin
         PRDATA = {31'b0, need_pic};
    end
       

  end


  endmodule
