import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

Item {
    property var images: [
        {
            name: "Cat 1",
            desc: "this cat is suspicious of u"
        },
        {
            name: "Cat 2",
            desc: "this cat is confident"
        },
        {
            name: "Cat 3",
            desc: "this cat has something to say"
        },
        {
            name: "Cat 4",
            desc: "this cat is tired"
        },
    ]

    Dialog {
        id: myDialog
        modal: true
        parent: Overlay.overlay
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        property int imageNum
        property string imageName
        property string imageDesc

        header: Label {
            text: myDialog.imageName
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 24
            padding: 12
            width: parent.width
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Label {
                text: `Description: ${myDialog.imageDesc}`
            }
        }

        onAccepted: {
            console.log("OK pressed");
        }
    }

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

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                myDialog.imageNum = index + 1;
                                myDialog.imageName = images[index].name;
                                myDialog.imageDesc = images[index].desc;
                                myDialog.open();
                            }
                        }
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
