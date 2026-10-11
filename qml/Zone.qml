import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import FishUI 1.0 as FishUI

Item {
    id: zone

    property string displayText: "0"
    property string historyText: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 2

        // History / Expression label
        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            text: zone.historyText
            elide: Text.ElideLeft
            font.family: "SF Pro Text"
            font.pointSize: 10
            color: FishUI.Theme.disabledTextColor
        }

        // Primary Display
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                id: mainDisplay
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
                text: zone.displayText
                font.family: "SF Pro Display"
                font.weight: Font.Light
                font.pointSize: {
                    var len = zone.displayText.length
                    if (len <= 6) return 40
                    if (len <= 9) return 32
                    if (len <= 12) return 26
                    return 20
                }
                color: FishUI.Theme.textColor
                elide: Text.ElideLeft
            }
        }
    }
}
