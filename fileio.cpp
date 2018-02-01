#include "fileio.h"
#include <QDebug>
#include <QFile>

FileIO::FileIO(QObject *parent) : QObject(parent) {

}

QString FileIO::read(const QString &fileName) {
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        QString data = in.readAll();
        file.close();
        return data;
    }
    file.close();
    return QString();
}

bool FileIO::write(const QString &fileName, const QString &data) {
    QFile file(fileName);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << data;
        file.close();
        return true;
    }
    file.close();
    return false;
}

bool FileIO::exists(const QString &fileName) {
    QFile file(fileName);
    return file.exists();
}
