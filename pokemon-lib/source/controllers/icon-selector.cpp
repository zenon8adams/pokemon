#include <QObject>
#include <QScopedPointer>
#include "icon-selector.h"
#include <QDebug>
#include <QStringListModel>

namespace pn {
namespace controllers {

class IconSelector::Implementation
{
public:
    Implementation(IconSelector *_masterController)
        : masterController(_masterController)
    {
    }
    IconSelector *masterController{ nullptr };
    QString loading_indicator_{ "qrc:/images/loading"}, icon_{ loading_indicator_};
};

IconSelector::IconSelector(QObject *parent)
    : QObject(parent)
{
    implementation.reset(new Implementation(this));
}
IconSelector::~IconSelector()
{
}

void IconSelector::setIcon( const QString& icon)
{
    if( icon == implementation->icon_)
        return;

    implementation->icon_ = icon;
    emit onIconChanged( implementation->icon_);
}

const QString& IconSelector::icon() const
{
    return implementation->icon_;
}

const QString& IconSelector::loading_indicator() const
{
    return implementation->loading_indicator_;
}

}
}
