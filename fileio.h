#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject *parent = nullptr);

    Q_INVOKABLE QString read(const QString &fileName);
    Q_INVOKABLE bool write(const QString &fileName, const QString &data);
    Q_INVOKABLE bool exists(const QString &fileName);

signals:

public slots:
};

#endif // FILEIO_H
