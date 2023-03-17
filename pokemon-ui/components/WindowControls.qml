import QtQuick 2.9
import assets 1.0
import QtQuick.Window 2.2
Item {
    signal minimizeButtonClicked()
    signal maximizeButtonClicked()
    property bool showNormal: true
    anchors {
        right: parent.right
        top: parent.top
        topMargin: Style.closeButtonAnchorDim
        rightMargin: 110
    }
    Row {
        id: row
        spacing: 15
        Text {
            id: minimizeButtonFrame
            font {
                family: Style.fontAwesomeRegularLoader
                pixelSize: 20
            }
            color: "#ffffff"
            text: "\uf2d1"
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            bottomPadding: 5
            MouseArea {
                id: minimizeButton
                anchors.fill: parent
                hoverEnabled: true
                onEntered: minimizeButtonFrame.state = "hover"
                onExited: minimizeButtonFrame.state = ""
                onClicked: minimizeButtonClicked()
            }
            states: [
                State {
                    name: "hover"
                    PropertyChanges {
                        target: minimizeButtonFrame
                        scale: 1.5
                    }
                }
            ]
        }
        Text {
            id: closeButtonFrame
            font {
                family: Style.fontAwesomeSolidLoader
                pixelSize: 20
            }
            color: "#ffffff"
            text: "\uf011"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            MouseArea {
                id: closeButton
                anchors.fill: parent
                hoverEnabled: true
                onEntered: closeButtonFrame.state = "hover"
                onExited: closeButtonFrame.state = ""
                onClicked: Qt.quit()
            }
            states: [
                State {
                    name: "hover"
                    PropertyChanges {
                        target: closeButtonFrame
                        scale: 1.5
                        color: Qt.darker("#ff0000")
                    }
                }
            ]
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
