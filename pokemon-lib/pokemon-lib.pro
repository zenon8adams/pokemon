#-------------------------------------------------
#
# Project created by QtCreator 2019-12-05T09:24:21
#
#-------------------------------------------------


TARGET = pokemon-lib
TEMPLATE = lib
QT += network

DEFINES += POKEMONLIB_LIBRARY

# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        source/controllers/icon-selector.cpp \
        source/data/filterproxymodel.cpp \
        source/data/listitemmodel.cpp \

HEADERS += \
        pokemon-lib_global.h \
        source/controllers/icon-selector.h \
        source/data/filterproxymodel.h \
        source/data/listitemmodel.h \
        source/data/nlohmann_json.hpp

unix {
    target.path = /usr/lib
    INSTALLS += target
}
