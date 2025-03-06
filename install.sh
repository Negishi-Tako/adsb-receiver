#system
echo "Updating system..."
sudo apt update
sudo apt upgrade -y
echo "Successfully updated system"

#piaware
echo "Installing piaware feeder..."
curl -L --output flightaware.deb https://ja.flightaware.com/adsb/piaware/files/packages/pool/piaware/f/flightaware-apt-repository/flightaware-apt-repository_1.2_all.deb
sudo dpkg -i flightaware.deb
sudo apt update
sudo apt install -y piaware
echo "systemctl setting..."
sudo piaware-config allow-auto-updates yes
sudo piaware-config allow-manual-updates yes
echo "Successfully installed piaware"

#dump1090-fa
echo "Installing dump1090-fa..."
sudo apt install -y dump1090-fa
echo "systemctl setting..."
sudo systemctl enable dump1090-fa
echo "Successfully installed dump1090-fa"

#cloudflared
echo "Select your architecture:"
echo "1) armhf (Raspberry Pi 1-2, Zero, Zero W, or Compute Module)"
echo "2) arm64 (Raspberry Pi 3, 4, or Compute Module)"
echo "3) Other"
read -p "Enter the number corresponding to your architecture: " architecture
case $architecture in
    1)
        ARCH="armhf"
        URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-armhf.deb"
        ;;
    2)
        ARCH="arm64"
        URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb"
        ;;
    3)
        echo "See the latest release at"
        echo "https://github.com/cloudflare/cloudflared/releases/"
        read -p "Enter the URL to install: " URL
        ;;
    *)
        echo "Invalid option. Exiting."
        echo "See the latest release at"
        echo "https://github.com/cloudflare/cloudflared/releases/"
        read -p "Enter the URL to install: " URL
        ;;
esac
echo "Installing cloudflared for $ARCH..."
curl -L --output cloudflared.deb $URL
sudo dpkg -i cloudflared.deb
read -p "Enter the cloudflared service token: " token
    sudo cloudflared service install $token

cloudflared tunnel login
echo "Successfully installed cloudflared and Please logged in ▲From this link▲"
echo "--------------------------------------------------------------------------------"
echo "systemctl setting..."
sudo systemctl enable cloudflared
echo "Successfully installed cloudflared"

#prometheus-node-exporter
echo "Installing Node-Exporter(For Surveillance):"
read -p "You can choose install [Y/n]: " nodeexpchoice
case $nodeexpchoice in
    Y)
        echo "Installing Node-Exporter..."
        sudo apt install -y prometheus-node-exporter
        sudo systemctl enable prometheus-node-exporter
        echo "Successfully installed Node-Exporter."
        ;;
    n)
        echo "Skipping Node-Exporter installation."
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac

#firewall
echo "You can choose to install ufw(For Firewall Security)"
read -p "You can choose install [Y/n]: " fuwchoice
case $fuwchoice in
    Y)
        echo "Installing ufw(For Firewall Security):"
        sudo apt install -y ufw
        sudo systemctl enable ufw
        read -p "Enter the port number using SSH: " sshport
        read -p "Enter the AllowedIPs to connect SSH: " sshallow
        sudo ufw default deny
        sudo ufw allow from $sshallow to any port $sshport
        echo "Allowing port 8080 for PiAware"
        sudo ufw allow 8080
        echo "Allowing port 9190 for Node-Exporter"
        case $nodeexpchoice in
            Y)
                sudo ufw allow 9100
                ;;
            n)
                ;;
            *)
                echo "Invalid option. Exiting."
                exit 1
                ;;
        esac
        sudo ufw enable
        echo "Successfully installed & Setted ufw"
        ;;
    n)
        echo "Skipping ufw installation."
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac

echo "Cleaning up..."
sudo apt autoremove -y
rm -f flightaware.deb cloudflared.deb

echo "--------------------------------------------------------------------------------"
echo "This script made by @negishi_tako at Keisei11.com"
echo "Successfully installed all packages. Please reboot the system."