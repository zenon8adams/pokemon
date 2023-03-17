#include "listitemmodel.h"

#include <QDebug>

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QtNetwork/QNetworkReply>

namespace pn {
namespace data {

ListItemModel::ListItemModel(/*const QStringList& items, */QObject *parent)
    : QAbstractListModel (parent)//, items_(items)
{
}

int ListItemModel::rowCount(const QModelIndex&) const
{
    return items_.size();
}

QVariant ListItemModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= items_.count())
        return QVariant();

    auto entry = items_[ index.row()];
    if( role == Qt::UserRole)
        return entry.name;

    return QVariant::fromValue( entry);
}

bool ListItemModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if(index.isValid())
    {
        items_.replace( index.row(), qvariant_cast<Pokemon>( value));
        emit dataChanged(index, index, {role});
        return true;
    }
    return false;
}
bool ListItemModel::insertRows(int row, int count, const QModelIndex &)
{
    QAbstractItemModel::beginInsertRows(QModelIndex(), row, row+count-1);
    for(int n = 0; n < count; ++n)
        items_.insert(row, {});
    QAbstractItemModel::endInsertRows();
    return true;
}
bool ListItemModel::insertRow(int row, const QModelIndex& index)
{
    return insertRows(row, 1, index);
}

bool ListItemModel::removeRows(int row, int count, const QModelIndex &)
{
    QAbstractItemModel::beginRemoveRows(QModelIndex(), row, row+count-1);
    for(int n = 0; n < count; ++n)
        items_.removeAt( row);
    QAbstractItemModel::endRemoveRows();
    return true;
}
bool ListItemModel::removeRow(int row, const QModelIndex& index)
{
    return removeRows(row, 1, index);
}

QHash<int, QByteArray> ListItemModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names.insert( Qt::UserRole, "pokemon");
    return names;
}

bool ListItemModel::canFetchMore(const QModelIndex &) const
{
    return items_.size() < n_entries_;
}

void ListItemModel::setNextIterator( const QString& next_link)
{
    if( next_link.isEmpty())
        return;

    next_link_.push_back( next_link);
}
void ListItemModel::fetchMore(const QModelIndex &)
{
    if( next_link_.empty())
        return;

    QNetworkRequest request( next_link_.front());
    next_link_.pop_back();
    reply_.reset( mgr_.get( request));
    QObject::connect( reply_.get(), &QNetworkReply::readyRead, []{
    });
    QObject::connect( reply_.get(), &QNetworkReply::finished, [this] {
        auto response = QJsonDocument::fromJson( reply_->readAll());
        setNextIterator( response[ "next"].toString());
        QJsonArray list = response[ "results"].toArray();
        auto pokemon_list = QList<Pokemon>();
        for( int i = 0; i < list.size(); ++i)
        {
            auto p = Pokemon{};
            p.name = list[ i].toObject()[ "name"].toString();
            p.url  = list[ i].toObject()[ "url"].toString();
            pokemon_list.append( p);
        }
        appendData( pokemon_list);
    });
}

const QString& ListItemModel::selection() const
{
    return selection_;
}

QVariant ListItemModel::findChild(const QString &aName) const
{
    for( auto& p : items_)
        if( p.name == aName)
            return QVariant::fromValue( p);

    return {};
}

void ListItemModel::appendData( const QList<Pokemon>& repl)
{
    if( repl.empty())
        return;

    insertRows( items_.size(), repl.size(), QModelIndex());
    for (int row = items_.size() - repl.size(), i = 0; i < repl.size(); ++row, ++i)
    {
        QModelIndex idx = index( row, 0, QModelIndex());
        setData( idx, QVariant::fromValue( repl[ i]));
    }
}

void ListItemModel::setTotal( int n_entries)
{
    n_entries_ = n_entries;
}

void ListItemModel::setSelection( const QString& q)
{
    if( q == selection_)
        return;

    selection_ = q;
    emit onSelectionChanged( selection_);
}

}
}
