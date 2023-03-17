import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Shapes 1.12
import assets 1.0
import components 1.0
import QtQml 2.0
import views 1.0

Item {
    id: details
    property StackView viewController: parent
    property Loader loader: Loader{}
    width: 720
    height: 576
    Rectangle {
        id: rectangle
        y: 50
        height: 148
        color: "#00000000"
        border.color: "#a17c61"
        border.width: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: groupBox.top
        anchors.bottomMargin: -1
        anchors.rightMargin: 226
        anchors.leftMargin: 226

        SpinningLoader {
            id: pokemon_img
            source: _iconSelector.icon
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenterOffset: 1
            anchors.rightMargin: 0
            anchors.bottomMargin: -2
            anchors.leftMargin: 0
            anchors.topMargin: 0
            smooth: true
            width: 116
            height: 116
            onReady: {
                if( pokemon_img.source === _iconSelector.loading_indicator)
                    pokemon_img.loader.state = "rotate";
                else
                    pokemon_img.loader.state = "";
            }
        }

        Label {
            x: 60
            y: 94
            width: 187
            height: 39
            color: "#fcfcfc"
            text: _listModel.selection
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            rightPadding: 5
            font.pointSize: 12
            font.family: "Verdana"
            font.capitalization: Font.Capitalize
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
        }

    }

    GroupBox {
        id: groupBox
        y: 197
        height: 288
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 29
        anchors.leftMargin: 29
        focusPolicy: Qt.ClickFocus
        focus: true
        font.pointSize: 9
        font.weight: Font.Thin
        font.family: "Verdana"
        label: Label {
            color: "#fdfdfd"
            text: qsTr("Abilities")
        }

        ListView {
            id: detail_view
            anchors.fill: parent
            spacing: 12
            clip:true
            orientation:ListView.Vertical
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            model: _detail
            delegate: Component {
                id: delegateComp
                ColumnLayout
                {
                    width: parent.width
                    Text {
                        font.pixelSize: 15
                        text: display
                        wrapMode: Text.Wrap
                        font.capitalization: Font.Capitalize
                        Layout.fillWidth: true
                        color: "#33302f"
                    }
                }
            }
        }
    }

    RoundButton {
        id: back_button
        text: "\uf2ea"
        anchors.left: parent.left
        anchors.top: groupBox.bottom
        anchors.leftMargin: 651
        anchors.topMargin: 31
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: back_button.state = "hover"
            onExited: back_button.state = ""
            onClicked: {
                _iconSelector.icon = Qt.resolvedUrl( _iconSelector.loading_indicator);
                viewController.pop();
                loader.source = "";
            }

        }
        states: [
            State {
                name: "hover"
                PropertyChanges {
                    target: back_button
                    scale: 1.5
                }
            }
        ]
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
