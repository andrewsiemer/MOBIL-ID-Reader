import time, serial

# Setup UART for TTL signal from MAX232 chip
ser = serial.Serial(
    port='/dev/ttyS0',
    baudrate = 115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=0.1
)

while 1:
    x = ser.readline()
    print(x)
