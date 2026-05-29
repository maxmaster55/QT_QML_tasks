import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import IVI

ApplicationWindow {
    id: window
    visible: true
    minimumHeight: 600
    minimumWidth: 1000
    width: 1280
    height: 720
    title: "IVI Drive"
    color: "#05070d"
    
    Material.theme: Material.Dark

    Rectangle {
        anchors.fill: parent
        color: "#05070d"

        Sidebar {
            id: sidebar
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 100
            
            // Connect the click signal from Sidebar to update the main view layout index
            onMenuItemClicked: function(index, name) {
                if (index >= 0) {
                    mainStack.currentIndex = index
                } else {
                    console.log("Voice Command Triggered via Sidebar")
                }
            }
        }

        // ── Main View Switching Engine ──
        StackLayout {
            id: mainStack
            currentIndex: sidebar.currentIndex // Keeps them bi-directionally synchronized
            
            anchors {
                left: sidebar.right
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                margins: 20
            }

            // [Index 0] ── HOME SCREEN (Your Premium Dashboard Layout) ──
            RowLayout {
                spacing: 20

                // Left Column: Climate Control and Vehicle Status stack
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 2
                    spacing: 20

                    ClimateCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 1
                    }

                    VehicleStatusCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 2 
                    }
                }

                // Right Column: Music Card taking up the full height column
                MusicCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 3 
                }
            }

            // [Index 1] ── MUSIC FULLSCREEN TEST VIEW ──
            GlassPanel {
                id: fullMusicScreen
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    Text {
                        text: "🎵 MUSIC LAYER"
                        color: "#4f8cff"
                        font.pixelSize: 28
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "Full screen media workspace placeholder."
                        color: "#8a94a6"
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // [Index 2] ── HVAC EXPANDED TEST VIEW ──
            GlassPanel {
                id: hvacScreen
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    Text {
                        text: "🌡️ CLIMATE ENVIRONMENT"
                        color: "#00f2fe"
                        font.pixelSize: 28
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "Multi-zone synchronization controls placeholder."
                        color: "#8a94a6"
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // [Index 3] ── APPLICATION LAUNCHER TEST VIEW ──
            GlassPanel {
                id: appsScreen
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    Text {
                        text: "📱 CORE APPLICATIONS"
                        color: "#a855f7"
                        font.pixelSize: 28
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "System application package array layout."
                        color: "#8a94a6"
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // [Index 4] ── SYSTEM SETTINGS TEST VIEW ──
            GlassPanel {
                id: settingsScreen
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    Text {
                        text: "⚙️ SYSTEM SETTINGS"
                        color: "#e2e8f0"
                        font.pixelSize: 28
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: "Diagnostics, hardware interfaces, and profile parameters."
                        color: "#8a94a6"
                        font.pixelSize: 16
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
}