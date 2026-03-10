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
    Q_PROPERTY(bool wifiEnabled READ wifiEnabled WRITE setWifiEnabled NOTIFY wifiEnabledChanged)

private:
    QDBusConnection m_bus;
    QDBusInterface *m_nm;
    bool m_wifiEnabled = false;

public:
    explicit WifiController(QObject *parent = nullptr);
    bool wifiEnabled() const;
    void setWifiEnabled(bool enabled);

    Q_INVOKABLE void connectToNetwork(const QString &ssid, const QString &password);
    Q_INVOKABLE void scanNetworks();

signals:
    void wifiEnabledChanged(bool enabled);

private slots:
    void onPropertiesChanged(QString interface, QVariantMap changed, QStringList invalidated);
};

#endif // WIFICONTROLLER_H
