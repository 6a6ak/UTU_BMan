#!/bin/bash

# Function to display the main menu
function display_menu {
    echo "Bluetoothctl Options:"
    echo "1. Scan for devices"
    echo "2. Pair and Trust a device"
    echo "3. Connect to a device"
    echo "4. Hard Refresh Bluetooth"
    echo "5. Bluetoothctl"
    echo "6. Help"
    echo "0. Exit"
    echo -n "Enter your choice: "
}

# Function for the Hard Refresh
function hard_refresh {
    echo "Performing Hard Refresh on Bluetooth..."
    sudo systemctl stop bluetooth.service
    sudo systemctl unmask bluetooth.service
    sudo systemctl start bluetooth.service
    sudo systemctl enable bluetooth
    sudo systemctl mask bluetooth.service 
    sudo rmmod btusb
    sudo modprobe btusb
    rfkill unblock all
    echo "Hard Refresh Done!"
}

# Infinite loop to keep displaying the menu after each operation until user decides to exit
while true; do
    display_menu

    read choice

    case $choice in
        1)
            echo "Scanning for devices..."
            bluetoothctl scan on
            echo "Press any key to stop scanning..."
            read -n 1 -s
            bluetoothctl scan off
            ;;

        2)
            echo -n "Enter MAC Address to pair and trust (format XX:XX:XX:XX:XX:XX): "
            read mac
            bluetoothctl pair $mac
            bluetoothctl trust $mac
            ;;

        3)
            echo -n "Enter MAC Address to connect (format XX:XX:XX:XX:XX:XX): "
            read mac
            bluetoothctl connect $mac
            ;;

        4)
            hard_refresh
            ;;
        5)
            sudo bluetoothctl
            ;;
        6)
        
# Bluetoothctl Command Help Script

echo "Bluetoothctl Command Help:"
echo "--------------------------"
echo "1. Start bluetoothctl:                   bluetoothctl"
echo "2. List available controllers:            list"
echo "3. Select a specific controller:          select <controller_mac_address>"
echo "4. Show controller details:               show"
echo "5. Power the controller on/off:           power on | power off"
echo "6. Scan for devices:                     scan on | scan off"
echo "7. List paired devices:                  paired-devices"
echo "8. Pair with a device:                   pair <device_mac_address>"
echo "9. Trust a device:                       trust <device_mac_address>"
echo "10. Remove trust from a device:          untrust <device_mac_address>"
echo "11. Connect to a device:                 connect <device_mac_address>"
echo "12. Disconnect from a device:            disconnect <device_mac_address>"
echo "13. Remove (unpair) a device:            remove <device_mac_address>"
echo "14. Set the controller as discoverable:  discoverable on | discoverable off"
echo "15. Set the controller as pairable:      pairable on | pairable off"
echo "16. Get info about a device:             info <device_mac_address>"
echo "17. Agent-related commands:              agent on | agent off | default-agent"
echo "18. Exit bluetoothctl:                   quit"
echo "--------------------------"
echo "Note: To use these commands, first enter the 'bluetoothctl' interface. After that, you can input the commands as described above."

        ;;
        0)
            echo "Exiting..."
            exit 0
            ;;

        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
