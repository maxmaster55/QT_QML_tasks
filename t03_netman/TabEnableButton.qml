import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


TabButton {
    id: root
    property int margin: 16
    property alias label: tab_text.text
    property alias switchChecked: wifi_switch.checked

    signal switchToggled(bool is_checked)

    contentItem: RowLayout{
        anchors.fill: parent
        anchors.leftMargin: margin
        anchors.rightMargin: margin

        Text {
            Layout.alignment: Qt.AlignLeft
            id: tab_text
        }
        // spacer
        Item { Layout.fillWidth: true }

        Switch {
            id: wifi_switch
            Layout.alignment: Qt.AlignRight
            onToggled: switchToggled(checked)
        }
    }
}
