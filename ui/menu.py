#!/usr/bin/env python3

from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QLabel, QLineEdit, QInputDialog
import sys
import subprocess

class BluetoothManager(QWidget):
    def __init__(self):
        super(BluetoothManager, self).__init__()

        self.setWindowTitle("Bluetooth Manager")
        layout = QVBoxLayout()

        self.scan_button = QPushButton("Scan for devices")
        self.scan_button.clicked.connect(self.scan)

        self.pair_button = QPushButton("Pair and Trust a device")
        self.pair_button.clicked.connect(self.pair)

        self.connect_button = QPushButton("Connect to a device")
        self.connect_button.clicked.connect(self.connect)

        self.hard_refresh_button = QPushButton("Hard Refresh Bluetooth")
        self.hard_refresh_button.clicked.connect(self.hard_refresh)

        self.unmask_button = QPushButton("Unmask Bluetooth Service")
        self.unmask_button.clicked.connect(self.unmask)

        self.enable_button = QPushButton("Enable Bluetooth Service")
        self.enable_button.clicked.connect(self.enable)

        self.start_button = QPushButton("Start Bluetooth Service")
        self.start_button.clicked.connect(self.start)

        layout.addWidget(self.scan_button)
        layout.addWidget(self.pair_button)
        layout.addWidget(self.connect_button)
        layout.addWidget(self.hard_refresh_button)
        layout.addWidget(self.unmask_button)
        layout.addWidget(self.enable_button)
        layout.addWidget(self.start_button)

        self.setLayout(layout)

    def run_command(self, command):
        subprocess.run(command, shell=True, check=True)

    def scan(self):
        self.run_command("bluetoothctl scan on")
        self.run_command("bluetoothctl scan off")

    def pair(self):
        mac, ok = QInputDialog.getText(self, 'Pair and Trust', 'Enter MAC Address (format XX:XX:XX:XX:XX:XX):')
        if ok:
            self.run_command(f"bluetoothctl pair {mac}")
            self.run_command(f"bluetoothctl trust {mac}")

    def connect(self):
        mac, ok = QInputDialog.getText(self, 'Connect', 'Enter MAC Address (format XX:XX:XX:XX:XX:XX):')
        if ok:
            self.run_command(f"bluetoothctl connect {mac}")

    def hard_refresh(self):
        self.run_command("sudo systemctl stop bluetooth.service")
        self.run_command("sudo systemctl start bluetooth.service")
        self.run_command("sudo systemctl enable bluetooth")
        self.run_command("sudo rmmod btusb")
        self.run_command("sudo modprobe btusb")
        self.run_command("rfkill unblock all")

    def unmask(self):
        self.run_command("sudo systemctl unmask bluetooth")

    def enable(self):
        self.run_command("sudo systemctl enable bluetooth")

    def start(self):
        self.run_command("sudo systemctl start bluetooth")


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = BluetoothManager()
    window.show()
    sys.exit(app.exec_())
