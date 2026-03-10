import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material
import t03_netman

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    Material.accent: Material.Blue

    WifiController {
        id: wifiController
    }

    Timer {
        interval: 2000
        repeat: true
        running: true

        onTriggered: {
            if (true) {
                wifiController.scanNetworks();
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
                label: "Bluetooth"
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
