#include "sqlmodel.h"
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>

static int connections = 0;

QSqlDatabase initializeDatabase() {
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "MyConnection" + connections++);
    db.setDatabaseName("tagify.db");
    return db;
}

SqlModel::SqlModel(QObject *parent) : QSqlRelationalTableModel(parent, initializeDatabase()) {
}


void SqlModel::applyRoles() {
    _sqlRoles.clear();

    for (int i = 0; i < this->columnCount(); i++) {
        QString role = this->headerData(i, Qt::Horizontal).toString();
        if (_roles.contains(role)) {
            _sqlRoles[Qt::UserRole + i + 1] = QVariant(role).toByteArray();
        }
    }

#if QT_VERSION < 0x050000
    setRoleNames(_sqlRoles);
#endif
    select();
}

void SqlModel::setRoles(const QStringList &roles) {
    _roles = roles;

    if (database().open()) {
        applyRoles();
        database().close();
    }

    emit rolesChanged();
}

void SqlModel::setFilterString(const QString &filter) {
    if (database().open()) {
        setSort(1, Qt::AscendingOrder);
        setFilter(filter);
        applyRoles();
        database().close();

        emit filterStringChanged();
    }
}

void SqlModel::setTableName(const QString &table) {
    if (database().open()) {
        clear();
        setTable(table);
        select();
        database().close();

        emit tableChanged();
    }
}

QVariant SqlModel::data(const QModelIndex &index, int role) const {
    QVariant value;
    if(role < Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
