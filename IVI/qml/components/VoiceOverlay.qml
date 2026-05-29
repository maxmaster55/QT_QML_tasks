import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: overlayRoot
    anchors.fill: parent
    visible: opacity > 0.0
    opacity: 0.0

    // Smooth fading animation states
    states: [
        State {
            name: "active"
            PropertyChanges { target: overlayRoot; opacity: 1.0 }
        },
        State {
            name: "inactive"
            PropertyChanges { target: overlayRoot; opacity: 0.0 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; duration: 250; easing.type: Easing.OutQuad }
    }

    // Input Block Scrim (Dark tint overlay)
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        // Tapping the background scrim drops the overlay out safely
        onClicked: overlayRoot.state = "inactive"

        Rectangle {
            anchors.fill: parent
            color: "#05070d"
            opacity: 0.82
        }
    }

    // Center Dialog UI Box
    Rectangle {
        anchors.centerIn: parent
        width: 500
        height: 280
        radius: 28
        color: "#111424"
        border.color: "#22263f"
        border.width: 1

        // Interior glowing highlight accent rim
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "transparent"
            border.color: Qt.rgba(1.0, 1.0, 1.0, 0.05)
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 24

            // Top Status String
            Text {
                text: "LISTENING..."
                color: "#a855f7" // Voice branding purple color matching your sidebar state
                font.pixelSize: 13
                font.bold: true
                font.letterSpacing: 2
                Layout.alignment: Qt.AlignHCenter
            }

            // Simulated Voice Audio Pulse Array
            RowLayout {
                spacing: 6
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true

                Repeater {
                    model: [34, 62, 96, 45, 78, 55, 24] // Distinct height variants
                    delegate: Rectangle {
                        id: waveBar
                        width: 6
                        radius: 3
                        color: "#a855f7"

                        // Scale bindings to make the waves breathe automatically
                        Layout.preferredHeight: modelData

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: overlayRoot.state === "active"
                            NumberAnimation { from: 0.4; to: 1.0; duration: 400 + (index * 80); easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.0; to: 0.4; duration: 400 + (index * 80); easing.type: Easing.InOutSine }
                        }
                    }
                }
            }

            // Command Prompt Sample Helper text
            Text {
                text: "\"Navigate to nearest charging station\""
                color: "#8a94a6"
                font.pixelSize: 15
                font.italic: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
