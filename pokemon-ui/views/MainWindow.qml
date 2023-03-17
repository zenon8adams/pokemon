import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQml 2.0
import assets 1.0
import components 1.0
import QtQuick.Shapes 1.12
import views 1.0

Window {
    property string selected: ""
    id: topLevelWindow
    flags: Qt.Window | Qt.FramelessWindowHint
    visible: true
    width: 720
    height: 576
    color: "#ffffff"

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/images/background"
        anchors.rightMargin: 0
        anchors.bottomMargin: -2
        anchors.leftMargin: 0
        anchors.topMargin: 0
        smooth: true
    }

    GaussianBlur {
        source: backgroundImage
        anchors.bottomMargin: 0
        radius: 10
        anchors.fill: parent
        samples: 2 * radius + 1
    }

    StackView {
        property string selection: ""
        id: viewController
        anchors.fill: parent
        initialItem: Item {
            InputForm {
                id: inputForm
                x: 123
                y: 73
                width: 474
                height: 148
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenterOffset: 82
                anchors.horizontalCenterOffset: 8
                headerText: "Pokemon"
            }
            Loader {
                id: mainViewLoader
                asynchronous: true
                anchors.top: inputForm.bottom
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 78
                sourceComponent:  loading_indicator

                Component {
                    id: mainView
                    ListView {
                        id: listview
                        width: 210
                        spacing: 10
                        model: _proxy
                        delegate: Item {
                            id: listview_entry
                            width: parent.width
                            anchors.margins: 20
                            height: 40
                            layer.samples: 2
                            Rectangle {
                                id: listEntry
                                anchors.fill: parent
                                smooth: true
                                visible: false
                                color: "#eeeae3"
                                radius: 5
                                border.width: 0
                                Label {
                                    id: label
                                    x: 22
                                    width: 149
                                    height: 243
                                    text: model.pokemon
                                    font.capitalization: Font.Capitalize
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.top: parent.top
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 10
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.topMargin: 21
                                }
                            }

                            DropShadow {
                                id: dropShadow
                                anchors.fill: listEntry
                                horizontalOffset: 1
                                verticalOffset: 1
                                radius: 1.3
                                color: "#eddcb1"
                                source: listEntry
                                samples: 1
                                layer.smooth: true
                                spread: 0.4
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    selected = label.text
                                    detailViewLoader.source = Qt.resolvedUrl( "qrc:/views/DetailWindow.qml")
                                }
                                onEntered: listview_entry.state = "hover"
                                onExited: listview_entry.state = ""
                            }
                            states: [
                                State {
                                    name: "hover"
                                    PropertyChanges {
                                        target: listview_entry
                                        scale: 1.1
                                    }
                                }
                            ]
                        }

                    }
                }

                Component {
                    id: loading_indicator
                    SpinningLoader {
                        id: spinner
                        source: _iconSelector.icon
                        onReady: {
                            spinner.loader.state = "rotate";
                        }
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }

        Loader {
            id: detailViewLoader
            visible: false
            asynchronous: true
            onLoaded: {
                viewController.push( item)
                _listModel.selection = selected
            }
        }

        Binding {
            target: detailViewLoader.item
            property: "parent"
            value: viewController
        }

        Binding {
            target: detailViewLoader.item
            property: "loader"
            value: detailViewLoader
        }

        Connections {
            target: _proxy
            onRowsInserted: {
                mainViewLoader.sourceComponent = mainView;
            }
            onRowsRemoved: {
                if( _proxy.rowCount() !== 0)
                    mainViewLoader.sourceComponent = loading_indicator;
            }
        }
    }

    WindowControls {
        id: windowControls
        x: 648
        width: 61
        height: 28
        anchors.topMargin: 11
        anchors.rightMargin: 11
        onMinimizeButtonClicked: topLevelWindow.showMinimized()
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
