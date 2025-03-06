# PiAware Installer
This script automates the installation of PiAware, dump1090-fa, Cloudflared, Prometheus Node Exporter (optional), and UFW firewall (optional) on a Raspberry Pi.

## Purpose
Keisei11.com is Japanese junior-high school students Tech group.
We try to create own ADS-B Network to see Airplanes map.
Therefore we make many ADS-B receiver,and use this script.

## Features
- Installs and configures PiAware and dump1090-fa for ADS-B tracking
- Installs Cloudflared for secure tunneling
- Optionally installs Prometheus Node Exporter for system monitoring
- Optionally configures UFW firewall for security

## Requirements
- Raspberry Pi running a Debian-based OS (Checked Raspberry Pi OS Lite 64bit on RPi Zero 2W)
- Internet connection

## Installation
1. Clone this repository:
   ```sh
   git clone https://github.com/your-repo/piaware-installer.git
   cd piaware-installer
   ```

2. Make the script executable:
   ```sh
   chmod +x install.sh
   ```

3. Run the script:
   ```sh
   ./install.sh
   ```

## Options
During the installation, you will be prompted to:
- Choose your Raspberry Pi architecture for Cloudflared installation
- Enter a Cloudflared service token
- Install Prometheus Node Exporter (optional)
- Install and configure UFW firewall (optional)

## License
This project is licensed under the MIT License.

## Author
Created by @negishi_tako at Keisei11.com