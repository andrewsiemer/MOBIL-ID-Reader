## Hardware Setup (WIP)
### Parts
* Raspberry Pi Zero W
* 8GB microSD card
* microUSB to USB-A cable
* MAX232 Breakout Board
* RTscan RT830A Scanner
* 3D Printed Housing (optional)

| Part | Cost | Description |
| ----------- | ----------- | --------- |
| [RTscan RT830A](https://www.rtscan.net/Code-Readers/hands-free-bar-code-scanner-rt830a/) | $55-68 | hands-free 2D and QR bar code scanner |
| [10-pin IDC cable](https://www.adafruit.com/product/556?gclid=CjwKCAiA9bmABhBbEiwASb35V9Td5R1iaUAHqUNImX9ycXJjJYyvrB65bvPPx45-ikyqEljMJOcw4RoCfNQQAvD_BwE) | $1.50 | 10-pin Socket/Socket IDC cable - Short 1.5" |
| [Header - 2x5 Pin](https://www.sparkfun.com/products/15362) | $1.50 | male, 1.27mm |
| [2x5 Pin Shrouded Header](https://www.sparkfun.com/products/8506) | $1.50 |  shrouded 10-pin connector on 0.1" centers |
| [Raspberry Pi Zero W](https://www.adafruit.com/product/3400) | $10.00 |  header-less Pi Zero with Wifi |
| MOBIL-ID Reader Board | $4.00 | breakout board for MAX232 & status LED |
| 3D Printed Assembly | $4.00 | housing and fasteners for scanner, pi, & breakout board |
| [16 GB microSD Card](https://www.amazon.com/8-Pack-Bulk-Micro-Memory-Adapter/dp/B081CGNB9Y) | $3.75 | microSD card for Raspberry PI |
| [microUSB to USB-A Cable ](https://www.amazon.com/Anker-6-Pack-Powerline-Micro-USB/dp/B015XPU7RC/) | $2.85 | data cable that also powers Raspberry Pi |


### Tools
* Soldering Iron & Solder
* Wirestripers
* Heatshrink
* 22 AWG copper wire

...

## Software Setup
### Prerequisites
* [Install Raspberry Pi OS LITE using Raspberry Pi Imager](https://www.raspberrypi.org/software/)
* [Headless Raspberry Pi Setup](https://pimylifeup.com/headless-raspberry-pi-setup/)

### Login to Raspberry Pi Remotely
In macOS, open Terminal:
```sh
ssh pi@raspberrypi.local
```
The default password is `raspberry`.

### Change the Default Hostname
To start, we need to modify a file called hostname that resides in the /etc/ folder.

Begin modifying this file by running the following command within the terminal of your Raspberry Pi.
```sh
sudo nano /etc/hostname
```

To change your hostname, all you need to do is swap out the one in this file.
Change the file, so it looks like the following. Swap the `XXX` with a unique device identifier.
```
mobil-id-reader-XXX
```
Save the file by pressing CTRL + X, then Y, followed by ENTER.

Next, we need to modify the /etc/hosts file as the hostname is referenced within there too.
```sh
sudo nano /etc/hosts
```

Within this file, find the following line and replace the hostname with the one used before.
Find:
```
127.0.1.1       raspberrypi
```
Replace With:
```
127.0.1.1       mobil-id-reader-XXX
```
> Again, do not use `XXX`, this is simply a placeholder for you to put a unique identifier!

Save the file by pressing CTRL + X, then Y, followed by ENTER.

**Later when you reboot the Raspberry Pi, you will then need to remotely access it using:**
```sh
ssh pi@mobil-id-reader-XXX.local
```

### Change the Default Password
While the default password on Raspbian is incredibly easy to remember, it should be changed to something a bit more secure.
Change the password by running the following command:
```sh
passwd
```

When running this command, you will be first asked to enter the current password before proceeding.
This should be `raspberry`.
```
Changing password for pi.
Current password:
```

You will then be asked to enter a new password for the Raspberry Pi user to login to Raspbian with.
```
New password:
Retype new password:
```
The password will need to be entered twice to confirm the password change for your Raspberry Pi.

**Next time you remotely access the Raspberry Pi you will use the new password.**

### Enable the Modules and Drivers for HID Gadget
Run these three commands to enable the necessary modules and drivers:
```sh
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
sudo echo "libcomposite" | sudo tee -a /etc/modules
```

### Configuring the HID Gadget
Now, you have to define your Raspberry Pi Zero (HID gadget) as a USB keyboard. The configuration is done via ConfigFS, a virtual file system located in /sys/.

The configuration is volatile, so it must run on each startup. Create a new file called mobilid_usb in /usr/bin/ and make it executable:
```sh
sudo touch /usr/bin/mobilid_usb
sudo chmod +x /usr/bin/mobilid_usb
```
Then, you need to run this script automatically at startup. Open /etc/rc.local with this command:
```sh
sudo nano /etc/rc.local
```
Add the following before the line containing `exit 0`:
```sh
/usr/bin/mobilid_usb # libcomposite configuration
```

### Creating the HID Gadget
Open the file with:
```sh
sudo nano /usr/bin/mobilid_usb
```

Copy the following lines into the file:
```sh
#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p mobilid
cd isticktoit
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
mkdir -p strings/0x409
echo "1" > strings/0x409/serialnumber
echo "Oklahoma Christian University" > strings/0x409/manufacturer
echo "MOBIL-ID USB Device" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower

# Add functions here
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 8 > functions/hid.usb0/report_length
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 > functions/hid.usb0/report_desc
ln -s functions/hid.usb0 configs/c.1/
# End functions

ls /sys/class/udc > UDC
```
To save the file, press Ctrl+X followed by Y and Enter.

Finally, reboot the Raspberry Pi:
```sh
sudo reboot
```

> You will need to relogin remotely to the Raspberry Pi using the new login creditials created above

### Install MOBIL-ID Reader Software
Download the MOBIL-ID-Software repository and navigate to `reader/`:
```sh
cd MOBIL-ID-Software/reader
```

Run the main script using Python3:
```sh
sudo python3 main.py
```

> Make sure the host computer is ready for keyboard input (active textbox)

The reader is then ready to scan a pass. If the pass has valid data, the user ID number will show up on the computer the Raspberry Pi is connected to. If the pass data is invalid or the reader cannot establish a connection with the MOBIL-ID Server, check the console for error messages.

### Running the MOBIL-ID Reader Software on Boot (WIP)
So that you do not have to relogin and start the program every time manually, we will use SYSTEMD to start the program after boot.

Open a sample unit file using the command:
```sh
sudo nano /lib/systemd/system/sample.service
```

Add in the following text :
```
[Unit]
Description=My Sample Service
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/bin/python /home/pi/sample.py

[Install]
WantedBy=multi-user.target
````
To save the file, press Ctrl+X followed by Y and Enter.

> Note that the paths are absolute and define the complete location of Python as well as the location of our Python script.

In order to store the script’s text output in a log file you can change the ExecStart line to:
```sh
ExecStart=/usr/bin/python /home/pi/sample.py > /home/pi/sample.log 2>&1
```

The permission on the unit file needs to be set to 644:
```
sudo chmod 644 /lib/systemd/system/sample.service
```

Now the unit file has been defined we can configure systemd to start it during the boot sequence:
```sh
sudo systemctl daemon-reload
sudo systemctl enable sample.service
```

Reboot the Raspberry  Pi and your custom service should run:
```sh
sudo reboot
```

## References
### Hardware
*

### Raspberry Pi Setup
* [Changing the Raspberry Pi's Hostname](https://pimylifeup.com/raspberry-pi-hostname/)
* [Changing the Raspberry Pi's Password](https://pimylifeup.com/default-raspbian-username-and-password/)
* [Pi USB Keyboard](https://randomnerdtutorials.com/raspberry-pi-zero-usb-keyboard-hid/) - setup pi as HID keyboard
* [Start Program on Boot](https://www.dexterindustries.com/howto/run-a-program-on-your-raspberry-pi-at-startup/) - Start Program on Boot

### MOBIL-ID Software
*
