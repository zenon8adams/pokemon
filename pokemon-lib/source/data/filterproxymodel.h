#ifndef FILTERPROXYMODEL_H
#define FILTERPROXYMODEL_H

#include <QSortFilterProxyModel>

#include <pokemon-lib_global.h>

namespace pn {
namespace data {
class POKEMONLIBSHARED_EXPORT FilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY onQueryChanged)

public:
    explicit FilterProxyModel(QObject *parent = nullptr);

    const QString& query() const;

public slots:
    void setQuery( const QString& q);

signals:
    void onQueryChanged( const QString& query);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    QString query_;
};
}
}

#endif // FILTERPROXYMODEL_H
