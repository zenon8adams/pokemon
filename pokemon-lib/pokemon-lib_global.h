#ifndef POKEMONLIB_GLOBAL_H
#define POKEMONLIB_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(POKEMONLIB_LIBRARY)
#  define POKEMONLIBSHARED_EXPORT Q_DECL_EXPORT
#else
#  define POKEMONLIBSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif
