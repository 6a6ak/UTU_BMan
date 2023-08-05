#!/bin/bash

# Function to display the main menu
function display_menu {
    echo "Bluetoothctl Options:"
    echo "1. Scan for devices"
    echo "2. Pair with a device"
    echo "3. Trust a device"
    echo "4. Connect to a device"
    echo "5. Exit"
    echo -n "Enter your choice: "
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
            echo -n "Enter MAC Address to pair (format XX:XX:XX:XX:XX:XX): "
            read mac
            bluetoothctl pair $mac
            ;;

        3)
            echo -n "Enter MAC Address to trust (format XX:XX:XX:XX:XX:XX): "
            read mac
            bluetoothctl trust $mac
            ;;

        4)
            echo -n "Enter MAC Address to connect (format XX:XX:XX:XX:XX:XX): "
            read mac
            bluetoothctl connect $mac
            ;;

        5)
            echo "Exiting..."
            exit 0
            ;;

        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
