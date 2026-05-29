import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

GlassPanel {
    id: climateRoot

    // ── Internal HVAC State Engine ──
    property int driverTemp: 22
    property int passengerTemp: 21
    property int fanSpeed: 3
    property int maxFanSpeed: 5

    // Global HVAC Toggle States
    property bool isAutoMode: true
    property bool isSyncMode: false
    property bool isMaxAC: false

    // Section Title
    Text {
        text: "CLIMATE CONTROL"
        anchors {
            left: parent.left
            top: parent.top
            margins: 24
        }
        color: "#4f8cff"
        font.pixelSize: 13
        font.bold: true
        font.letterSpacing: 2
    }

    // ── Global Sub-Mode Header Tabs ──
    RowLayout {
        anchors {
            right: parent.right
            top: parent.top
            margins: 16
        }
        spacing: 8

        // AUTO MODE BUTTON
        Button {
            id: autoBtn
            text: "AUTO"
            flat: true
            font.bold: true
            font.pixelSize: 11
            implicitHeight: 32
            checked: climateRoot.isAutoMode
            onClicked: climateRoot.isAutoMode = !climateRoot.isAutoMode

            background: Rectangle {
                radius: 6
                color: climateRoot.isAutoMode ? Qt.rgba(0.07, 0.55, 1.0, 0.15) : "transparent"
                border.color: climateRoot.isAutoMode ? "#4f8cff" : "#22263f"
                border.width: 1
            }
            Material.foreground: climateRoot.isAutoMode ? "#4f8cff" : "#8a94a6"
        }

        // SYNC TEMPERATURES BUTTON
        Button {
            id: syncBtn
            text: "SYNC"
            flat: true
            font.bold: true
            font.pixelSize: 11
            implicitHeight: 32
            checked: climateRoot.isSyncMode
            onClicked: {
                climateRoot.isSyncMode = !climateRoot.isSyncMode
                if(climateRoot.isSyncMode) {
                    climateRoot.passengerTemp = climateRoot.driverTemp
                }
            }

            background: Rectangle {
                radius: 6
                color: climateRoot.isSyncMode ? Qt.rgba(0.07, 0.55, 1.0, 0.15) : "transparent"
                border.color: climateRoot.isSyncMode ? "#4f8cff" : "#22263f"
                border.width: 1
            }
            Material.foreground: climateRoot.isSyncMode ? "#4f8cff" : "#8a94a6"
        }
    }

    // ── Main Content Area ──
    RowLayout {
        anchors.centerIn: parent
        spacing: 70

        // ── Left Column: Driver Side ──
        ColumnLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "DRIVER"
                color: "#8a94a6"
                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1
                Layout.alignment: Qt.AlignHCenter
            }

            RoundButton {
                id: driverTempUp
                icon.name: "go-up-symbolic"
                icon.width: 18
                icon.height: 18
                icon.color: hovered ? "#ff5252" : "#8a94a6" // Warm red highlight on hover
                flat: true
                hoverEnabled: true
                autoRepeat: true // Press and hold to rapidly increase temperature
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 48
                implicitHeight: 48
                onClicked: {
                    if (climateRoot.driverTemp < 32) {
                        climateRoot.driverTemp++
                        if (climateRoot.isSyncMode) climateRoot.passengerTemp = climateRoot.driverTemp
                    }
                }
                background: Rectangle { radius: 24; color: driverTempUp.hovered ? "#1c121b" : "transparent" }
            }

            Text {
                text: climateRoot.driverTemp + "°C"
                color: "white"
                font.pixelSize: 42
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RoundButton {
                id: driverTempDown
                icon.name: "go-down-symbolic"
                icon.width: 18
                icon.height: 18
                icon.color: hovered ? "#4f8cff" : "#8a94a6" // Cool blue highlight on hover
                flat: true
                hoverEnabled: true
                autoRepeat: true // Press and hold to rapidly decrease temperature
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 48
                implicitHeight: 48
                onClicked: {
                    if (climateRoot.driverTemp > 16) {
                        climateRoot.driverTemp--
                        if (climateRoot.isSyncMode) climateRoot.passengerTemp = climateRoot.driverTemp
                    }
                }
                background: Rectangle { radius: 24; color: driverTempDown.hovered ? "#121a30" : "transparent" }
            }
        }

        // ── Center Column: Dynamic Fan Adjuster ──
        ColumnLayout {
            spacing: 14
            Layout.alignment: Qt.AlignVCenter

            RoundButton {
                id: fanIconButton
                icon.name: "weather-windy-symbolic"
                icon.width: 32
                icon.height: 32
                icon.color: "#4f8cff"
                flat: true
                hoverEnabled: true
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 72
                implicitHeight: 72

                // Tapping the fan icon steps up speed, cycling back to 1
                onClicked: {
                    climateRoot.isAutoMode = false // Manual overriding breaks auto cycle
                    if (climateRoot.fanSpeed < climateRoot.maxFanSpeed) {
                        climateRoot.fanSpeed++
                    } else {
                        climateRoot.fanSpeed = 1
                    }
                }

                background: Rectangle {
                    radius: 36
                    color: fanIconButton.hovered ? "#121a30" : "#0d111f"
                    border.color: fanIconButton.hovered ? "#4f8cff" : "#1e2235"
                    border.width: 1
                }

                scale: pressed ? 0.94 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
            }

            // High-Visibility Fragmented Speed Segment Bars
            RowLayout {
                spacing: 4
                Layout.alignment: Qt.AlignHCenter

                Repeater {
                    model: climateRoot.maxFanSpeed
                    delegate: Rectangle {
                        width: 14
                        height: 6
                        radius: 2
                        // Light up nodes matching or below current fan speed value
                        color: index < climateRoot.fanSpeed ? "#4f8cff" : "#1e2235"

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
            }

            Text {
                text: climateRoot.isAutoMode ? "AUTO SPEED" : "FAN SPEED " + climateRoot.fanSpeed
                color: climateRoot.isAutoMode ? "#00f2fe" : "#8a94a6"
                font.pixelSize: 12
                font.weight: Font.DemiBold
                font.letterSpacing: 0.5
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // ── Right Column: Passenger Side ──
        ColumnLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: "PASSENGER"
                color: "#8a94a6"
                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1
                Layout.alignment: Qt.AlignHCenter
            }

            RoundButton {
                id: passTempUp
                icon.name: "go-up-symbolic"
                icon.width: 18
                icon.height: 18
                icon.color: hovered ? "#ff5252" : "#8a94a6"
                flat: true
                hoverEnabled: true
                autoRepeat: true
                enabled: !climateRoot.isSyncMode // Block input if synced to driver
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 48
                implicitHeight: 48
                onClicked: {
                    if (climateRoot.passengerTemp < 32) climateRoot.passengerTemp++
                }
                background: Rectangle { radius: 24; color: passTempUp.hovered ? "#1c121b" : "transparent" }
                opacity: enabled ? 1.0 : 0.3 // Visually fade when disabled
            }

            Text {
                text: climateRoot.isSyncMode ? climateRoot.driverTemp + "°C" : climateRoot.passengerTemp + "°C"
                color: climateRoot.isSyncMode ? "#4f8cff" : "white" // Colorizes blue if slave-synced
                font.pixelSize: 42
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RoundButton {
                id: passTempDown
                icon.name: "go-down-symbolic"
                icon.width: 18
                icon.height: 18
                icon.color: hovered ? "#4f8cff" : "#8a94a6"
                flat: true
                hoverEnabled: true
                autoRepeat: true
                enabled: !climateRoot.isSyncMode
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 48
                implicitHeight: 48
                onClicked: {
                    if (climateRoot.passengerTemp > 16) climateRoot.passengerTemp--
                }
                background: Rectangle { radius: 24; color: passTempDown.hovered ? "#121a30" : "transparent" }
                opacity: enabled ? 1.0 : 0.3
            }
        }
    }
}
