pragma Singleton
import QtQuick 2.9
import QtQuick.Controls 2.4

Item {
    property alias fontAwesomeSolidLoader: fontAwesomeSolid.name
    property alias fontAwesomeRegularLoader: fontAwesomeRegular.name
    property alias fontAwesomeBrandsLoader: fontAwesomeBrands.name
    property alias textFontLoaderI: textFontI.name
    property alias textFontLoaderII: textFontII.name
    readonly property int closeButtonAnchorDim: 20

    readonly property color transparent: "#00000000"

    FontLoader{
        id: fontAwesomeSolid
        source: "qrc:/fonts/FontAwesome-Solid"
    }
    FontLoader{
        id: fontAwesomeRegular
        source: "qrc:/fonts/FontAwesome-Regular"
    }
    FontLoader{
        id: fontAwesomeBrands
        source: "qrc:/fonts/FontAwesome-Brands"
    }
    FontLoader{
        id: textFontI
        source: "qrc:/fonts/ColonnaMT"
    }
    FontLoader{
        id: textFontII
        source: "qrc:/fonts/MonotypeCorsiva"
    }
}
