import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

GlassPanel {
    id: musicCardRoot

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 24

        // Section Title
        Text {
            text: "NOW PLAYING"
            color: "#4f8cff" // Vibrant tech theme highlight color
            font.pixelSize: 13
            font.bold: true
            font.letterSpacing: 2
            Layout.alignment: Qt.AlignLeft
        }

        // Main Metadata Area (Artwork + Text Info stacked/aligned seamlessly)
        RowLayout {
            Layout.fillWidth: true
            spacing: 28
            Layout.alignment: Qt.AlignVCenter

            // Vinyl Album Art Glow Panel
            Rectangle {
                id: albumArtFrame
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
                radius: 20
                
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#2e124d" }
                    GradientStop { position: 1.0; color: "#ff4fd8" }
                }

                // Inner Glass Shadow overlay effect
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: "#35ffffff"
                    border.width: 1
                }

                Text {
                    anchors.centerIn: parent
                    text: "M83"
                    color: "white"
                    font.pixelSize: 32
                    font.bold: true
                    opacity: 0.9
                    font.letterSpacing: 1
                }
            }

            // Song/Artist Info
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: "Midnight City"
                    color: "white"
                    font.pixelSize: 34
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: "M83"
                    color: "#4f8cff"
                    font.pixelSize: 22
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Text {
                    text: "Hurry Up, We're Dreaming"
                    color: "#8a94a6"
                    font.pixelSize: 16
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }

        // Spacer to push slider lower down natively
        Item { Layout.fillHeight: true }

        // Audio Progress Bar Block
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Slider {
                id: trackSlider
                Layout.fillWidth: true
                value: 0.42
                Material.accent: "#4f8cff"
            }

            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "1:45"
                    color: "#8a94a6"
                    font.pixelSize: 12
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: "4:03"
                    color: "#8a94a6"
                    font.pixelSize: 12
                }
            }
        }

        Item { Layout.fillHeight: true }

        // Media Controls Block
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            // Skip Backward
            RoundButton {
                id: prevBtn
                icon.name: "media-skip-backward-symbolic"
                icon.width: 20
                icon.height: 20
                icon.color: hovered ? "white" : "#8a94a6"
                flat: true
                hoverEnabled: true
                
                implicitWidth: 56
                implicitHeight: 56
                
                background: Rectangle {
                    radius: 28
                    color: prevBtn.hovered ? "#15192e" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

            // Play / Pause Toggle
            RoundButton {
                id: playBtn
                icon.name: "media-playback-pause-symbolic"
                icon.width: 28
                icon.height: 28
                icon.color: "white"
                hoverEnabled: true
                
                implicitWidth: 80
                implicitHeight: 80
                
                Material.background: playBtn.hovered ? Qt.lighter("#4f8cff", 1.1) : "#4f8cff"
                
                scale: pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
            }

            // Skip Forward
            RoundButton {
                id: nextBtn
                icon.name: "media-skip-forward-symbolic"
                icon.width: 20
                icon.height: 20
                icon.color: nextBtn.hovered ? "white" : "#8a94a6"
                flat: true
                hoverEnabled: true
                
                implicitWidth: 56
                implicitHeight: 56
                
                background: Rectangle {
                    radius: 28
                    color: nextBtn.hovered ? "#15192e" : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
        }
        
        // Extra padding base spacer
        Item { Layout.preferredHeight: 10 }
    }
}