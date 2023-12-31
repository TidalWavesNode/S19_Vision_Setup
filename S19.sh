#!/bin/bash

# Function to prompt the user with yes/no question
function prompt_yes_no {
    while true; do
        read -p "$1 (yes/no): " yn
        case $yn in
            [Yy]* ) return 0;;  # User selected Yes
            [Nn]* ) return 1;;  # User selected No
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

# Install Node.js, npm, and pm2
echo "Installing Node.js, npm, and pm2..."
sudo apt install nodejs npm -y
sudo npm i -g pm2

# Clone the vision repository
echo "Cloning the vision repository..."
git clone https://github.com/namoray/vision.git
cd vision

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt
pip install -e .

# Run the get_model.sh script
echo "Running get_model.sh..."
./get_model.sh

# Prompt user to create a new coldkey
if prompt_yes_no "Create a new coldkey?"; then
    btcli w new_coldkey
else
    echo "Skipping coldkey creation."
fi

# Prompt user to create a new hotkey
if prompt_yes_no "Create a new hotkey?"; then
    btcli w new_hotkey
else
    echo "Skipping hotkey creation."
fi

# Prompt user to save seed phrases and list wallets
if prompt_yes_no "Have you saved the seed phrases for both wallets?"; then
    btcli w list
else
    echo "DO NOT FORGET TO SAVE YOUR SEED PHRASES!"
fi

echo "Script completed."
