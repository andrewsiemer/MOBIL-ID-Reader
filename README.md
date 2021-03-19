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
In macOS/Linux, open Terminal:
```sh
ssh pi@raspberrypi.local
```
The default password is `raspberry`.

### Run the MOBIL-ID-Reader Installer
Once you are logged into as user `pi` run:
``` sh
curl https://raw.githubusercontent.com/andrewsiemer/MOBIL-ID-Software/master/reader/software/install.sh > install.sh && sudo bash install.sh
```
This script installs software for the MOBIL-ID Reader on the Raspberry Pi.
This includes:
- Creating a new hostname & password
- Updating the package index files (apt-get update)
- Installing prerequisite software
- Installing MOBIL-ID software and examples
- Configuring boot options

Run time ~20 minutes. Reboot recommended after install.
EXISTING INSTALLATION, IF ANY, WILL BE OVERWRITTEN.

> Please note the MOBIL-ID Reader will not work correctly until the system has been rebooted.

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
