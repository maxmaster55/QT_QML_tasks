import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

GlassPanel {
    id: weatherRoot

    // ── Internal State Engine ──
    property bool isLoading: true
    property string currentCondition: "Partly Cloudy"
    property int currentTemp: 24
    property int highTemp: 27
    property int lowTemp: 16
    property string locationName: "Detroit, MI"

    // ── Simulated API Boot Loader ──
    Timer {
        id: apiMockTimer
        interval: 1000 // 1 Second Network Delay Simulation
        running: true
        repeat: false
        onTriggered: {
            weatherRoot.isLoading = false
        }
    }

    // ── Layer 1: Loading State UI ──
    Item {
        id: loadingContainer
        anchors.fill: parent
        visible: weatherRoot.isLoading
        opacity: visible ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 250 } }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16

            // Animated Premium Spinner Ring
            Item {
                Layout.alignment: Qt.AlignHCenter
                width: 44
                height: 44

                // Background track ring
                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: "transparent"
                    border.width: 3
                    border.color: "#1e2235"
                }

                // Active spinning indicator arc
                Rectangle {
                    id: spinnerArc
                    anchors.fill: parent
                    radius: width / 2
                    color: "transparent"
                    border.width: 3
                    // A subtle gradient or alpha color gives it a modern look
                    border.color: Qt.rgba(0.31, 0.55, 1.0, 0.85) // Smooth #4f8cff with alpha

                    RotationAnimator on rotation {
                        from: 0
                        to: 360
                        duration: 800
                        loops: Animation.Infinite
                        running: weatherRoot.isLoading
                    }
                }
            }

            Text {
                text: "FETCHING WEATHER..."
                color: "#8a94a6"
                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1.5
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // ── Layer 2: Main Weather Workspace ──
    Item {
        id: mainWeatherContent
        anchors.fill: parent
        visible: !weatherRoot.isLoading
        opacity: visible ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }

        // Section Title Left
        Text {
            text: "WEATHER ENVIRONMENT"
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

        // Active Location Tag Right
        RowLayout {
            anchors {
                right: parent.right
                top: parent.top
                margins: 22
            }
            spacing: 6

            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: "#10b981"
            }

            Text {
                text: weatherRoot.locationName.toUpperCase()
                color: "#8a94a6"
                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1
            }
        }

        // Core Meteorological Data Readout
        RowLayout {
            anchors.centerIn: parent
            width: parent.width - 48
            spacing: 0

            // Left Block: Large Temperature Hero Layout
            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft

                RowLayout {
                    spacing: 4
                    Text {
                        text: weatherRoot.currentTemp
                        color: "white"
                        font.pixelSize: 64
                        font.weight: Font.Light
                    }
                    Text {
                        text: "°C"
                        color: "#4f8cff"
                        font.pixelSize: 28
                        font.bold: true
                        Layout.alignment: Qt.AlignTop
                        Layout.topMargin: 12
                    }
                }

                Text {
                    text: weatherRoot.currentCondition.toUpperCase()
                    color: "white"
                    font.pixelSize: 13
                    font.bold: true
                    font.letterSpacing: 1
                }
            }

            // Center Separation Block: Big Graphic Glyphs
            Item {
                Layout.preferredWidth: 80
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter

                Button {
                    anchors.centerIn: parent
                    icon.name: "weather-few-clouds-symbolic"
                    icon.width: 48
                    icon.height: 48
                    icon.color: "#ffb900"
                    flat: true
                    enabled: false
                    background: null
                }
            }

            // Right Block: Context Metrics Table
            ColumnLayout {
                spacing: 8
                Layout.preferredWidth: 140
                Layout.alignment: Qt.AlignRight

                // Range Segment Row
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "RANGE"; color: "#5a6578"; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                    Text {
                        text: "H: " + weatherRoot.highTemp + "°  L: " + weatherRoot.lowTemp + "°"
                        color: "white"; font.pixelSize: 12; font.bold: true; Layout.alignment: Qt.AlignRight
                    }
                }

                // Divider thin bounding line
                Rectangle { Layout.fillWidth: true; height: 1; color: "#1e2235" }

                // Humidity Row
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "HUMIDITY"; color: "#5a6578"; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                    Text { text: "42%"; color: "#e2e8f0"; font.pixelSize: 12; font.weight: Font.Medium; Layout.alignment: Qt.AlignRight }
                }

                // Divider line
                Rectangle { Layout.fillWidth: true; height: 1; color: "#1e2235" }

                // Wind Velocity Row
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "WIND DIRECTION"; color: "#5a6578"; font.pixelSize: 11; font.bold: true; Layout.fillWidth: true }
                    Text { text: "NW 12 km/h"; color: "#e2e8f0"; font.pixelSize: 12; font.weight: Font.Medium; Layout.alignment: Qt.AlignRight }
                }
            }
        }
    }
}
