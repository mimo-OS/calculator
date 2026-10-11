import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import FishUI 1.0 as FishUI

Item {
    id: control

    signal clicked(string text)

    property string text
    property string buttonType: "number" // "number", "operator", "function"
    property bool isActiveOperator: false
    property bool wideZero: false

    Layout.fillWidth: true
    Layout.fillHeight: true

    property color normalBg: {
        if (buttonType === "operator") {
            return isActiveOperator ? "#FFFFFF" : "#FF9F0A"
        } else if (buttonType === "function") {
            return FishUI.Theme.darkMode ? "#505050" : "#D4D4D2"
        } else {
            return FishUI.Theme.darkMode ? "#3B3B3B" : "#E5E5EA"
        }
    }

    property color hoverBg: {
        if (buttonType === "operator") {
            return isActiveOperator ? "#F0F0F0" : "#FFB340"
        } else if (buttonType === "function") {
            return FishUI.Theme.darkMode ? "#636366" : "#E5E5E5"
        } else {
            return FishUI.Theme.darkMode ? "#48484A" : "#D1D1D6"
        }
    }

    property color pressBg: {
        if (buttonType === "operator") {
            return "#CC7F08"
        } else if (buttonType === "function") {
            return FishUI.Theme.darkMode ? "#3A3A3C" : "#BCBCC0"
        } else {
            return FishUI.Theme.darkMode ? "#2C2C2E" : "#C7C7CC"
        }
    }

    property color labelColor: {
        if (buttonType === "operator") {
            return isActiveOperator ? "#FF9F0A" : "#FFFFFF"
        } else if (buttonType === "function") {
            return FishUI.Theme.darkMode ? "#FFFFFF" : "#000000"
        } else {
            return FishUI.Theme.darkMode ? "#FFFFFF" : "#000000"
        }
    }

    Rectangle {
        id: _background
        anchors.centerIn: parent
        width: control.width - 6
        height: control.height - 6
        radius: height / 2
        color: _mouseArea.pressed ? control.pressBg : (_mouseArea.containsMouse ? control.hoverBg : control.normalBg)
        antialiasing: true

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    MouseArea {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: control.clicked(control.text)
    }

    Label {
        id: _label
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: control.wideZero ? -parent.width * 0.22 : 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.labelColor
        text: control.text
        font.family: "SF Pro Display"
        font.pointSize: buttonType === "operator" ? Math.round(control.height * 0.36) : Math.round(control.height * 0.30)
        font.bold: buttonType === "operator" || buttonType === "function"
    }
}
