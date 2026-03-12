#ifndef WIFICONTROLLER_H
#define WIFICONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QtQml/qqml.h>
#include "QtDBus/QtDBus"

class WifiController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool wifiEnabled MEMBER m_wifiEnabled WRITE setWifiEnabled NOTIFY wifiEnabledChanged)
    Q_PROPERTY(bool scanning MEMBER m_scanning WRITE setScanning NOTIFY scanningChanged)
    Q_PROPERTY(QVariantList networks MEMBER m_networks NOTIFY networksChanged)

private:
    QDBusConnection m_bus;
    QDBusInterface *m_nm;
    bool m_wifiEnabled = false;
    QVariantList m_networks;
    QString m_wifiDevicePath;
    bool m_scanning = false;
    QMap<QString, QVariantMap> m_apCache;

public:
    explicit WifiController(QObject *parent = nullptr);
    void setWifiEnabled(bool enabled);
    void setScanning(bool enabled) { m_scanning = enabled; }

    Q_INVOKABLE void connectToNetwork(const QString &ssid, const QString &password);
    Q_INVOKABLE void scanNetworks();

private:
    QString getWirelessDevice();
    QVariantMap getAccessPointInfo(const QString &apPath);
    void rebuildNetworksList();
    void loadInitialAccessPoints();

signals:
    void wifiEnabledChanged(bool enabled);
    void scanningChanged(bool scanning);
    void networksChanged();

private slots:
    void onPropertiesChanged(QString interface, QVariantMap changed, QStringList invalidated);
    void onDevicePropertiesChanged(QString interface, QVariantMap changed, QStringList invalidated);
    void onAccessPointAdded(QDBusObjectPath path);
    void onAccessPointRemoved(QDBusObjectPath path);
};

#endif // WIFICONTROLLER_H
