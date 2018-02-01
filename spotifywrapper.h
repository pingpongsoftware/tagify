#ifndef SPOTIFYWRAPPER_H
#define SPOTIFYWRAPPER_H

#include <QObject>
#include <QtNetworkAuth>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJSValue>
#include <QQmlApplicationEngine>

class SpotifyWrapper : public QObject
{
    Q_OBJECT
public:
    explicit SpotifyWrapper(QQmlApplicationEngine *engine, QObject *parent = nullptr);

    Q_PROPERTY(QOAuth2AuthorizationCodeFlow* oauth READ oauth CONSTANT)

    Q_INVOKABLE void signIn();
    Q_INVOKABLE void get(const QUrl &url, QJSValue callback);
    Q_INVOKABLE void put(const QUrl &url, const QString &data, QJSValue callback);
    Q_INVOKABLE void post(const QUrl &url, const QString &data, QJSValue callback);

private:
    QQmlApplicationEngine *_engine;
    QOAuth2AuthorizationCodeFlow _oauth;
    QNetworkAccessManager _manager;
    QString _token;

    QOAuth2AuthorizationCodeFlow *oauth() { return &_oauth; }

    void callCallback(const QString &reply, QJSValue callback);    

signals:
    void openUrl(const QUrl &url);
    void granted();

    void testSignal(QNetworkReply *reply, QByteArray *data);

public slots:
    void authError(const QString &error, const QString &description, const QUrl &uri);
};

#endif // SPOTIFYWRAPPER_H
