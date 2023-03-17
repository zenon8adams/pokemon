#include "filterproxymodel.h"
#include "listitemmodel.h"

namespace pn {
namespace data {
    FilterProxyModel::FilterProxyModel(QObject *parent)
        : QSortFilterProxyModel( parent)
    {
    }

    const QString& FilterProxyModel::query() const
    {
        return query_;
    }

    void FilterProxyModel::setQuery( const QString& q)
    {
        if( q == query_)
            return;

        query_ = q;
        emit onQueryChanged( query_);
        invalidateFilter();

    }

    bool FilterProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
    {
        const QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);
        if( !index.isValid())
            return false;

        return qvariant_cast<pn::data::ListItemModel::Pokemon>( index.data()).name.contains( query_);
    }

}
}

