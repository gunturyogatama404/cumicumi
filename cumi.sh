#!/bin/bash

# Auto Install Script for Squid Proxy on Lightsail

# Update the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Squid
echo "Installing Squid proxy server..."
sudo apt install squid -y

# Backup the original Squid configuration file
echo "Backing up the original Squid configuration file..."
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.bak

# Configure Squid
echo "Configuring Squid..."
cat <<EOL | sudo tee /etc/squid/squid.conf
# Squid Configuration
http_port 3128

# Allow access from specific IPs
acl allowed_ips src 0.0.0.0/0
http_access allow allowed_ips

# Deny all other access
http_access deny all

# Log settings
access_log /var/log/squid/access.log squid
cache_log /var/log/squid/cache.log
EOL

# Restart Squid to apply changes
echo "Restarting Squid..."
sudo systemctl restart squid

# Enable Squid to start on boot
echo "Enabling Squid to start on boot..."
sudo systemctl enable squid

# Open the firewall port for Squid (3128)
echo "Opening firewall port 3128..."
PORT=3128
sudo ufw allow $PORT

# Display completion message
echo "Squid proxy installation and configuration complete!"
echo "Configure your browser or client to use the proxy:"
echo "Proxy IP: $(curl -s http://checkip.amazonaws.com)"
echo "Proxy Port: 3128"
