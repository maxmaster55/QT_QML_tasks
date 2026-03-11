#include "wificontroller.h"
#include <QDebug>

namespace NM
{
    constexpr const char *NM_SERVICE = "org.freedesktop.NetworkManager";
    constexpr const char *NM_PATH = "/org/freedesktop/NetworkManager";
    constexpr const char *NM_INTERFACE = "org.freedesktop.NetworkManager";
    constexpr const char *PROP_INTERFACE = "org.freedesktop.DBus.Properties";
    constexpr const char *DEVICE_INTERFACE = "org.freedesktop.NetworkManager.Device";
    constexpr const char *WIFI_DEVICE_INTERFACE = "org.freedesktop.NetworkManager.Device.Wireless";
    constexpr const char *AP_INTERFACE = "org.freedesktop.NetworkManager.AccessPoint";
    constexpr const char *WIRELESS_ENABLED = "WirelessEnabled";
    constexpr const char *PROP_CHANGED = "PropertiesChanged";
    constexpr const char *WIFI_NETWORK_ADDED = "AccessPointAdded";
    constexpr const char *WIFI_NETWORK_REMOVED = "AccessPointRemoved";
    constexpr const char *FUNC_GET_ALL_DEVICES = "GetAllDevices";
    constexpr const char *DEVICE_TYPE = "DeviceType";
    constexpr const char *FUNC_REQ_SCAN = "RequestScan";
}

WifiController::WifiController(QObject *parent)
    : QObject{parent}, m_bus{QDBusConnection::systemBus()}
{
    if (!m_bus.isConnected())
    {
        qDebug() << "Cannot connect to system bus";
    }

    m_nm = new QDBusInterface(
        NM::NM_SERVICE,
        NM::NM_PATH,
        NM::NM_INTERFACE,
        m_bus);

    if (!m_nm->isValid())
    {
        qDebug() << "NetworkManager interface invalid";
    }

    m_wifiEnabled = m_nm->property(NM::WIRELESS_ENABLED).toBool();
    m_wifiDevicePath = getWirelessDevice();

    QTimer::singleShot(
        0,
        this,
        [this]()
        {
        emit wifiEnabledChanged(m_wifiEnabled);
        qDebug() << "wifi on startup is: " << m_wifiEnabled; });

    m_bus.connect(NM::NM_SERVICE, NM::NM_PATH,
                  NM::PROP_INTERFACE,
                  NM::PROP_CHANGED,
                  this,
                  SLOT(onPropertiesChanged(QString, QVariantMap, QStringList)));

    m_bus.connect(NM::NM_SERVICE, m_wifiDevicePath,
                  NM::WIFI_DEVICE_INTERFACE,
                  NM::WIFI_NETWORK_ADDED,
                  this,
                  SLOT(onAccessPointAdded(QDBusObjectPath)));

    m_bus.connect(NM::NM_SERVICE, m_wifiDevicePath, NM::WIFI_DEVICE_INTERFACE,
                  NM::WIFI_NETWORK_REMOVED,
                  this,
                  SLOT(onAccessPointRemoved(QDBusObjectPath)));
}

void WifiController::onPropertiesChanged(QString interface,
                                         QVariantMap changed,
                                         QStringList invalidated)
{
    Q_UNUSED(interface)
    Q_UNUSED(invalidated)

    if (changed.contains(NM::WIRELESS_ENABLED))
    {
        bool enabled = changed[NM::WIRELESS_ENABLED].toBool();
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

    m_nm->setProperty(NM::WIRELESS_ENABLED, enabled);
}

void WifiController::connectToNetwork(const QString &ssid, const QString &password)
{
}

void WifiController::scanNetworks()
{
    QDBusInterface wireless(
        NM::NM_SERVICE,
        m_wifiDevicePath,
        NM::WIFI_DEVICE_INTERFACE,
        m_bus);

    wireless.call(NM::FUNC_REQ_SCAN, QVariantMap());

    emit networksChanged();
}

QString WifiController::getWirelessDevice()
{
    QDBusReply<QList<QDBusObjectPath>> msg = m_nm->call(NM::FUNC_GET_ALL_DEVICES);
    if (!msg.isValid())
    {
        exit(1);
    }

    for (const QDBusObjectPath &path : msg.value())
    {
        QDBusInterface device(
            NM::NM_SERVICE,
            path.path(),
            NM::DEVICE_INTERFACE,
            m_bus);

        if (device.property(NM::DEVICE_TYPE).toUInt() == 2)
        {
            return path.path();
        }
    }

    return "";
}

void WifiController::onAccessPointAdded(QDBusObjectPath path)
{
    const QString apPath = path.path();
    qDebug() << "access point added:" << apPath;

    QVariantMap info = getAccessPointInfo(apPath);
    if (!info.isEmpty())
    {
        m_apCache.insert(apPath, info);
        rebuildNetworksList();
    }
}

void WifiController::onAccessPointRemoved(QDBusObjectPath path)
{
    const QString apPath = path.path();
    qDebug() << "access point removed:" << apPath;

    if (m_apCache.remove(apPath) > 0)
        rebuildNetworksList();
}

QVariantMap WifiController::getAccessPointInfo(const QString &apPath)
{
    QDBusInterface ap(
        NM::NM_SERVICE,
        apPath,
        NM::AP_INTERFACE,
        m_bus);

    if (!ap.isValid())
        return {};

    // SSID comes as a byte array — convert to QString
    QByteArray ssidBytes = ap.property("Ssid").toByteArray();
    QString ssid = QString::fromUtf8(ssidBytes);

    uint strength = ap.property("Strength").toUInt();
    uint frequency = ap.property("Frequency").toUInt();
    uint rsnFlags = ap.property("RsnFlags").toUInt();
    uint wpaFlags = ap.property("WpaFlags").toUInt();

    bool secured = (rsnFlags != 0 || wpaFlags != 0);

    return QVariantMap{
        {"name", ssid},
        {"strength", strength},
        {"frequency", frequency},
        {"is_secured", secured},
        {"path", apPath}};
}

void WifiController::rebuildNetworksList()
{
    m_networks.clear();
    for (const QVariantMap &info : m_apCache)
    {
        // Skip APs with empty SSID (hidden networks)
        if (!info["name"].toString().isEmpty())
            m_networks.append(info);
    }
    emit networksChanged();
}
