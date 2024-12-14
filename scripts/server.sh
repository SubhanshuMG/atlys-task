#!/bin/bash

USER="subhanshu"
USER_HOME="/home/$USER"

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

sudo apt update && sudo apt upgrade -y && sudo apt install docker.io -y && sudo apt install docker-compose -y
echo "Package update and installation completed."

# Disable root login
sed -i '/^#*PasswordAuthentication /d' /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

## SSH KEYS ADDITION
echo "Adding provided SSH keys..."
sudo mkdir -p "$USER_HOME/.ssh"
sudo chown $USER:$USER "$USER_HOME/.ssh"
sudo chmod 700 "$USER_HOME/.ssh"

#subhanshu keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDkPpCPMbmzAJciaBPGpG5XQDhf9ywnI9/lI2Hm32217rK7o6hw7jbcnGgs6PDyJy2TcsA7kUvAT0PqwqMJEHeporawiltYrZMf5vYwSApmyKA/Yc/B+AEmFwiavADaVCPVwIUp4e/cqooQvL8Zb071WU2vvOAxT9HFWbHmrzSwcZ3nPhtp760w6UHHk4nrWnx868KBK7o8o8ii2sc4Dcg4FKKNDuElktfW19dzS2j5bQnsvmrTCIfP3YiAMck0KXBwxLeONIRJ1lNM7lqLI3acYBePQUSRgajm56w1Tpnrw64Up4M0i9UHfo19/JN/5Fz257t05/jALe74XnMtBZYowUxpPmzWLypu3xpUJMc5tusR6n0JRqi8VDpyNbCgNYtFyEu+NVqWowe4+r2gRsj/cXBQIGJaog5kmiEMhbMqOZOI8EYpH5tLskCEFWOzjQVNYsSkGRstWN8clQTbeGR5PWN86JyGuA+PVN+QksYGQRKogtfx7FE/xZN7EQiN0nk= subhanshumg@Subhanshus-MacBook-Pro.local" | sudo tee -a "$USER_HOME/.ssh/authorized_keys"
echo "" | sudo tee -a "$USER_HOME/.ssh/authorized_keys"
sudo chown $USER:$USER "$USER_HOME/.ssh/authorized_keys"
sudo chmod 600 "$USER_HOME/.ssh/authorized_keys"

# # Install UFW
# echo "Installing UFW..."
# sudo apt install ufw -y

# # Configure UFW
# echo "Configuring UFW..."
# sudo ufw allow ssh
# sudo ufw allow 80/tcp
# sudo ufw allow 443/tcp
# sudo ufw enable

# # Audit and disable unnecessary services
# echo "Auditing and disabling unnecessary services..."
# SERVICES=$(sudo systemctl list-units --type=service --state=running | grep -E 'apache2|nginx' | awk '{print $1}')
# for SERVICE in $SERVICES; do
#   sudo systemctl disable $SERVICE
#   sudo systemctl stop $SERVICE
# done

# Install and configure unattended-upgrades
echo "Installing unattended-upgrades..."
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Ensure security updates are enabled
echo "Configuring unattended-upgrades..."
sudo sed -i 's|//\s*"\${distro_id}:\${distro_codename}-security";|"${distro_id}:${distro_codename}-security";|' /etc/apt/apt.conf.d/50unattended-upgrades

sudo service ssh restart

echo "Server hardening completed."