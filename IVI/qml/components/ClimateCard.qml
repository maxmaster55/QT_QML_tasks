import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

GlassPanel {
    id: climateRoot

    // Section Title
    Text {
        text: "CLIMATE CONTROL"
        anchors {
            left: parent.left
            top: parent.top
            margins: 24
        }
        color: "#4f8cff" // Matching your system theme color accent
        font.pixelSize: 13
        font.bold: true
        font.letterSpacing: 2
    }

    // Main Control Layout
    RowLayout {
        anchors.centerIn: parent
        spacing: 64 // Clean proportional spacing

        // ── Driver Side Temperature ──
        ColumnLayout {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            RoundButton {
                id: driverTempUp
                icon.name: "go-up-symbolic"
                icon.width: 16
                icon.height: 16
                icon.color: hovered ? "white" : "#8a94a6"
                flat: true
                hoverEnabled: true
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 44
                implicitHeight: 44
                
                background: Rectangle {
                    radius: 22
                    color: driverTempUp.hovered ? "#15192e" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            Text {
                text: "22°C"
                color: "white"
                font.pixelSize: 38
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RoundButton {
                id: driverTempDown
                icon.name: "go-down-symbolic"
                icon.width: 16
                icon.height: 16
                icon.color: hovered ? "white" : "#8a94a6"
                flat: true
                hoverEnabled: true
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 44
                implicitHeight: 44
                
                background: Rectangle {
                    radius: 22
                    color: driverTempDown.hovered ? "#15192e" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
        }

        // ── Center Fan Speed / Airflow Controls ──
        ColumnLayout {
            spacing: 16
            Layout.alignment: Qt.AlignVCenter
            
            // Clean Interactive Fan Speed Selector Button
            RoundButton {
                id: fanIconButton
                icon.name: "weather-windy-symbolic" // Modern system alternative for fan/air movement
                icon.width: 28
                icon.height: 28
                icon.color: "#4f8cff"
                flat: true
                hoverEnabled: true
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 64
                implicitHeight: 64
                
                background: Rectangle {
                    radius: 32
                    color: fanIconButton.hovered ? "#121a30" : "transparent"
                    border.color: fanIconButton.hovered ? "#4f8cff" : "transparent"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                scale: pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Visual Fan Speed Indicator Level Bar
            Rectangle {
                width: 90
                height: 6
                radius: 3
                color: "#1e2235" // Track background
                Layout.alignment: Qt.AlignHCenter

                // Active level filler
                Rectangle {
                    width: parent.width * 0.6 // Represents Level 3 out of 5
                    height: parent.height
                    radius: parent.radius
                    color: "#4f8cff"
                }
            }

            Text {
                text: "Fan Speed 3"
                color: "#8a94a6"
                font.pixelSize: 13
                font.weight: Font.Medium
                font.letterSpacing: 0.5
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // ── Passenger Side Temperature ──
        ColumnLayout {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            RoundButton {
                id: passTempUp
                icon.name: "go-up-symbolic"
                icon.width: 16
                icon.height: 16
                icon.color: hovered ? "white" : "#8a94a6"
                flat: true
                hoverEnabled: true
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 44
                implicitHeight: 44
                
                background: Rectangle {
                    radius: 22
                    color: passTempUp.hovered ? "#15192e" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            Text {
                text: "21°C"
                color: "white"
                font.pixelSize: 38
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            RoundButton {
                id: passTempDown
                icon.name: "go-down-symbolic"
                icon.width: 16
                icon.height: 16
                icon.color: hovered ? "white" : "#8a94a6"
                flat: true
                hoverEnabled: true
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 44
                implicitHeight: 44
                
                background: Rectangle {
                    radius: 22
                    color: passTempDown.hovered ? "#15192e" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
        }
    }
}