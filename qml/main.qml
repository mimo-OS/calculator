import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Cutefish.Calculator 1.0
import Qt.labs.platform 1.0
import FishUI 1.0 as FishUI

FishUI.Window {
    id: rootWindow
    width: 240
    height: 320
    minimumWidth: 230
    minimumHeight: 310
    maximumWidth: 320
    maximumHeight: 460
    title: qsTr("Calculator")

    background.color: FishUI.Theme.backgroundColor
    background.opacity: FishUI.Theme.blurEnabled ? 0.78 : 1.0
    clipContent: false

    header.height: 30

    CalcEngine {
        id: calcEngine
    }

    property string currentVal: "0"
    property string previousVal: ""
    property string activeOp: ""
    property bool isEntering: false
    property string historyStr: ""

    function opToEvalSymbol(op) {
        if (op === "÷") return "/"
        if (op === "×") return "*"
        if (op === "−") return "-"
        return op
    }

    function calculate(evalText) {
        var res = calcEngine.eval(evalText)
        return res
    }

    function executeOp(op) {
        if (activeOp !== "" && isEntering) {
            computeResult(false)
        }

        previousVal = currentVal
        activeOp = op
        isEntering = false
        historyStr = previousVal + " " + op
    }

    function computeResult(fromEqual) {
        if (activeOp === "" || previousVal === "")
            return

        var expr = previousVal + " " + opToEvalSymbol(activeOp) + " " + currentVal
        var res = calculate(expr)

        if (res !== "" && res !== "nan" && res !== "inf") {
            if (fromEqual) {
                historyStr = previousVal + " " + activeOp + " " + currentVal + " ="
                activeOp = ""
                previousVal = ""
            } else {
                previousVal = res
            }
            currentVal = res
            isEntering = false
        }
    }

    function handleAction(action) {
        if (action >= "0" && action <= "9") {
            if (!isEntering || currentVal === "0") {
                currentVal = action
                isEntering = true
            } else {
                if (currentVal.length < 14) {
                    currentVal += action
                }
            }
        } else if (action === ".") {
            if (!isEntering) {
                currentVal = "0."
                isEntering = true
            } else if (currentVal.indexOf(".") === -1) {
                currentVal += "."
            }
        } else if (action === "AC") {
            currentVal = "0"
            previousVal = ""
            activeOp = ""
            historyStr = ""
            isEntering = false
        } else if (action === "C") {
            currentVal = "0"
            isEntering = false
        } else if (action === "+/-") {
            if (currentVal !== "0") {
                if (currentVal.startsWith("-"))
                    currentVal = currentVal.substring(1)
                else
                    currentVal = "-" + currentVal
            }
        } else if (action === "%") {
            var n = parseFloat(currentVal)
            if (!isNaN(n)) {
                currentVal = (n / 100.0).toString()
            }
        } else if (action === "+" || action === "−" || action === "×" || action === "÷") {
            executeOp(action)
        } else if (action === "=") {
            computeResult(true)
        }
    }

    // Keyboard support
    Item {
        focus: true
        Keys.onPressed: function(event) {
            if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                handleAction(String(event.key - Qt.Key_0))
                event.accepted = true
            } else if (event.key === Qt.Key_Period || event.key === Qt.Key_Comma) {
                handleAction(".")
                event.accepted = true
            } else if (event.key === Qt.Key_Plus) {
                handleAction("+")
                event.accepted = true
            } else if (event.key === Qt.Key_Minus) {
                handleAction("−")
                event.accepted = true
            } else if (event.key === Qt.Key_Asterisk) {
                handleAction("×")
                event.accepted = true
            } else if (event.key === Qt.Key_Slash) {
                handleAction("÷")
                event.accepted = true
            } else if (event.key === Qt.Key_Equal || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                handleAction("=")
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                handleAction("AC")
                event.accepted = true
            } else if (event.key === Qt.Key_Backspace) {
                if (currentVal.length > 1 && currentVal !== "0") {
                    currentVal = currentVal.substring(0, currentVal.length - 1)
                } else {
                    currentVal = "0"
                }
                event.accepted = true
            } else if (event.key === Qt.Key_Percent) {
                handleAction("%")
                event.accepted = true
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: rootWindow.header.height
        spacing: 0

        Zone {
            id: zone
            Layout.fillWidth: true
            Layout.preferredHeight: rootWindow.height * 0.28
            displayText: rootWindow.currentVal
            historyText: rootWindow.historyStr
        }

        StandardPad {
            id: pad
            Layout.fillWidth: true
            Layout.fillHeight: true
            activeOperator: rootWindow.activeOp
            hasInput: rootWindow.currentVal !== "0" && rootWindow.isEntering

            onActionTriggered: function(action) {
                rootWindow.handleAction(action)
            }
        }
    }
}
