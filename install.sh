#!/bin/bash

# INSTALLER SCRIPT FOR MOBIL-ID Reader

if [ $(id -u) -ne 0 ]; then
	echo "Installer must be run as root."
	echo "Try 'sudo bash $0'"
	exit 1
fi

clear

echo "This script installs software for the"
echo "MOBIL-ID Reader on the Raspberry Pi."
echo "This includes:"
echo "- Update package index files (apt-get update)"
echo "- Install prerequisite software"
echo "- Install MOBIL-ID software and examples"
echo "- Configure boot options"
echo "Run time ~20 minutes. Reboot recommended after install."
echo "EXISTING INSTALLATION, IF ANY, WILL BE OVERWRITTEN."
echo
echo -n "CONTINUE? [Y/n] "
read
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then
	echo "Canceled."
	exit 0
fi

clear

# FEATURE PROMPTS ----------------------------------------------------------

echo "To setup a new MOBIL-ID Reader we will need to"
echo "first reset the default hostname and password."
echo
echo "We want to set the hostname to MOBIL-ID-Reader-XXX"
echo "where XXX is a unique identifier for the device."
echo
echo -n "Enter a unique identifier for this device: "
read ID
echo
echo "Hostname will be changed to MOBIL-ID-Reader-"$ID

echo
echo "Now lets change the default password (raspberry)."
sudo passwd pi

echo
echo "Done."
echo
read -n 1 -s -r -p "Press any key to continue."

clear

# START INSTALL ------------------------------------------------------------

echo "Starting installation..."
echo "Updating package index files..."
sudo apt-get update -y

echo "Downloading prerequisites..."
sudo apt install git-all -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-venv

echo "Downloading MOBIL-ID Reader software..."
cd /home/pi
git clone https://github.com/andrewsiemer/MOBIL-ID-Reader

echo "Setting up virtual environment..."
python3 -m venv /home/pi/MOBIL-ID-Reader
cd /home/pi/MOBIL-ID-Reader
source bin/activate

echo "Downloading dependencies..."
pip3 install -r requirements.txt

# CONFIG -------------------------------------------------------------------

echo "Configuring system..."
sudo sed -i 's+ init=/bin/systemd++' /boot/cmdline.txt
sudo sed -i 's+$+ init=/bin/systemd+' /boot/cmdline.txt

echo "Setting up USB Gadget..."
sudo sed -i '/dtoverlay=dwc2/d' /boot/config.txt
sudo sed -i '/dwc2/d' /etc/modules
sudo sed -i '/libcomposite/d' /etc/modules
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
sudo echo "libcomposite" | sudo tee -a /etc/modules

echo "Creating USB Keyboard Service..."
sudo touch /usr/bin/mobil_id_usb
sudo chmod +x /usr/bin/mobil_id_usb

sudo sed -i '/mobil_id_usb/d' /etc/rc.local
sudo sed -i '19 a /usr/bin/mobil_id_usb # libcomposite configuration' /etc/rc.local

sudo tee -a /usr/bin/mobil_id_usb > /dev/null << EOT
#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p mobil_id
cd mobil_id
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
mkdir -p strings/0x409
echo "$ID" > strings/0x409/serialnumber
echo "Oklahoma Christian University" > strings/0x409/manufacturer
echo "MOBIL-ID Reader" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
# Add functions here
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 8 > functions/hid.usb0/report_length
echo -ne \\\x05\\\x01\\\x09\\\x06\\\xa1\\\x01\\\x05\\\x07\\\x19\\\xe0\\\x29\\\xe7\\\x15\\\x00\\\x25\\\x01\\\x75\\\x01\\\x95\\\x08\\\x81\\\x02\\\x95\\\x01\\\x75\\\x08\\\x81\\\x03\\\x95\\\x05\\\x75\\\x01\\\x05\\\x08\\\x19\\\x01\\\x29\\\x05\\\x91\\\x02\\\x95\\\x01\\\x75\\\x03\\\x91\\\x03\\\x95\\\x06\\\x75\\\x08\\\x15\\\x00\\\x25\\\x65\\\x05\\\x07\\\x19\\\x00\\\x29\\\x65\\\x81\\\x00\\\xc0 > functions/hid.usb0/report_desc
ln -s functions/hid.usb0 configs/c.1/
# End functions
ls /sys/class/udc > UDC
EOT

echo "Creating MOBIL-ID Reader Startup Service..."
if test -f "/lib/systemd/system/mobil-id.service"; then
    sudo rm /lib/systemd/system/mobil-id.service
fi

sudo tee -a /lib/systemd/system/mobil-id.service > /dev/null << EOT
[Unit]
Description=MOBIL-ID Reader
After=multi-user.target

[Service]
Type=idle
ExecStart=/usr/bin/sudo /home/pi/MOBIL-ID-Reader/bin/python3 /home/pi/MOBIL-ID-Reader/main.py > /home/pi/system.log 2>&1

[Install]
WantedBy=multi-user.target
EOT

touch /home/pi/system.log
sudo chmod +x /home/pi/system.log

sudo chmod 644 /lib/systemd/system/mobil-id.service
sudo systemctl daemon-reload
sudo systemctl enable mobil-id.service

echo "Starting MOBIL-ID Reader service..."
sudo systemctl start mobil-id.service

echo "Enabling UART..."
sudo sed -i '/enable_uart/d' /boot/config.txt
echo "enable_uart=1" | sudo tee -a /boot/config.txt

sudo sed -i '/raspberrypi/d' /etc/hostname
sudo sed -i '/MOBIL-ID-Reader-/d' /etc/hostname
sudo sed -i '/raspberrypi/d' /etc/hosts
sudo sed -i '/MOBIL-ID-Reader-/d' /etc/hosts
echo "MOBIL-ID-Reader-"$ID | sudo tee -a /etc/hostname
echo "127.0.1.1       MOBIL-ID-Reader-"$ID | sudo tee -a /etc/hosts

# PROMPT FOR REBOOT --------------------------------------------------------
echo
echo "Done."
echo
echo "Install will take effect on next boot."
echo
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
echo "Upon reboot, ssh into the Raspberry Pi using:"
echo
echo "ssh pi@MOBIL-ID-Reader-"$ID".local"
echo
echo "...and your new password."
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
echo
echo -n "REBOOT NOW? [Y/n] "
read
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then
	echo "Exiting without reboot."
	exit 0
fi
echo "Reboot started..."

reboot
sleep infinity