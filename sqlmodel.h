#ifndef SQLMODEL_H
#define SQLMODEL_H

#include <QSqlRelationalTableModel>
#include <QtGlobal>
#include <QSqlQuery>

class SqlModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit SqlModel(QObject *parent = nullptr);

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(QStringList roles READ roles WRITE setRoles NOTIFY rolesChanged)
    Q_PROPERTY(QString table READ tableName WRITE setTableName NOTIFY tableChanged)
    Q_PROPERTY(QString filterString READ filterString WRITE setFilterString NOTIFY filterStringChanged)

    void applyRoles();
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const;
    Q_INVOKABLE void sortTable(const QString &roleName, const Qt::SortOrder sortOrder = Qt::AscendingOrder, const Qt::CaseSensitivity caseSensitivity = Qt::CaseInsensitive);

    void setRoles(const QStringList &roles);
    void setTableName(const QString &table);
    void setFilterString(const QString &filter);

    QStringList roles() const { return _roles; }
    QString filterString() const { return filter(); }
    QString orderByClause() const { return _orderByClause; }

#if QT_VERSION >= 0x050000
    virtual QHash<int, QByteArray> roleNames() const{return _sqlRoles;}
#endif

private:
    int count;
    QHash<int, QByteArray> _sqlRoles;
    QStringList _roles;
    QString _orderByClause;

signals:
    void countChanged();
    void rolesChanged();
    void tableChanged();
    void filterStringChanged();

public slots:
};

#endif // SQLMODEL_H
