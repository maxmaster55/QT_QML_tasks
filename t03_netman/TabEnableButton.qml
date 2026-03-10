import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

TabButton {
    id: root
    property int margin: 16
    property alias label: tab_text.text
    property alias switchChecked: wifi_switch.checked

    signal switchToggled(bool is_checked)

    contentItem: RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.margin
        anchors.rightMargin: root.margin

        Text {
            id: tab_text
            Layout.alignment: Qt.AlignLeft
        }
        // spacer
        Item {
            Layout.fillWidth: true
        }

        Switch {
            id: wifi_switch
            Layout.alignment: Qt.AlignRight
            onToggled: root.switchToggled(checked)
        }
    }
}
