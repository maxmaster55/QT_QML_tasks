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
    Q_PROPERTY(QVariantList networks MEMBER m_networks NOTIFY networksChanged)

private:
    QDBusConnection m_bus;
    QDBusInterface *m_nm;
    bool m_wifiEnabled = false;
    QVariantList m_networks;

public:
    explicit WifiController(QObject *parent = nullptr);
    void setWifiEnabled(bool enabled);

    Q_INVOKABLE void connectToNetwork(const QString &ssid, const QString &password);
    Q_INVOKABLE void scanNetworks();

signals:
    void wifiEnabledChanged(bool enabled);
    void networksChanged();

private slots:
    void onPropertiesChanged(QString interface, QVariantMap changed, QStringList invalidated);
};

#endif // WIFICONTROLLER_H
