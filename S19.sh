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

# Step 1: Update and upgrade
sudo apt update && sudo apt upgrade -y

# Step 2: Install Node.js and npm
sudo apt install nodejs npm -y

# Step 3: Install pm2 globally
sudo npm i -g pm2

# Step 4: Clone the GitHub repository
git clone https://github.com/namoray/vision.git
cd vision

# Step 5: Install Python dependencies
pip install -r requirements.txt
pip install -e .

# Step 6: Run get_model.sh
./get_model.sh

# Step 7: Create a new coldkey
read -p "Do you want to create a new coldkey? (yes/no): " create_coldkey
if [[ "$create_coldkey" == "yes" || "$create_coldkey" == "y" ]]; then
    read -p "Do you want to create the wallet without a password? (Wallet without a password is required for registration script to work) (yes/no): " coldkey_password
    if [[ "$create_coldkey" == "yes" || "$create_coldkey" == "y" ]]; then
        btcli w new_coldkey --wallet.name default --no_password
    else
        btcli w new_coldkey --wallet.name default 
    fi
fi

# Step 8: Create a new hotkey
read -p "Do you want to create a new hotkey? (yes/no): " create_hotkey
if [[ "$create_hotkey" == "yes" || "$create_hotkey" == "y" ]]; then
    btcli w new_hotkey --wallet.name default --wallet.hotkey default
else
    echo "Ending script. No hotkey created."
    exit 0
fi

# Step 9: Inform the user to fund the coldkey and list wallets
echo "It's time to fund the coldkey with the MAXIMUM amount you are willing to spend on registration."

# List wallets
echo "Listing wallets:"
btcli w list

# Wait for user acknowledgment
prompt_user "Press Enter when you have funded the coldkey."

# Step 10: Prompt user to continue with registration script
read -p "Do you want to continue with the registration script? (yes/no): " register_script
if [[ "$register_script" == "yes" || "$register_script" == "y" ]]; then
    echo "Note: This registration script could potentially use all funds in the coldkey."
    
    # Countdown before starting registration script
    countdown 5
    
    echo "Starting the registration script. By default registration will be attempted every 60 seconds. This requires the coldkey to NOT have a password."
    
    # Registration script
    while true
    do
        btcli s register --netuid 19 --wallet.name default --wallet.hotkey default --subtensor.network finney --no_prompt
        sleep 60  # Wait for 1 minute
    done

fi
