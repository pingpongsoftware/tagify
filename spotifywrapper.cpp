#include "spotifywrapper.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

const QString CLIENT_ID = "21f03237654e4d71b7da15958af648e8";
const QString CLIENT_SECRET = "a2a78d1c68494f16b79240ffe2423eb1";
const QString REDIRECT_URI = "http://127.0.0.1:8163";
const QString SCOPE = "playlist-read-private playlist-read-collaborative user-follow-read user-library-read user-read-private user-top-read user-read-playback-state user-modify-playback-state user-read-currently-playing user-read-recently-played";

SpotifyWrapper::SpotifyWrapper(QQmlApplicationEngine *engine, QObject *parent) : QObject(parent) {
    _engine = engine;

    _oauth.setReplyHandler(new QOAuthHttpServerReplyHandler(8163, this));
    _oauth.setAuthorizationUrl(QUrl("https://accounts.spotify.com/authorize?redirect_uri=" + REDIRECT_URI));
    _oauth.setAccessTokenUrl(QUrl("https://accounts.spotify.com/api/token"));
    _oauth.setClientIdentifier(CLIENT_ID);
    _oauth.setClientIdentifierSharedKey(CLIENT_SECRET);
    _oauth.setScope(SCOPE);

    connect(&_oauth, &QOAuth2AuthorizationCodeFlow::authorizeWithBrowser, this, &SpotifyWrapper::openUrl);
    connect(&_oauth, &QOAuth2AuthorizationCodeFlow::granted, this, &SpotifyWrapper::granted);
    connect(&_oauth, &QOAuth2AuthorizationCodeFlow::error, this, &SpotifyWrapper::authError);
    connect(&_oauth, &QOAuth2AuthorizationCodeFlow::replyDataReceived, [=](const QByteArray &data){
        qDebug() << "reply data recieved" << data;
    });
    connect(&_oauth, &QOAuth2AuthorizationCodeFlow::tokenChanged, [=](const QString &token) {
        qDebug() << "token changes" << token;
    });
}

void SpotifyWrapper::signIn() {
    _oauth.grant();
}

void SpotifyWrapper::authError(const QString &error, const QString &description, const QUrl &uri) {
    qDebug() << "Authentication Error";
    qDebug() << error;
    qDebug() << description;
    qDebug() << uri;
}

void SpotifyWrapper::get(const QUrl &url, QJSValue callback) {
    if (!callback.isCallable()) {
        qDebug() << "WARNING: Callback must be a function";
    }

    QNetworkRequest request(url);
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Authorization", "Bearer " + _oauth.token().toUtf8());

    QNetworkReply *reply = _manager.get(request);
    QByteArray *data = new QByteArray();

    connect(reply, &QNetworkReply::readyRead, [=]() {
        while(!reply->atEnd()) {
            data->append(reply->read(1000).replace("\n", ""));
        }
    });

    connect(reply, &QNetworkReply::finished, [=]() {
        callCallback(QString(*data), callback);
        delete data;
    });
}

void SpotifyWrapper::put(const QUrl &url, const QString &data, QJSValue callback = QJSValue()) {
    if (!callback.isCallable()) {
        qDebug() << "WARNING: Callback must be a function";
    }

    QNetworkRequest request(url);
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Authorization", "Bearer " + _oauth.token().toUtf8());

    QNetworkReply *reply = _manager.put(request, data.toUtf8());

    connect(reply, &QNetworkReply::finished, [=]() {
        callCallback(QString(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString()), callback);
    });
}

void SpotifyWrapper::post(const QUrl &url, const QString &data, QJSValue callback) {
    if (!callback.isCallable()) {
        qDebug() << "WARNING: Callback must be a function";
    }

    QNetworkRequest request(url);
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Authorization", "Bearer " + _oauth.token().toUtf8());

    QNetworkReply *reply = _manager.post(request, data.toUtf8());

    connect(reply, &QNetworkReply::finished, [=]() {
        callCallback(QString(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString()), callback);
    });
}

void SpotifyWrapper::callCallback(const QString &reply, QJSValue callback) {
    QJSValueList params;
    QJSValue val(reply);
    params.append(val);
    callback.call(params);
}
