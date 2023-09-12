#!/bin/bash

# Function to unmask bluetooth service
function unmask {
  zenity --info --text="Unmasking bluetooth service..."
  sudo systemctl unmask bluetooth
}

# Function to enable bluetooth service
function enable {
  zenity --info --text="Enabling bluetooth service..."
  sudo systemctl enable bluetooth
}

# Function to start bluetooth service
function start {
  zenity --info --text="Starting bluetooth service..."
  sudo systemctl start bluetooth
}

# Function for the Hard Refresh
function hard_refresh {
    zenity --info --text="Performing Hard Refresh on Bluetooth..."
    sudo systemctl stop bluetooth.service
    sudo systemctl start bluetooth.service
    sudo systemctl enable bluetooth
    sudo rmmod btusb
    sudo modprobe btusb
    rfkill unblock all
    zenity --info --text="Hard Refresh Done!"
}

# Infinite loop to keep displaying the menu after each operation until user decides to exit
while true; do

  choice=$(zenity --list --text="Bluetooth Manager" --radiolist --column "Pick" --column "Options" TRUE "Scan for devices" FALSE "Pair and Trust a device" FALSE "Connect to a device" FALSE "Hard Refresh Bluetooth" FALSE "Bluetoothctl" FALSE "Bluetooth service control" FALSE "Help" FALSE "Exit")

  case $choice in
    "Scan for devices")
        zenity --info --text="Scanning for devices..."
        bluetoothctl scan on
        zenity --info --text="Press OK to stop scanning..."
        bluetoothctl scan off
        ;;

    "Pair and Trust a device")
        mac=$(zenity --entry --text="Enter MAC Address to pair and trust (format XX:XX:XX:XX:XX:XX)")
        bluetoothctl pair $mac
        bluetoothctl trust $mac
        ;;

    "Connect to a device")
        mac=$(zenity --entry --text="Enter MAC Address to connect (format XX:XX:XX:XX:XX:XX)")
        bluetoothctl connect $mac
        ;;

    "Hard Refresh Bluetooth")
        hard_refresh
        ;;

    "Bluetoothctl")
        gnome-terminal -- sudo bluetoothctl
        ;;

    "Bluetooth service control")
        service_choice=$(zenity --list --text="Bluetooth Service Control Options" --radiolist --column "Pick" --column "Options" TRUE "Unmask Bluetooth Service" FALSE "Enable Bluetooth Service" FALSE "Start Bluetooth Service")
        case $service_choice in
            "Unmask Bluetooth Service")
                unmask
                ;;
            "Enable Bluetooth Service")
                enable
                ;;
            "Start Bluetooth Service")
                start
                ;;
            *)
                zenity --error --text="Invalid option. Please choose again."
                ;;
        esac
        ;;

    "Help")
        zenity --text-info --title="Bluetoothctl Command Help" --filename=- <<< "..."
        ;;

    "Exit")
        zenity --info --text="Exiting..."
        exit 0
        ;;

    *)
        zenity --error --text="Invalid option. Please choose again."
        ;;
  esac
done
