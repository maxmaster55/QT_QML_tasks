#include "wificontroller.h"
#include <QDebug>

QString NM_SERVICE = "org.freedesktop.NetworkManager";
QString NM_PATH = "/org/freedesktop/NetworkManager";
QString NM_INTERFACE = "org.freedesktop.NetworkManager";
QString NM_PROP_INTERFACE = "org.freedesktop.DBus.Properties";

QString NM_WIRELESS_ENABLED = "WirelessEnabled";

WifiController::WifiController(QObject *parent)
    : QObject{parent}, m_bus{QDBusConnection::systemBus()}
{
    if (!m_bus.isConnected())
    {
        qDebug() << "Cannot connect to system bus";
    }

    m_nm = new QDBusInterface(
        NM_SERVICE,
        NM_PATH,
        NM_INTERFACE,
        QDBusConnection::systemBus());

    if (!m_nm->isValid())
    {
        qDebug() << "NetworkManager interface invalid";
    }

    m_wifiEnabled = m_nm->property("WirelessEnabled").toBool();
    QTimer::singleShot(0, this, [this]()
                       {
        emit wifiEnabledChanged(m_wifiEnabled);
        qDebug() << "wifi on startup is: " << m_wifiEnabled; });

    m_bus.connect(
        NM_SERVICE,
        NM_PATH,
        NM_PROP_INTERFACE,
        "PropertiesChanged",
        this,
        SLOT(onPropertiesChanged(QString, QVariantMap, QStringList)));
}

void WifiController::onPropertiesChanged(QString interface,
                                         QVariantMap changed,
                                         QStringList invalidated)
{
    Q_UNUSED(interface)
    Q_UNUSED(invalidated)

    if (changed.contains(NM_WIRELESS_ENABLED))
    {
        bool enabled = changed[NM_WIRELESS_ENABLED].toBool();
        if (m_wifiEnabled != enabled)
        {
            m_wifiEnabled = enabled;
            emit wifiEnabledChanged(m_wifiEnabled);
            qDebug() << "wifi changed from system to: " << m_wifiEnabled;
        }
    }
}

void WifiController::setWifiEnabled(bool enabled)
{
    qDebug() << "wifi enabled called with: " << m_wifiEnabled;
    if (!m_nm->isValid())
        return;

    m_nm->setProperty("WirelessEnabled", enabled);
}

void WifiController::connectToNetwork(const QString &ssid, const QString &password)
{
}

void WifiController::scanNetworks()
{

    qDebug() << "Scan called from qml";
    m_networks.clear();

    QVariantMap net;

    net["name"] = "HomeWifi";
    net["strength"] = 80;
    net["is_secured"] = true;
    m_networks.append(net);

    net["name"] = "CoffeeShop";
    net["strength"] = 55;
    net["is_secured"] = false;
    m_networks.append(net);

    emit networksChanged();
}
