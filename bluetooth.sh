#!/bin/bash

# Function to display the main menu
function display_menu {
    echo "Bluetoothctl Options:"
    echo "1. Scan for devices"
    echo "2. Pair and Trust a device"
    echo "3. Connect to a device"
    echo "4. Hard Refresh Bluetooth"
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

        0)
            echo "Exiting..."
            exit 0
            ;;

        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
