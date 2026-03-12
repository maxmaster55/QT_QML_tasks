import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import t03_netman

Window {
    width: 640
    height: 480
    visible: true
    title: "Network Manager"
    Material.accent: Material.Blue

    WifiController {
        id: wifiController
    }

    BtController {
        id: btController
    }
    // wifi scan timer
    Timer {
        interval: 5000
        repeat: true
        running: true

        onTriggered: {
            if (wifiController.wifiEnabled) {
                wifiController.scanNetworks();
            }
        }
    }
    // bt scan timer
    Timer {
        interval: 2000
        repeat: true
        running: true

        onTriggered: {
            if (btController.btEnabled) {
                btController.scanDevices();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabEnableButton {
                id: wifiSwitch
                label: "Wifi"
                switchChecked: wifiController.wifiEnabled
                onSwitchToggled: is_checked => {
                    wifiController.wifiEnabled = is_checked;
                }
            }
            TabEnableButton {
                id: btSwitch
                label: "Bluetooth"
                switchChecked: btController.btEnabled
                onSwitchToggled: is_checked => {
                    btController.btEnabled = is_checked;
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // Wifi page
            WifiPage {}

            // Bluetooth page
            BtPage {}
        }
    }
}
