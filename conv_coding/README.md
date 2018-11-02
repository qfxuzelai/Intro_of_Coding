# 代码分工

## 邓程昊
* 信道的实现：
  - my_channel.m 信道实现模块
  
* ASK映射设计：
  - ASK_mod.m ASK映射模块
  - ASK_demod.m ASK判决模块
  - ASK_sim.m ASK仿真分析

## 齐涛
* PHIMAP算法设计：
  - process_phi.m PHIMAP算法求解偏转PHI

* CRC模块：
  - CRC_encode.m CRC模块编码
  - CRC_decode.m CRC模块解码
  - CRC_Init_error_table.m CRC初始化矫正子误码图案对应表


## 徐泽来
* BMPSK映射设计：
  - BMPSK_mod.m BMPSK映射模块
  - BMPSK_demod.m BMPSK判决模块
  - BMPSK_sim.m BMPSK仿真分析
  - BMPSK_tradeoff.m BMPSK参数折衷

* 卷积码编译码：
  - conv_encode.m 卷积码编码模块
  - conv_hdecode.m 卷积码硬判决模块
  - conv_sdecode.m 卷积码软判决模块
  - conv_sim.m 卷积码仿真分析
  
## 说明
* 上述代码仅为各个功能模块和部分仿真分析，还有部分代码是直接在模块之间做调整，简便起见在此略去。
* 综合考虑讨论、设计、实现、仿真、分析、报告各个部分的情况，我们认为我们小组基本是均匀分配的工作量。
