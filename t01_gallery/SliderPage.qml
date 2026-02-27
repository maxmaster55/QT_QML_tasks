import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Item {

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: 4

                Rectangle {
                    color: "transparent"

                    Image {
                        anchors.centerIn: parent
                        width: parent.width * 0.8
                        height: parent.height * 0.8

                        source: `qrc:/images/img${index}.jpg`
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }

        PageIndicator {
            Layout.alignment: Qt.AlignHCenter
            count: swipeView.count
            currentIndex: swipeView.currentIndex
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Back"

            onClicked: stackView.pop()
        }
    }
}
