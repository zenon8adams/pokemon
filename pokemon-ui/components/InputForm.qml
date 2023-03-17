import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import components 1.0
import assets 1.0

Item {
    id: item1
    property string headerText: ""

    Rectangle {
        id: rectangle
        color: "#00000000"
        anchors.fill: parent

        TextField {
            id: inputField
            width: 400
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 16
            font.weight: Font.Light
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: 20

            placeholderText: "Search for your favorite pokemon..."
            focus: true
            background: Rectangle {
                implicitWidth: inputField.width
                implicitHeight: inputField.height
                border.width: 0.2
                radius: 30
            }

            onTextChanged: {
                _proxy.query = inputField.text
            }
        }
        Text {
            id: header
            x: 22
            width: 375
            height: 45
            color: "#ffffff"
            text: headerText
            anchors.top: parent.top
            font.capitalization: Font.AllUppercase
            font.family: "Verdana"
            textFormat: Text.RichText
            font.bold: true
            font.weight: Font.ExtraBold
            fontSizeMode: Text.FixedSize
            renderType: Text.QtRendering
            horizontalAlignment: Text.AlignHCenter
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 30
        }
    }
}


/*##^##
Designer {
    D{i:0;height:144;width:474}
}
##^##*/
