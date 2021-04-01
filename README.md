## What is MOBIL-ID?
#### A Python web service & embedded reader for Apple PassKit

The MOBIL-ID project is an engineering systems capstone project for Oklahoma Christian University. The team’s mission statement is to create a mobile platform front-end to Oklahoma Christian University’s user management system. Students and Faculty will use their mobile ID to gain chapel attendance, enter the university cafeteria, and pay using Eagle Bucks. While the MOBIL-ID Server is a closed-source system for security, the MOBIL-ID Reader is an open-source project.

### MOBIL-ID Reader
The MOBIL-ID Reader is a slave device responsible for scanning MOBIL-ID passes. It captures the QR data from a scanned pass and sends it in a GET request to the MOBIL-ID Server. The MOBIL-ID Server returns the associated user ID number. The MOBIL-ID Reader then hands the ID number to the transactional system via the USB connection. Below is a guide to creating a fully functional MOBIL-ID Reader.

### The MOBIL-ID Team
- Andrew Siemer - Electrical/Software Engineer - Team Lead
- Jacob Button - Electrical/Software Engineer
- Kyla Tarpey - Electrical Engineer
- Zach Jones - Computer/Software Engineer

### Acknowledgments
- Steve Maher - Professor/Mentor
- Luke Hartman - Customer/Mentor

---

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
| [MOBIL-ID Reader Board](/pcb) | $4.00 | breakout board for MAX232 & status LED |
| [3D Printed Assembly](/stl) | $4.00 | housing and fasteners for scanner, pi, & breakout board |
| [16 GB microSD Card](https://www.amazon.com/8-Pack-Bulk-Micro-Memory-Adapter/dp/B081CGNB9Y) | $3.75 | microSD card for Raspberry PI |
| [microUSB to USB-A Cable ](https://www.amazon.com/Anker-6-Pack-Powerline-Micro-USB/dp/B015XPU7RC/) | $2.85 | data cable that also powers Raspberry Pi |


### Tools
* 
*


### RTscan RT830A Setup
With the RTscan unit powered on scan the codes below to program the device.

First, scan this barcode to set the device to factory defaults.

![Resore to Factory Defaults](/img/restore-defaults.png)

Next, scan this barcode to set the device to RS232 mode.

![Set to RS232 Mode](/img/RS232.png)

Lastly, scan this barcode to set the successful read tone to medium.

![Set Success Beep Medium](/img/beep-medium.png)

...

## Software Setup
### Prerequisites
* [Install Raspberry Pi OS LITE using Raspberry Pi Imager](https://www.raspberrypi.org/software/)
* [Headless Raspberry Pi Setup](https://pimylifeup.com/headless-raspberry-pi-setup/)

### Rsapberry Pi First Boot
Before we start, check that you have:
1. A clean installation of Raspberry Pi OS LITE on a microSD card
2. Added the `ssh` file to the `/boot` directory
3. Added the `wpa_supplicant.conf` file to the `/boot` directory

**You will not be able to continue without completing these steps. Use the links above to properly allow headless setup.**

If you are confident you have completed the steps above, put the microSD card into the Raspberry Pi and plug the USB power cable in.
You should hear a startup beep and the LED on the MOBIL-ID Reader Board should be magenta. If one of theses did not happen, you will need to troubleshoot your hardware setup

### Login to Raspberry Pi Remotely
In macOS/Linux, open Terminal:
```sh
ssh pi@raspberrypi.local
```
The default password is `raspberry`.

### Run the MOBIL-ID Reader Installer
Once you are logged into as user `pi` run:
``` sh
curl https://raw.githubusercontent.com/andrewsiemer/MOBIL-ID-Reader/main/install.sh > install.sh && sudo bash install.sh
```
This script installs software for the MOBIL-ID Reader on the Raspberry Pi.
This includes:
* Creating a new hostname & password
* Updating the package index files (apt-get update)
* Installing prerequisite software
* Installing MOBIL-ID software and examples
* Configuring boot options

**Run time ~20 minutes. Reboot recommended after install. EXISTING INSTALLATION, IF ANY, WILL BE OVERWRITTEN.**

> Please note the MOBIL-ID Reader will not work correctly until the system has been rebooted.

## MOBIL-ID Reader Status Codes
Once the MOBIL-ID Reader software is installed correctly and has been rebooted, the unit will use the LED on the MOBIL-ID Reader Board to show its status.
| LED Color | Description |
| ----------- | ----------- |
| Magenta | reader powered, starting program (~1 min) |
| Turquoise | getting software update (<30 secs) |
| Yellow | waiting to connect to server |
| Green | connected, ready to scan |
| Red | processing scan |
