''' main.py: A Python QR code reader and USB-HID keyboard emulator
Built to interact with the MOBIL-ID web service for Apple PassKit '''

import time, subprocess

import serial, requests, git

import config
from include.hid import Keyboard
from include.rgb import C193878

# Create keyboard object for HID keyboard emulation
ser = None
kbd = Keyboard()
led = C193878(2,4,3)
WEB_SERVICE_URL = 'https://mobileid.oc.edu'

def check_for_updates():
    '''
    Checks for updates from GitHub, 
    if update availiable, installs and restarts service
    '''
    print('Checking for update...')
    led.set_turquoise()

    try:
        repo = git.Repo('/home/pi/MOBIL-ID-Reader')

        current = repo.head.commit
        repo.remotes.origin.pull()
        if current != repo.head.commit:
            print("Installing updates...")
            repo.remotes.origin.pull()
            subprocess.call('sudo systemctl restart mobil-id.service', shell=True)
            quit()
    except:
        pass

# Setup UART for TTL signal from MAX232 chip
def setup_serial():
    '''
    Sets up serial object for RTscan830A
    '''
    print('Setting up serial port...')
    global ser
    ser = serial.Serial(
        port='/dev/ttyS0',
        baudrate = 115200,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=0.01
    )

def setup_ibeacon():
    '''
    Turns on bluetooth iBeacon
    '''
    print('Turning on iBeacon...')
    led.set_blue()
    
    subprocess.call('sudo hciconfig hci0 up', shell=True)
    subprocess.call('sudo hciconfig hci0 leadv 3', shell=True)
    subprocess.call('sudo hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 06 1A FF 4C 00 02 15 1F 23 44 54 CF 6D 4A 0F AD F2 F4 91 1B A9 FF A9 00 01 00 01 C8 00', shell=True)

def ping_server():
    '''
    Pings server until valid response
    '''
    while 1:
        led.off()
        try:
            r = requests.get(WEB_SERVICE_URL, timeout=1)
            if r.status_code == 200:
                break
            else:
                raise Exception('')
        except:
            led.set_yellow()
            time.sleep(1)


if __name__ == "__main__":

    check_for_updates()
    ping_server()
    setup_serial()
    setup_ibeacon()

    while 1:
        led.set_green()
        # read line from UART
        x = ser.readline()
        # input recived, start timer
        #start = time.time()
        if len(x) > 1:
            led.set_red()
            try:
                # if input is more than a CR,
                # decode binary data to str
                qr_hash = x.decode('utf-8')

                # try to GET ID number from server
                r = requests.get(WEB_SERVICE_URL + '/scan/' + qr_hash + '?reader=' + config.SERIAL_NUMBER, timeout=1)
                if r.status_code == 200:
                    id_number = r.json()

                    # write ID number to host keyboard
                    kbd.write(str(id_number) + '\n')

                    #print('QR Hash: ' + qr_hash + '     ID Number: ' + id_number + '     (' + str(round(((time.time() - start)*1000), 2)) + ' ms)')
                else:
                    raise Exception('204')

            except Exception as error:
                # exception during GET request,
                # return HTTP status code
                print(error)
                if error != '204':
                    ping_server()

