#ifndef ICONSELECTOR_H
#define ICONSELECTOR_H

#include <QObject>
#include <QSortFilterProxyModel>
#include <pokemon-lib_global.h>

namespace pn {
namespace controllers {

class POKEMONLIBSHARED_EXPORT IconSelector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY onIconChanged)
    Q_PROPERTY(QString loading_indicator READ loading_indicator CONSTANT)

public:
    explicit IconSelector(QObject *parent = nullptr);
    ~IconSelector();
    const QString& icon() const;
    const QString& loading_indicator() const;

signals:
    void onIconChanged( const QString& icon);

public slots:
    void setIcon( const QString& icon);
private:
    class Implementation;
    QScopedPointer<Implementation> implementation;
};

}
}
#endif // MASTERCONTROLLER_H
