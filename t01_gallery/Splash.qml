import QtQuick
import QtQuick.Controls
import QtQuick.Window

Window {
    id: splash
    width: 500
    height: 400
    visible: true
    color: "white"
    flags: Qt.FramelessWindowHint
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    Column {
        anchors.centerIn: parent
        spacing: 20
        Image {
            source: "qrc:/images/abdo.jpeg"
            width: 200
            fillMode: Image.PreserveAspectFit
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Loading..."
            font.pixelSize: 20
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: false
        onTriggered: {
            splash.close();
            Qt.createComponent("Main.qml").createObject();
        }
    }
}
