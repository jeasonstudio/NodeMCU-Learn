  
SMPLRT_DIV = 0x19    --采样率分频，典型值=：0x07(125Hz) */
CONFIG  = 0x1A       -- 低通滤波频率，典型值=：0x06(5Hz) */
GYRO_CONFIG = 0x1B   -- 陀螺仪自检及测量范围，典型值=：0x18(不自检，2000deg/s) */
ACCEL_CONFIG = 0x1C  -- 加速计自检、测量范围及高通滤波频率，典型值=：0x01(不自检，2G，5Hz) */
 
ACCEL_XOUT_H = 0x3B  -- 存储最近的X轴、Y轴、Z轴加速度感应器的测量值 */
ACCEL_XOUT_L = 0x3C
ACCEL_YOUT_H = 0x3D
ACCEL_YOUT_L = 0x3E
ACCEL_ZOUT_H = 0x3F
ACCEL_ZOUT_L = 0x40
 
TEMP_OUT_H = 0x41   -- 存储的最近温度传感器的测量值 */
TEMP_OUT_L = 0x42
 
GYRO_XOUT_H = 0x43 -- 存储最近的X轴、Y轴、Z轴陀螺仪感应器的测量值 */
GYRO_XOUT_L = 0x44 
GYRO_YOUT_H = 0x45
GYRO_YOUT_L = 0x46
GYRO_ZOUT_H = 0x47
GYRO_ZOUT_L = 0x48
 
PWR_MGMT_1 = 0x6B -- 电源管理，典型值=：0x00(正常启用) */
WHO_AM_I = 0x75 --IIC地址寄存器(默认数=值0x68，只读) */

id=0
sda=1
scl=2

-- 初始化i2c, 将pin1设置为sda, 将pin2设置为scl
iicSpeed = i2c.setup(id,sda,scl,i2c.SLOW)
print("Running ... AND i2cSpeed is " .. iicSpeed)

-- 用户定义函数:读取地址dev_addr的寄存器reg_addr中的内容。
function read_reg(dev_addr, reg_addr)
    i2c.start(id)
    i2c.address(id, dev_addr ,i2c.TRANSMITTER)
    i2c.write(id,reg_addr)
    i2c.stop(id)
    i2c.start(id)
    i2c.address(id, dev_addr,i2c.RECEIVER)
    c=i2c.read(id,1)
    i2c.stop(id)
    return c
end

tmr.alarm(1, 1000, tmr.ALARM_AUTO, function()
    -- 读取0x77的寄存器0xAA中的内容。
    reg = read_reg(0x69, 0x40)
    print(string.byte(reg))
end)