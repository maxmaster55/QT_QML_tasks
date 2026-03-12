import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

Rectangle {
    id: root
    Dialog {
        id: passwordDialog
        title: "Connect to " + passwordDialog.ssid
        modal: true
        anchors.centerIn: parent
        width: 320

        property string ssid: ""

        ColumnLayout {
            width: parent.width

            Label {
                text: "Password:"
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Enter password"
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel

        onAccepted: {
            wifiController.connectToNetwork(passwordDialog.ssid, passwordField.text);
            passwordField.text = "";
        }
        onRejected: {
            passwordField.text = "";
        }
    }
    ColumnLayout {
        anchors.fill: parent

        ProgressBar {
            opacity: 0.9
            Layout.fillWidth: true
            indeterminate: true
            visible: wifiController.scanning
        }

        ListView {
            id: networkList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: wifiController.networks

            delegate: WifiElement {
                index: index
                name: modelData.name ?? ""
                is_secured: modelData.is_secured ?? false
                strength: modelData.strength ?? 0

                onConnectClicked: ssid => {
                    console.log("is_secured:", modelData.is_secured, typeof modelData.is_secured);
                    if (modelData.is_secured) {
                        passwordDialog.ssid = ssid;
                        passwordDialog.open();
                    } else {
                        wifiController.connectToNetwork(ssid, "");
                    }
                }
            }
        }
    }
}
