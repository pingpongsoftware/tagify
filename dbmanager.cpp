#include "dbmanager.h"
#include <QDebug>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlResult>
#include <QSqlRecord>

DBManager::DBManager(QObject *parent) : QObject(parent) {
    _database = QSqlDatabase::addDatabase("QSQLITE", "");
    _database.setDatabaseName("tagify.db");
    if (_database.open()) {
        if (_database.tables().contains("songs") && _database.tables().contains("albums") && _database.tables().contains("artists") && _database.tables().contains("tags")) {
            _alreadyExists = true;
        }

        QSqlQuery query(_database);
        query.exec("CREATE TABLE songs(songId VARCHAR PRIMARY KEY, songName VARCHAR, albumId VARCHAR, albumName VARCHAR, artistId VARCHAR, artistName VARCHAR, tags VARCHAR)");
        query.exec("CREATE TABLE albums(albumId VARCHAR PRIMARY KEY, albumName VARCHAR, artUrl VARCHAR, artistId VARCHAR, artistName VARCHAR)");
        query.exec("CREATE TABLE artists(artistId VARCHAR PRIMARY KEY, artistName VARCHAR, artistImage VARCHAR)");
        query.exec("CREATE TABLE tags(tagName VARCHAR PRIMARY KEY)");
        _database.close();
    }
}

void DBManager::addSong(const QString &songId, const QString &songName, const QString &albumId, const QString &albumName, const QString &artistId, const QString &artistName, const QString &tags) {
    if (_database.open()) {
        QSqlQuery query(_database);
        query.prepare("INSERT OR REPLACE INTO songs (songId, songName, albumId, albumName, artistId, artistName, tags) VALUES (:songId, :name, :albumId, :albumName, :artistId, :artistName, :tags)");
        query.bindValue(":songId", songId);
        query.bindValue(":name", songName);
        query.bindValue(":albumId", albumId);
        query.bindValue(":albumName", albumName);
        query.bindValue(":artistId", artistId);
        query.bindValue(":artistName", artistName);
        query.bindValue(":tags", tags);
        query.exec();
        _database.close();
    }
}

void DBManager::addAlbum(const QString &albumId, const QString &albumName, const QString &albumArtUrl, const QString &artistId, const QString &artistName) {
    if (_database.open()) {
        QSqlQuery query(_database);
        query.prepare("INSERT OR REPLACE INTO albums(albumId, albumName, artUrl, artistId, artistName) VALUES (:albumId, :albumName, :artUrl, :artistId, :artistName)");
        query.bindValue(":albumId", albumId);
        query.bindValue(":albumName", albumName);
        query.bindValue(":artUrl", albumArtUrl);
        query.bindValue(":artistId", artistId);
        query.bindValue(":artistName", artistName);
        query.exec();
        _database.close();
    }
}

void DBManager::addArtist(const QString &artistId, const QString &artistName, const QString &artistImage) {
    if (_database.open()) {
        QSqlQuery query(_database);
        query.prepare("INSERT OR REPLACE INTO artists(artistId, artistName, artistImage) VALUES (:artistId, :artistName, :artistImage)");
        query.bindValue(":artistId", artistId);
        query.bindValue(":artistName", artistName);
        query.bindValue(":artistImage", artistImage);
        query.exec();
        _database.close();
    }
}

bool DBManager::addTag(const QString &spotifyId, const QString &newTag) {
    bool success = false;

    if (_database.open() && spotifyId.length() > 0 && newTag.length() > 0) {
        QSqlQuery query(_database);

        query.prepare("INSERT INTO tags(tagName) VALUES(:tagName)");
        query.bindValue(":tagName", newTag);
        query.exec();
        query.clear();

        if (query.exec("SELECT tags FROM songs WHERE songId=\"" + spotifyId + "\"") && query.next()) {
            QString tagString = query.value(0).toString();
            QStringList tags = tagString.split(_TAG_SEPARATOR);
            bool exists = false;

            for (QString tag : tags) {
                if (newTag == tag) {
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                tagString += (tagString.length() > 0 ? QString(_TAG_SEPARATOR) : "") + newTag;
                query.clear();
                query.exec("UPDATE songs SET tags=\"" + tagString + "\" WHERE songId=\"" + spotifyId + "\"");
                query.clear();
            }

        } else {
            qDebug() << "Error selecting tags";
            qDebug() << query.lastError();
        }

        _database.close();
    }

    return success;
}

bool DBManager::addAlbumTag(const QString &albumId, const QString &newTag) {
    bool success = false;

    if (_database.open() && albumId.length() > 0 && newTag.length() > 0) {
        QSqlQuery query(_database);

        query.prepare("INSERT INTO tags(tagName) VALUES(:tagName)");
        query.bindValue(":tagName", newTag);
        query.exec();
        query.clear();

        if (query.exec("SELECT tags FROM songs WHERE albumId=\"" + albumId + "\"") && query.next()) {
            QString tagString = query.value(0).toString();
            QStringList tags = tagString.split(_TAG_SEPARATOR);
            bool exists = false;

            for (QString tag : tags) {
                if (newTag == tag) {
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                tagString += (tagString.length() > 0 ? QString(_TAG_SEPARATOR) : "") + newTag;
                query.clear();
                query.exec("UPDATE songs SET tags=\"" + tagString + "\" WHERE albumId=\"" + albumId + "\"");
                query.clear();
            }

        } else {
            qDebug() << "Error selecting tags";
            qDebug() << query.lastError();
        }

        _database.close();
    }

    return success;
}
