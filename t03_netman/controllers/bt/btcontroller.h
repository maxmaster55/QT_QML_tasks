#ifndef BTCONTROLLER_H
#define BTCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QtQml/qqml.h>
#include "QtDBus/QtDBus"

class BtController : public QObject
{
    Q_OBJECT
    QML_ELEMENT

private:
    QDBusConnection m_bus;
    QDBusInterface *adapter;

public:
    explicit BtController(QObject *parent = nullptr);

private:
signals:

private slots:
};

#endif // BTCONTROLLER_H
