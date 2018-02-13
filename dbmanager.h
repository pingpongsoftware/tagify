#ifndef DBMANAGER_H
#define DBMANAGER_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>

class DBManager : public QObject
{
    Q_OBJECT
public:
    explicit DBManager(QObject *parent = nullptr);

    Q_PROPERTY(QChar TAG_SEPARATOR READ TAG_SEPARATOR CONSTANT)

    Q_INVOKABLE void addSong(const QString &songId, const QString &songName, const QString &albumId, const QString &albumName, const QString &artistId, const QString &artistName, const QString &tags);
    Q_INVOKABLE void addAlbum(const QString &albumId, const QString &albumName, const QString &albumArtUrl, const QString &artistId, const QString &artistName);
    Q_INVOKABLE void addArtist(const QString &artistId, const QString &artistName);

    Q_INVOKABLE bool addTag(const QString &spotifyId, const QString &newTag);
    Q_INVOKABLE bool addAlbumTag(const QString &albumId, const QString &newTag);

    QChar TAG_SEPARATOR() { return _TAG_SEPARATOR; }

private:
    QSqlDatabase _database;

    const QChar _TAG_SEPARATOR = '☯';

signals:

public slots:
};

#endif // DBMANAGER_H
