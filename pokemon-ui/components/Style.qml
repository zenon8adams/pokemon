import QtQuick 2.9

Item {
    property alias fontAwesomeLoader: fontAwesome.name
    property alias textFontLoader: textFont.name

    FontLoader{
        id: fontAwesome
        source: "qrc:/fonts/fontawesome"
    }
    FontLoader{
        id: textFont
        source: "qrc:/fonts/ColonnaMT"
    }
}
