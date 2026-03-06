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
                        text: calc.expression
                        color: "#6c7a9c"
                        font.pixelSize: 16
                    }

                    Text {
                        id: displayText
                        anchors.right: parent.right
                        text: calc.display
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
                CalcButton { label: "C";   isClear: true;    onClicked: calc.clear() }
                CalcButton { label: "+/-";                   onClicked: calc.toggleSign() }
                CalcButton { label: "%";                     onClicked: calc.percent() }
                CalcButton { label: "÷";   isOperator: true; onClicked: calc.operator("÷") }


                // Row 2
                CalcButton { label: "7"; onClicked: calc.input("7") }
                CalcButton { label: "8"; onClicked: calc.input("8") }
                CalcButton { label: "9"; onClicked: calc.input("9") }
                CalcButton { label: "×"; isOperator: true; onClicked: calc.operator("×") }

                // Row 3
                CalcButton { label: "4"; onClicked: calc.input("4") }
                CalcButton { label: "5"; onClicked: calc.input("5") }
                CalcButton { label: "6"; onClicked: calc.input("6") }
                CalcButton { label: "-"; isOperator: true; onClicked: calc.operator("-") }

                // Row 4
                CalcButton { label: "1"; onClicked: calc.input("1") }
                CalcButton { label: "2"; onClicked: calc.input("2") }
                CalcButton { label: "3"; onClicked: calc.input("3") }
                CalcButton { label: "+"; isOperator: true; onClicked: calc.operator("+") }

                // Row 5
                CalcButton { label: "0"; isWide: true; Layout.columnSpan: 2; onClicked: calc.input("0") }
                CalcButton { label: ".";  onClicked: calc.decimal() }
                CalcButton { label: "="; isEquals: true; onClicked: calc.equals() }            }
        }
    }

    QtObject {
        id: calc

        property string display: "0"
        property string expression: ""
        property double firstOperand: 0
        property string pendingOperator: ""
        property bool waitingForSecond: false

        function input(value) {
            if (waitingForSecond) {
                display = value
                waitingForSecond = false
            } else {
                display = (display === "0") ? value : display + value
            }
        }

        function operator(op) {
            firstOperand = parseFloat(display)
            pendingOperator = op
            expression = display + " " + op
            waitingForSecond = true
        }

        function equals() {
            if (pendingOperator === "") return

            let second = parseFloat(display)
            let result = 0

            expression = expression + " " + display + " ="

            switch (pendingOperator) {
                case "+": result = firstOperand + second; break
                case "-": result = firstOperand - second; break
                case "×": result = firstOperand * second; break
                case "÷": result = second !== 0 ? firstOperand / second : "Error"; break
            }

            display = result.toString()
            pendingOperator = ""
            waitingForSecond = true
        }

        function clear() {
            display = "0"
            expression = ""
            firstOperand = 0
            pendingOperator = ""
            waitingForSecond = false
        }

        function toggleSign() {
            display = (parseFloat(display) * -1).toString()
        }

        function percent() {
            display = (parseFloat(display) / 100).toString()
        }

        function decimal() {
            if (!display.includes(".")) display = display + "."
        }
    }
}
