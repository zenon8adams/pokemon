#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <controllers/icon-selector.h>
#include <QSortFilterProxyModel>
#include <data/listitemmodel.h>
#include <data/filterproxymodel.h>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QByteArray>
#include <QStringListModel>
#include <QTimer>
#include <nlohmann_json.hpp>


using json = nlohmann::json;

#define READ_BUFFER_SIZE 4096

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/images/pokemon"));
    qmlRegisterType<pn::controllers::IconSelector>("Pokemon", 1, 0, "IconSelector");
    qmlRegisterType<pn::data::ListItemModel>("Pokemon", 1, 0, "ListItemModel");
    pn::controllers::IconSelector iconSelector;
    QQmlApplicationEngine engine;

    struct Icon
    {
        QString icon_url;
    } icon;

    constexpr const int timeout = 1500;

    QStringListModel detail_model;
    pn::data::ListItemModel model;
    pn::data::FilterProxyModel proxy;
    proxy.setSourceModel( &model);

    QNetworkAccessManager mgr;
    QScopedPointer<QNetworkReply, QScopedPointerDeleteLater> reply;

    QString base_url = "https://pokeapi.co/api/v2/%1";

    QByteArray packet;

    QNetworkRequest request( QUrl( base_url.arg( "pokemon/")));
    reply.reset( mgr.get( request));

    std::function<void()> query_pokemons = [ &] {
        if( reply->error() == QNetworkReply::NoError)
        {
            auto response  = json::parse( reply->readAll());
            QString next_link = response[ "next"].get<std::string>().data();
            auto n_entries = response[ "count"].get<int>();
            model.setTotal( n_entries);
            model.setNextIterator( next_link);

            auto list = response[ "results"];

            using Pokemon = pn::data::ListItemModel::Pokemon;
            auto pokemon_list = QList<Pokemon>();
            for( auto& each : list)
            {
                auto p = Pokemon{};
                p.name = each[ "name"].get<std::string>().data();
                p.url  = each[ "url"].get<std::string>().data();
                pokemon_list.append( p);
            }
            model.appendData( pokemon_list);
        }
        else {
            qWarning() << reply->errorString();
            QTimer::singleShot( timeout, &app, [&]{
                reply.reset( mgr.get( reply->request()));
                QObject::connect( reply.get(), &QNetworkReply::finished, query_pokemons);
            });
        }
    };

    QObject::connect( reply.get(), &QNetworkReply::finished, query_pokemons);

    std::vector<std::unique_ptr<QNetworkReply>> sessions;
    std::function<void(qint64, qint64)> download_progress;
    std::function<void()> finished;
    std::function<void()> ready_read;
    std::unordered_map<QNetworkReply *, QString> links;

    QObject::connect( &model, &pn::data::ListItemModel::onSelectionChanged, [ &]( auto selection) mutable
    {
        detail_model.setStringList({});
        for( auto& session : sessions)
            if( session->url() == selection)
                return;

        auto pokemon = qvariant_cast<pn::data::ListItemModel::Pokemon>( model.findChild( selection));
        QNetworkRequest request( QUrl( pokemon.url));
        sessions.emplace_back( mgr.get( request));
        auto& reply = sessions.back();
        links[ reply.get()] = pokemon.url;

        download_progress = [ &, request]( auto recv, auto total) {
            if( recv == total && recv != -1 && !packet.isEmpty())
            {
                try {
                    auto j = json::parse( packet.toStdString());

                    QStringList pieces;
                    auto j_abilities = j[ "abilities"];
                    QStringList abilites;
                    for( auto ability : j_abilities)
                        abilites.push_back( ability[ "ability"][ "name"].get<std::string>().data());

                    QString all = abilites.join(", ");
                    if( !all.isEmpty())
                        pieces.append( "<b>abilities:</b> " + all);

                    auto j_forms = j[ "forms"];
                    QStringList forms;
                    for( auto form : j_forms)
                        forms.push_back( form[ "name"].get<std::string>().data());

                    all = forms.join(", ");
                    if( !all.isEmpty())
                        pieces.append( "<b>forms: </b>" + all);

                    auto j_moves = j[ "moves"];
                    QStringList moves;
                    for( auto move : j_moves)
                        moves.push_back( move["move"][ "name"].get<std::string>().data());

                    all = moves.join(", ");
                    if( !all.isEmpty())
                        pieces.append( "<b>moves: </b>" + all);

                    auto j_stats = j[ "stats"];
                    QVector<QPair<QString, int>> stats;
                    for( auto stat : j_stats)
                    {
                        QString k = stat["stat"][ "name"].get<std::string>().data();
                        auto v = stat[ "base_stat"].get<int>();
                        if( k.isEmpty())
                            continue;

                        pieces.append( QStringLiteral("<b>%1</b>: %2").arg( k).arg( v));
                    }

                    auto j_types = j[ "types"];
                    QVector<QPair<QString, int>> types;
                    for( auto type : j_types)
                    {
                        QString k = type["type"][ "name"].get<std::string>().data();
                        auto v = type[ "slot"].get<int>();
                        if( k.isEmpty())
                            continue;

                        pieces.append( QStringLiteral("<b>%1</b>: %2").arg( k).arg( v));
                    }

                    auto weight = j[ "weight"].get<int>();
                    pieces.append( QStringLiteral("<b>weight</b>: %2").arg( weight));

                    detail_model.setStringList( pieces);

                    iconSelector.setIcon( j[ "sprites"][ "front_default"].get<std::string>().data());
                }
                catch(...)
                {

                }
            }
        };

        QObject::connect( reply.get(), &QNetworkReply::downloadProgress, download_progress);

        ready_read = [&packet, &reply, request] {
            if( reply != nullptr)
            {
                if( reply.get()->error() == QNetworkReply::NoError)
                    packet.append( reply.get()->readAll());
                else
                {
                    qWarning() << reply.get()->errorString();
                }
            }
        };

        QObject::connect( reply.get(), &QNetworkReply::readyRead, ready_read);

        finished = [ &, request] {
            if( reply != nullptr)
            {
                if( reply.get()->error() == QNetworkReply::NoError)
                {
                    sessions.erase( std::remove_if( sessions.begin(), sessions.end(), [&reply]( auto& session){
                        return session == reply;
                    }), sessions.end());
                }
                else
                {
                    packet.clear();
                    QTimer::singleShot( timeout, &app, [&]{
                        auto link = links[ reply.get()];
                        links.erase( links.find( reply.get()));
                        if( link.isEmpty())
                            return;

                        reply.reset( mgr.get( QNetworkRequest( QUrl( link))));
                        links[ reply.get()] = link;
                        QObject::connect( reply.get(), &QNetworkReply::downloadProgress, download_progress);
                        QObject::connect( reply.get(), &QNetworkReply::readyRead, ready_read);
                        QObject::connect( reply.get(), &QNetworkReply::finished, finished);
                    });
                }
            }

            packet.clear();
        };

        QObject::connect( reply.get(), &QNetworkReply::finished, finished);
    });

    engine.addImportPath("qrc:/");
    engine.rootContext()->setContextProperty("_iconSelector", &iconSelector);
    engine.rootContext()->setContextProperty("_listModel", &model);
    engine.rootContext()->setContextProperty("_proxy", &proxy);
    engine.rootContext()->setContextProperty("_detail", &detail_model);
    engine.load(QUrl(QStringLiteral("qrc:/views/MainWindow.qml")));
    if(engine.rootObjects().empty())
        return -1;

    return app.exec();
}
