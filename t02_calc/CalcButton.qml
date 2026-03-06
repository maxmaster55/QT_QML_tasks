import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    signal clicked(string val)

    property string label: "0"
    property bool isOperator: false
    property bool isEquals: false
    property bool isClear: false
    property bool isWide: false

    // Tell the GridLayout our preferred size
    Layout.fillWidth: true
    Layout.fillHeight: true

    Button {
        anchors.fill: parent
        onClicked: { root.clicked(root.label) }

        background: Rectangle {
            radius: 14
            color: {
                if (isEquals)   return "#7c6af7"
                if (isOperator) return "#2a2a4a"
                if (isClear)    return "#2a2a4a"
                return "#1e1e3a"
            }

            border.color: {
                if (isEquals)   return "#9d8fff"
                if (isOperator) return "#7c6af7"
                return "transparent"
            }
            border.width: 1.5

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "white"
                opacity: parent.parent.hovered ? 0.06 : 0
                Behavior on opacity { NumberAnimation { duration: 120 } }
            }

            scale: parent.parent.pressed ? 0.94 : 1
            Behavior on scale { NumberAnimation { duration: 80 } }
        }

        contentItem: Text {
            text: root.label
            color: {
                if (isEquals)   return "#ffffff"
                if (isOperator) return "#9d8fff"
                if (isClear)    return "#ff6b8a"
                return "#e0e0ff"
            }
            font.pixelSize: 22
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }
}
