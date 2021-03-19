'''
rgb.py: A library to control a 5050 RGB LED
'''
import RPi.GPIO as GPIO
import time

class C193878(): # JLCPCB Part #
    def __init__(self, r_pin: int, g_pin: int, b_pin: int):
        self.RED = r_pin
        self.GREEN = g_pin
        self.BLUE = b_pin

        self.setup_pins()

    def setup_pins(self):
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)

        # Set up the GPIO pins as red, green and blue, 
        # tell them to turn off.
        GPIO.setup(self.RED, GPIO.OUT)
        GPIO.setup(self.GREEN, GPIO.OUT)
        GPIO.setup(self.BLUE, GPIO.OUT)
        self.off()


    def set_green(self):        
        GPIO.output(self.RED, GPIO.LOW)
        GPIO.output(self.GREEN, GPIO.HIGH)
        GPIO.output(self.BLUE, GPIO.LOW)

    def set_red(self):
        GPIO.output(self.RED, GPIO.HIGH)
        GPIO.output(self.GREEN, GPIO.LOW)
        GPIO.output(self.BLUE, GPIO.LOW)

    def set_yellow(self):
        GPIO.output(self.RED, GPIO.HIGH)
        GPIO.output(self.GREEN, GPIO.HIGH)
        GPIO.output(self.BLUE, GPIO.LOW)
    
    def set_blue(self):
        GPIO.output(self.RED, GPIO.LOW)
        GPIO.output(self.GREEN, GPIO.LOW)
        GPIO.output(self.BLUE, GPIO.HIGH)

    def set_turquoise(self):
        GPIO.output(self.RED, GPIO.LOW)
        GPIO.output(self.GREEN, GPIO.HIGH)
        GPIO.output(self.BLUE, GPIO.HIGH)

    def set_magenta(self):
        GPIO.output(self.RED, GPIO.HIGH)
        GPIO.output(self.GREEN, GPIO.LOW)
        GPIO.output(self.BLUE, GPIO.HIGH)

    def set_white(self):
        GPIO.output(self.RED, GPIO.HIGH)
        GPIO.output(self.GREEN, GPIO.HIGH)
        GPIO.output(self.BLUE, GPIO.HIGH)

    def set_black(self):
        GPIO.output(self.RED, GPIO.LOW)
        GPIO.output(self.GREEN, GPIO.LOW)
        GPIO.output(self.BLUE, GPIO.LOW)
    
    def on(self):
        self.set_white()

    def off(self):
        self.set_black()
