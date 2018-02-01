#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>
#include <QSslSocket>
#include <QDebug>

#include "spotifywrapper.h"
#include "fileio.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setFont(QFont("Roboto"));
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("SpotifyWrapper", new SpotifyWrapper(&engine));
    engine.rootContext()->setContextProperty("FileIO", new FileIO());

    qDebug() << "ASFLIHASIDLHLIASG" << QSslSocket::supportsSsl();

    qmlRegisterSingletonType(QUrl("qrc:/qml/global/spotify.qml"), "spotify", 1, 0, "Spotify");
    qmlRegisterSingletonType(QUrl("qrc:/qml/global/palette.qml"), "palette", 1, 0, "Palette");
    qmlRegisterSingletonType(QUrl("qrc:/qml/global/format.qml"), "format", 1, 0, "Format");
    qmlRegisterSingletonType(QUrl("qrc:/qml/global/settings.qml"), "settings", 1, 0, "Settings");

    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
