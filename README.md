Subnet 19 (Vision) Build
Vision Setup Bash Script

Introduction
This Bash script automates the setup process for the "Vision" project, providing a seamless experience for users. The script handles system updates, installs necessary dependencies, clones the project repository, installs Python dependencies, and executes required scripts. User prompts guide the configuration of coldkeys, hotkeys, and wallet information.

Prerequisites
Before running the script, ensure the following prerequisites are met:

Linux environment
Git installed
Node.js, npm, and pm2 installed
Python and pip installed

Usage
Download the script

wget https://raw.githubusercontent.com/TidalWavesNode/S19_Vision_Setup/main/S19.sh

Change persmissions
chmod +x S19.sh

Run the script:
bash s19.sh

Follow the prompts and instructions provided by the script.

Script Explanation
Update and upgrade system: Keeps the system up-to-date using apt.
Install Node.js, npm, and pm2: Sets up Node.js and npm, installs pm2 for process management.
Clone the vision repository: Retrieves the Vision project code from the provided URL.
Install Python dependencies: Uses pip to install required Python packages.
Run get_model.sh script: Executes the get_model.sh script for additional setup.
Prompt user for coldkey: Asks if the user wants to create a new coldkey using btcli.
Prompt user for hotkey: Asks if the user wants to create a new hotkey using btcli.
Remind the user to save seed phrases and list wallets.
