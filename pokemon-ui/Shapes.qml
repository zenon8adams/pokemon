import QtQuick 2.0
import QtQml 2.0
import QtQuick.Layouts 1.0

Item {
    width: 720
    height: 560
    ListModel {
        id: listModel
        ListElement {
            name: "Jim Williams"
            color: "red"
        }
        ListElement {
            name: "John Brown"
            color: "green"
        }
        ListElement {
            name: "Bill Smyth"
            color: "blue"
        }
        ListElement {
            name: "Sam Wise"
            color: "pink"
        }
    }

//    width: 300; height: 300

    Rectangle {
             id: rect
             width: 100; height: 100
             color: "red"

             MouseArea {
                id: mouseArea
                anchors.fill: parent
             }

             states: State {
                name: "resized"; when: mouseArea.pressed
                PropertyChanges {
                    target: rect
                    color: "blue"
                }
             }
         }



//    Component {
//        id: contactDelegate
//        Item {
//            anchors.margins: 20
//            ColumnLayout {
//                Layout.fillHeight: true
//                Layout.fillWidth: true
//                Layout.margins: 20
//                Rectangle { width: grid.cellWidth - 10; /*height: grid.cellHeight - 10;*/ color: "red"; Layout.alignment: Qt.AlignHCenter }
//                Text { text: name; Layout.alignment: Qt.AlignHCenter }
//            }
//        }
//    }

//    GridView {
//        id: grid
//        anchors.margins: 10
//        anchors.fill: parent
//        cellWidth: grid.width / 2; cellHeight: 100
//        model: listModel
//        delegate: contactDelegate
//        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
//        focus: true
//    }
}
