import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI

Item {
    id: control

    property string activeOperator: ""
    property bool hasInput: false

    signal actionTriggered(string action)

    GridLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.margins: 10
        columnSpacing: 6
        rowSpacing: 6
        columns: 4

        // Row 1
        StandardButton {
            text: control.hasInput ? "C" : "AC"
            buttonType: "function"
            onClicked: control.actionTriggered(text)
        }
        StandardButton {
            text: "+/-"
            buttonType: "function"
            onClicked: control.actionTriggered("+/-")
        }
        StandardButton {
            text: "%"
            buttonType: "function"
            onClicked: control.actionTriggered("%")
        }
        StandardButton {
            text: "÷"
            buttonType: "operator"
            isActiveOperator: control.activeOperator === "÷"
            onClicked: control.actionTriggered("÷")
        }

        // Row 2
        StandardButton { text: "7"; buttonType: "number"; onClicked: control.actionTriggered("7") }
        StandardButton { text: "8"; buttonType: "number"; onClicked: control.actionTriggered("8") }
        StandardButton { text: "9"; buttonType: "number"; onClicked: control.actionTriggered("9") }
        StandardButton {
            text: "×"
            buttonType: "operator"
            isActiveOperator: control.activeOperator === "×"
            onClicked: control.actionTriggered("×")
        }

        // Row 3
        StandardButton { text: "4"; buttonType: "number"; onClicked: control.actionTriggered("4") }
        StandardButton { text: "5"; buttonType: "number"; onClicked: control.actionTriggered("5") }
        StandardButton { text: "6"; buttonType: "number"; onClicked: control.actionTriggered("6") }
        StandardButton {
            text: "−"
            buttonType: "operator"
            isActiveOperator: control.activeOperator === "−"
            onClicked: control.actionTriggered("−")
        }

        // Row 4
        StandardButton { text: "1"; buttonType: "number"; onClicked: control.actionTriggered("1") }
        StandardButton { text: "2"; buttonType: "number"; onClicked: control.actionTriggered("2") }
        StandardButton { text: "3"; buttonType: "number"; onClicked: control.actionTriggered("3") }
        StandardButton {
            text: "+"
            buttonType: "operator"
            isActiveOperator: control.activeOperator === "+"
            onClicked: control.actionTriggered("+")
        }

        // Row 5
        StandardButton {
            text: "0"
            buttonType: "number"
            wideZero: true
            Layout.columnSpan: 2
            onClicked: control.actionTriggered("0")
        }
        StandardButton { text: "."; buttonType: "number"; onClicked: control.actionTriggered(".") }
        StandardButton {
            text: "="
            buttonType: "operator"
            onClicked: control.actionTriggered("=")
        }
    }
}
