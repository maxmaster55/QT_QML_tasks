import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: sidebar
    width: 100 
    height: 600
    color: "#0c0f1d"
    
    // Subtle right border line
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: "#1e2235"
    }

    property int currentIndex: 0
    signal menuItemClicked(int index, string name)

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 24
        anchors.bottomMargin: 24
        spacing: 20

        // Branding Title
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "IVI"
            color: "#4f8cff"
            font.pixelSize: 20
            font.bold: true
            font.letterSpacing: 1.5
        }

        // Menu Container
        Item {
            id: menuContainer
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Fluid vertical tracking pill
            Rectangle {
                id: activeIndicator
                x: 4
                width: 4
                radius: 2
                color: "#4f8cff"
                y: sidebar.currentIndex * (68 + 8) + 6 
                height: 56

                Behavior on y {
                    SpringAnimation { spring: 4.0; damping: 0.5 }
                }
            }

            Column {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8 

                Repeater {
                    id: menuRepeater
                    model: [
                        { name: "Home", iconName: "user-home-symbolic" },
                        { name: "Music", iconName: "multimedia-audio-player-symbolic" },
                        { name: "HVAC", iconName: "weather-clear-symbolic" },
                        { name: "Apps", iconName: "preferences-system-windows-symbolic" },
                        { name: "Settings", iconName: "emblem-system-symbolic" }
                    ]

                    delegate: Item {
                        width: parent.width
                        height: 68 

                        Button {
                            id: menuButton
                            anchors.fill: parent
                            flat: true
                            hoverEnabled: true
                            
                            text: sidebar.width > 70 ? modelData.name : ""
                            icon.name: modelData.iconName
                            display: AbstractButton.TextUnderIcon

                            topPadding: 12
                            bottomPadding: 12
                            leftPadding: 8
                            rightPadding: 8

                            // Default base values to fall back on
                            icon.width: 22
                            icon.height: 22

                            states: [
                                State {
                                    name: "active"
                                    when: sidebar.currentIndex === index
                                    PropertyChanges { target: btnBg; color: "#1a243d" }
                                    PropertyChanges { target: menuButton; icon.color: "#4f8cff"; icon.width: 22; icon.height: 22 }
                                    PropertyChanges { target: menuButton; Material.foreground: "#4f8cff" }
                                },
                                State {
                                    name: "hovered"
                                    when: menuButton.hovered && sidebar.currentIndex !== index
                                    PropertyChanges { target: btnBg; color: "#15192e" }
                                    PropertyChanges { target: menuButton; icon.color: "#ffffff"; icon.width: 24; icon.height: 24 }
                                    PropertyChanges { target: menuButton; Material.foreground: "#ffffff" }
                                },
                                State {
                                    name: "normal"
                                    when: !menuButton.hovered && sidebar.currentIndex !== index
                                    PropertyChanges { target: btnBg; color: "transparent" }
                                    PropertyChanges { target: menuButton; icon.color: "#8a94a6"; icon.width: 22; icon.height: 22 }
                                    PropertyChanges { target: menuButton; Material.foreground: "#8a94a6" }
                                }
                            ]

                            // Safe state layout transition handles sizing smoothly without conflicts
                            transitions: Transition {
                                NumberAnimation { 
                                    properties: "icon.width,icon.height"
                                    duration: 150
                                    easing.type: Easing.OutQuad 
                                }
                            }

                            scale: menuButton.pressed ? 0.95 : 1.0
                            Behavior on scale { NumberAnimation { duration: 100 } }

                            background: Rectangle {
                                id: btnBg
                                radius: 12
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            
                            onClicked: {
                                sidebar.currentIndex = index
                                sidebar.menuItemClicked(index, modelData.name)
                            }
                        }
                    }
                }
            }
        }

        // Voice Command Section
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            
            Button {
                id: voiceButton
                anchors.centerIn: parent
                width: parent.width - 24
                height: 64
                flat: true
                hoverEnabled: true

                text: sidebar.width > 70 ? "Voice" : ""
                icon.name: "audio-input-microphone-symbolic"
                display: AbstractButton.TextUnderIcon

                topPadding: 10
                bottomPadding: 10
                icon.width: 22
                icon.height: 22

                states: [
                    State {
                        name: "hovered"
                        when: voiceButton.hovered
                        PropertyChanges { target: voiceBg; color: "#20172d"; border.color: "#a855f7" }
                        PropertyChanges { target: voiceButton; icon.color: "#a855f7"; icon.width: 24; icon.height: 24 }
                        PropertyChanges { target: voiceButton; Material.foreground: "#a855f7" }
                    },
                    State {
                        name: "normal"
                        when: !voiceButton.hovered
                        PropertyChanges { target: voiceBg; color: "transparent"; border.color: "transparent" }
                        PropertyChanges { target: voiceButton; icon.color: "#8a94a6"; icon.width: 22; icon.height: 22 }
                        PropertyChanges { target: voiceButton; Material.foreground: "#8a94a6" }
                    }
                ]

                transitions: Transition {
                    NumberAnimation { 
                        properties: "icon.width,icon.height"
                        duration: 150
                        easing.type: Easing.OutQuad 
                    }
                }

                scale: voiceButton.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }

                background: Rectangle {
                    id: voiceBg
                    radius: 12
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                }
                
                onClicked: {
                    sidebar.menuItemClicked(-1, "Voice")
                }
            }
        }
    }
}