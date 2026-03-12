#ifndef BTCONTROLLER_H
#define BTCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QtQml/qqml.h>
#include "QtDBus/QtDBus"

using InterfaceMap = QMap<QString, QVariantMap>;
using ManagedObjectMap = QMap<QDBusObjectPath, InterfaceMap>;

Q_DECLARE_METATYPE(InterfaceMap)
Q_DECLARE_METATYPE(ManagedObjectMap)

class BtController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool btEnabled MEMBER m_btEnabled WRITE setBtEnabled NOTIFY btEnabledChanged)
    Q_PROPERTY(bool scanning MEMBER m_scanning WRITE setScanning NOTIFY scanningChanged)
    Q_PROPERTY(QVariantList devices MEMBER m_devices NOTIFY devicesChanged)
private:
    bool m_btEnabled = false;
    bool m_scanning = false;
    QDBusConnection m_bus;
    QDBusInterface *m_adapter;
    QVariantList m_devices;

public:
    explicit BtController(QObject *parent = nullptr);
    void setBtEnabled(bool enabled);
    void setScanning(bool enabled) { m_scanning = enabled; }

    Q_INVOKABLE void scanDevices();
    Q_INVOKABLE void pairWithDevice(const QString mac_addr);
    Q_INVOKABLE void connect(const QString mac_addr);
    Q_INVOKABLE void disconnect(const QString mac_addr);

private:
    void addOrUpdateDevice(const QVariantMap &props);
    QString macToPath(const QString &mac);

signals:
    void btEnabledChanged(bool enabled);
    void scanningChanged(bool enabled);
    void devicesChanged();

private slots:
    void onPropertiesChanged(QString interface, QVariantMap changed, QStringList invalidated);
    void onInterfacesAdded(const QDBusObjectPath &path, const InterfaceMap &interfaces);
    void onInterfacesRemoved(const QDBusObjectPath &path, const QStringList &interfaces);
};

#endif // BTCONTROLLER_H
