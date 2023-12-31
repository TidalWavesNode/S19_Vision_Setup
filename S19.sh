#!/bin/bash

# Function to display messages and wait for user input
function prompt_user() {
    echo "$1"
    read -p "Press Enter to continue..."
}

# Function for countdown
function countdown() {
    secs=$1
    while [ $secs -gt 0 ]; do
        echo -ne "Starting in $secs seconds...\033[0K\r"
        sleep 1
        : $((secs--))
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

# Create a new coldkey
read -p "Do you want to create a new coldkey? (yes/no): " create_coldkey
if [ "$create_coldkey" == "yes" ]; then
    read -p "Do you want the wallet to have a password? (yes/no): " coldkey_password
    if [ "$coldkey_password" == "yes" ]; then
        btcli w new_coldkey
    else
        btcli w new_coldkey --no_password
    fi
fi

# Create a new hotkey
read -p "Do you want to create a new hotkey? (yes/no): " create_hotkey
if [ "$create_hotkey" == "yes" ]; then
    btcli w new_hotkey
else
    echo "Ending script. No hotkey created."
    exit 0
fi

# Remind user to save seed phrases and then list new wallets
read -p "Did you save the seed phrases? (yes/no): " save_seed
if [ "$save_seed" == "yes" ]; then
    btcli w list
else
    echo "Script completed without listing wallets."
fi

# Prompt user to continue with registration script
read -p "Do you want to continue with the registration script? (yes/no): " register_script
if [ "$register_script" == "yes" ]; then
    echo "Note: This registration script could potentially use all funds in the coldkey."
       
    echo "Starting the registration script. This requires the coldkey to not have a password."
    
	# Countdown before starting registration attempts
    countdown 5
	
    # Registration script
    while true
    do
        btcli s register --netuid 19 --wallet.name default --wallet.hotkey default --subtensor.network finney --no_prompt
        sleep 60  # Wait for 1 minute
    done
else
    echo "Script completed successfully. It is now time to fund the coldkey and register on S19."
fi
