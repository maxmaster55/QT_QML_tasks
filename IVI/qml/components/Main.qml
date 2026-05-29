import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import IVI 1.0

ApplicationWindow {
    id: window
    visible: true
    minimumHeight: 720
    minimumWidth: 1280
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
            onMenuItemClicked: function (index, name) {
                if (index >= 0) {
                    mainStack.currentIndex = index
                } else if (name === "Voice") {
                    console.log("Voice Command Triggered via Sidebar")
                    voiceOverlay.state = "active"
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
            MainPage {}

            // [Index 1] ── MUSIC FULLSCREEN TEST VIEW ──
            MusicPage {}

            // [Index 2] ── HVAC EXPANDED TEST VIEW ──
            HVACPage {}

            // [Index 3] ── APPLICATION LAUNCHER TEST VIEW ──
            AppsPage {}
            // [Index 4] ── SYSTEM SETTINGS TEST VIEW ──
            SettingsPage {}
        }
        VoiceOverlay {
            id: voiceOverlay
            state: "inactive"
        }
    }
}
