QT += qml quick core gui

TEMPLATE = app

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++14

SOURCES += \
            ../pokemon-lib/source/data/nlohmann_json.hpp \
            drivers/main.cpp

HEADERS += \
            nlohmann_json.hpp \
            string-processor.h

INCLUDEPATH += \
                drivers \
                ../pokemon-lib \
                ../pokemon-lib/source \
                ../pokemon-lib/source/data

RESOURCES += \
    components.qrc \
    assets.qrc \
    views.qrc

CONFIG(debug, debug|release)
{
    LIBS += -L$$PWD/../shadow-build/pokemon-lib/debug
}

CONFIG(release, debug|release)
{
    LIBS += -L$$PWD/../shadow-build/pokemon-lib/release
}

LIBS += -lpokemon-lib

message($$LIBS)

QML_IMPORT_PATH += $$PWD
