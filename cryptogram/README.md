# 代码分工

## 邓程昊
* 波形信道仿真：
    - wave_mod.m 波形成形与调制模块
    - wave_demod.m 波形解调与采样模块
    - wave_awgn_channel.m 波形加性高斯白噪声信道模块
    - platform.m 仿真平台
* 里德-索罗蒙码
    - RS_encode.m RS码编码模块
    - RS_decode.m RS码解码模块

## 齐涛
* RSA非对称加密：
	- rsa\_encode\_signal.m 将一个512bit的bit串进行RSA加密
	- rsa\_encode.m  一个bit串进行RSA加密
	- rsa\_generate\_key.m 生成私钥、公钥
	
* GF(p)上的椭圆曲线加密：
	- convert\_symdec\_to\_bin.m 将sym变量下的十进制变量转换成二进制数组（辅助文件）
	- ellipse\_p\_add\_noequal.m 将不互为相反数的两个点相加 
	- ellipse\_p\_add.m 任意两个点相加
	- ellipse\_p\_generate\_key.m 生成随机私钥、公钥
	- ellipse\_p\_multi.m 椭圆曲线运算下的乘法（即私钥和生成原相乘）
	- inverse\_gfp.m GF(p)域下的求逆模块

## 徐泽来
* AES对称密码：
    - AES_enc.m AES加密模块
    - AES_dec.m AES解密模块
    - AES_key.m AES密钥生成模块
    - AES_box.m AES查找表生成
    - AES_sim.m AES仿真分析
  
## 说明
* 上述代码仅为各个功能模块和部分仿真分析，还有部分代码是直接在模块之间做调整，简便起见在此略去。
* 综合考虑讨论、设计、实现、仿真、分析、报告各个部分的情况，我们认为我们小组基本是均匀分配的工作量。
