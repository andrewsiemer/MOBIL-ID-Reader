## What is MOBIL-ID?
#### A Python web service & embedded reader for Apple PassKit

The MOBIL-ID project is an engineering systems capstone project for Oklahoma Christian University. The team’s mission statement is to create a mobile platform front-end to Oklahoma Christian University’s user management system. Students and Faculty will use their mobile ID to gain chapel attendance, enter the university cafeteria, and pay using Eagle Bucks. While the MOBIL-ID Server is a closed-source system for security, the MOBIL-ID Reader is an open-source project.

### MOBIL-ID Reader
The MOBIL-ID Reader is a slave device responsible for scanning MOBIL-ID passes. It captures the QR data from a scanned pass and sends it in a GET request to the MOBIL-ID Server. The MOBIL-ID Server returns the associated user ID number. The MOBIL-ID Reader then hands the ID number to the transactional system via the USB connection. Below is a guide to creating a fully functional MOBIL-ID Reader.

### The MOBIL-ID Team
* Andrew Siemer - Electrical/Software Engineer - Team Lead
* Jacob Button - Electrical/Software Engineer
* Kyla Tarpey - Electrical Engineer
* Zach Jones - Computer/Software Engineer

### Acknowledgments
* Steve Maher - Professor/Mentor
* Luke Hartman - Customer/Mentor

---

## Hardware Setup
The Hardware Setup Guide is a long but detailed document that steps through the entire process of creating a MOBIL-ID Reader. The document can be viewed or downloaded from the link below.

### [View Hardware Setup Guide](https://docs.google.com/document/d/1EBEo_Zr7OZ9AODJT-2cf_hYnRvtXFjDW9OjWyJNuSes)


## Software Setup
### Prerequisites
* [Install Raspberry Pi OS LITE using Raspberry Pi Imager](https://www.raspberrypi.org/software/)
* [Headless Raspberry Pi Setup](https://pimylifeup.com/headless-raspberry-pi-setup/)

### Raspberry Pi First Boot
Before we start, check that you have:

* A clean installation of Raspberry Pi OS LITE on a microSD card
* Added the `ssh` file to the `/boot` directory
* Added the `wpa_supplicant.conf` file to the `/boot` directory

**You will not be able to continue without completing these steps. Use the links above to properly allow headless setup.**

If you are confident you have completed the steps above, put the microSD card into the Raspberry Pi and plug the USB power cable in.
You should hear a startup beep and the LED on the MOBIL-ID Reader Board should be magenta. If one of theses did not happen, you will need to troubleshoot your hardware setup.

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
| Turquoise | connecting to network/updating software (<30 secs) |
| Yellow | waiting to connect to server |
| Green | connected, ready to scan |
| Red | processing scan |
