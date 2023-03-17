#ifndef LISTITEMMODEL_H
#define LISTITEMMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <pokemon-lib_global.h>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>


namespace pn {
namespace data {

class POKEMONLIBSHARED_EXPORT ListItemModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString selection READ selection WRITE setSelection NOTIFY onSelectionChanged)
public:

    struct Pokemon
    {
        int id;
        QString name;
        QString url;
    };

    ListItemModel( /*const QStringList& items = {}, */QObject *parent = nullptr);
    ~ListItemModel() override = default;
    int rowCount(const QModelIndex& index = QModelIndex())const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::UserRole) override;
    bool insertRows(int row, int count, const QModelIndex &index = QModelIndex()) override;
    bool removeRows(int row, int count, const QModelIndex &index = QModelIndex()) override;
    Q_INVOKABLE bool insertRow(int row, const QModelIndex& index = QModelIndex());
    Q_INVOKABLE bool removeRow(int row, const QModelIndex &index = QModelIndex());
    Q_INVOKABLE virtual bool canFetchMore(const QModelIndex &parent) const override;
    Q_INVOKABLE virtual void fetchMore(const QModelIndex &parent) override;
    QHash<int, QByteArray> roleNames() const override;
    const QString& selection() const;
    QVariant findChild(const QString &aName = QString()) const;
    void appendData( const QList<Pokemon>& repl);
    void setNextIterator( const QString& next_link);
    void setTotal( int n_entries);
public slots:
    void setSelection( const QString& q);

signals:
    void onSelectionChanged( const QString& query);

private:
    QList<Pokemon> items_;
    QString selection_;
    QList<QString> next_link_;
    QNetworkAccessManager mgr_;
    QScopedPointer<QNetworkReply, QScopedPointerDeleteLater> reply_;
    int n_entries_;
};

}
}

Q_DECLARE_METATYPE( pn::data::ListItemModel::Pokemon)

#endif // MENULISTMODEL_H
