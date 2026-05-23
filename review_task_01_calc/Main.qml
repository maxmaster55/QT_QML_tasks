import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 360
    height: 580
    minimumWidth: 360
    minimumHeight: 580

    visible: true
    title: "Calculator"

    Rectangle {
        anchors.fill: parent
        color: "#1a1a2e"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Display
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                color: "#16213e"
                radius: 16

                Column {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 16
                    spacing: 4

                    Text {
                        id: expressionText
                        anchors.right: parent.right
                        text: backend.expression
                        color: "#6c7a9c"
                        font.pixelSize: 16
                    }

                    Text {
                        id: displayText
                        anchors.right: parent.right
                        text: backend.display
                        color: "#e0e0ff"
                        font.pixelSize: 48
                        font.weight: Font.Light
                    }
                }
            }

            // Button grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 4
                rowSpacing: 10
                columnSpacing: 10

                // Row 1
                CalcButton {
                    label: "C"
                    isClear: true
                    onClicked: backend.clear()
                }
                CalcButton {
                    label: "+/-"
                    onClicked: backend.toggleSign()
                }
                CalcButton {
                    label: "%"
                    onClicked: backend.percent()
                }
                CalcButton {
                    label: "÷"
                    isOperator: true
                    onClicked: backend.setOperation("÷")
                }

                // Row 2
                CalcButton {
                    label: "7"
                    onClicked: backend.input("7")
                }
                CalcButton {
                    label: "8"
                    onClicked: backend.input("8")
                }
                CalcButton {
                    label: "9"
                    onClicked: backend.input("9")
                }
                CalcButton {
                    label: "X"
                    isOperator: true
                    onClicked: backend.setOperation("X")
                }

                // Row 3
                CalcButton {
                    label: "4"
                    onClicked: backend.input("4")
                }
                CalcButton {
                    label: "5"
                    onClicked: backend.input("5")
                }
                CalcButton {
                    label: "6"
                    onClicked: backend.input("6")
                }
                CalcButton {
                    label: "-"
                    isOperator: true
                    onClicked: backend.setOperation("-")
                }

                // Row 4
                CalcButton {
                    label: "1"
                    onClicked: backend.input("1")
                }
                CalcButton {
                    label: "2"
                    onClicked: backend.input("2")
                }
                CalcButton {
                    label: "3"
                    onClicked: backend.input("3")
                }
                CalcButton {
                    label: "+"
                    isOperator: true
                    onClicked: backend.setOperation("+")
                }

                // Row 5
                CalcButton {
                    label: "0"
                    isWide: true
                    Layout.columnSpan: 2
                    onClicked: backend.input("0")
                }
                CalcButton {
                    label: "."
                    onClicked: backend.decimal()
                }
                CalcButton {
                    label: "="
                    isEquals: true
                    onClicked: backend.equals()
                }
            }
        }
    }

}
