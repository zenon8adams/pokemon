import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import components 1.0
import assets 1.0

Window {
    id: topLevelWindow
    flags: Qt.Window | Qt.FramelessWindowHint
    visible: true
    width: 640
    height: 480
    color: "#ffffff"

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/images/backgroundImageII.jpg"
        smooth: true
    }
    GaussianBlur {
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: 10
        samples: 2 * radius + 1
    }
    Rectangle {
        id: contextArea
        color: "#00000000"
        anchors.left: sideBar.right
        anchors.leftMargin: 6
        anchors.top: parent.top
        anchors.topMargin: 69
        smooth: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        StackView {
            id: contentFrame
            anchors.fill: parent
            font.family: "Courier"
            initialItem: Qt.resolvedUrl("qrc:/views/Determinant.qml")
            replaceEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 700
                }
            }
            replaceExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 700
                }
            }
        }

    }
    GaussianBlur {
        id: contextAreaBlurEffect
        anchors.fill: contextArea
        source: contextArea
        visible: false
        radius: 20
        samples: 2 * radius + 1
    }

    WindowControls {
        id: windowControls
        onMinimizeButtonClicked: topLevelWindow.showMinimized()
        onMaximizeButtonClicked: showNormal ? topLevelWindow.showMaximized() : topLevelWindow.showNormal()
    }

    Sidebar {
        id: sideBar
        width: 144
        height: 1
        anchors.left: parent.left
        anchors.leftMargin: 0
        onHomeButtonClicked: {
            if(!sidePane.visible){
                sidePane.visible = contextAreaBlurEffect.visible = true
                contextArea.opacity = 0.05
                contentFrame.enabled = false
            }else{
                sidePane.visible = contextAreaBlurEffect.visible = false
                contextArea.opacity = 1.0
                contentFrame.enabled = true
            }
        }
    }
    Determinant {

    }

    Connections {
        id: connections
        target: masterController.ui_navigationController
        onGoDeterminantView: {
            contentFrame.replace("qrc:/views/Determinant.qml")
        }
        onGoDiscriminantView: {
            contentFrame.replace("qrc:/views/Discriminant.qml")
        }
        onGoFactorizationView: {
            contentFrame.replace("qrc:/views/Factorization.qml")
        }
        onGoLongDivisionView: {
            contentFrame.replace("qrc:/views/LongDivision.qml")
        }
        onGoSettingsView: {
            contentFrame.replace("qrc:/views/Settings.qml")
        }
    }
}
