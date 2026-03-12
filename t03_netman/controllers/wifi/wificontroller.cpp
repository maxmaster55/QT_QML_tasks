#include "wificontroller.h"
#include <QDebug>
#include <algorithm>

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
    constexpr const char *LAST_SCAN = "LastScan";
    constexpr const char *FUNC_REQ_SCAN = "RequestScan";
    constexpr const char *FUNC_GET_APS = "GetAccessPoints";
    constexpr const char *SETTINGS_SERVICE = "org.freedesktop.NetworkManager";
    constexpr const char *SETTINGS_PATH = "/org/freedesktop/NetworkManager/Settings";
    constexpr const char *SETTINGS_INTERFACE = "org.freedesktop.NetworkManager.Settings";
    constexpr const char *CONN_INTERFACE = "org.freedesktop.NetworkManager.Settings.Connection";
    constexpr const char *FUNC_LIST_CONNS = "ListConnections";
    constexpr const char *FUNC_GET_SETTINGS = "GetSettings";
    constexpr const char *FUNC_ACTIVATE_CONN = "ActivateConnection";
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
    m_bus.connect(NM::NM_SERVICE, m_wifiDevicePath,
                  NM::PROP_INTERFACE,
                  NM::PROP_CHANGED,
                  this,
                  SLOT(onDevicePropertiesChanged(QString, QVariantMap, QStringList)));

    if (m_wifiEnabled)
    {
        loadInitialAccessPoints();
        scanNetworks();
    }
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
            qDebug() << "wifi changed from system to: " << m_wifiEnabled;
            emit wifiEnabledChanged(m_wifiEnabled);
        }
    }
}
void WifiController::onDevicePropertiesChanged(QString interface,
                                               QVariantMap changed,
                                               QStringList invalidated)
{
    Q_UNUSED(invalidated)

    if (interface != NM::WIFI_DEVICE_INTERFACE)
        return;

    if (changed.contains(NM::LAST_SCAN))
    {
        m_scanning = false;
        emit scanningChanged(false);

        qDebug() << "scan finished";
    }
}

void WifiController::setWifiEnabled(bool enabled)
{
    qDebug() << "wifi enabled called with: " << m_wifiEnabled;
    if (!m_nm->isValid())
        return;

    m_nm->setProperty(NM::WIRELESS_ENABLED, enabled);
}

void WifiController::scanNetworks()
{
    QDBusInterface wireless(
        NM::NM_SERVICE,
        m_wifiDevicePath,
        NM::WIFI_DEVICE_INTERFACE,
        m_bus);
    m_scanning = true;
    emit scanningChanged(true);

    wireless.call(NM::FUNC_REQ_SCAN, QVariantMap());
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
        if (!info["name"].toString().isEmpty())
            m_networks.append(info);
    }

    std::sort(m_networks.begin(), m_networks.end(),
              [](const QVariant &a, const QVariant &b)
              {
                  int strengthA = a.toMap()["strength"].toInt();
                  int strengthB = b.toMap()["strength"].toInt();

                  return strengthA > strengthB; // descending (strongest first)
              });

    emit networksChanged();
}

void WifiController::loadInitialAccessPoints()
{
    QDBusInterface wireless(
        NM::NM_SERVICE,
        m_wifiDevicePath,
        NM::WIFI_DEVICE_INTERFACE,
        m_bus);

    QDBusReply<QList<QDBusObjectPath>> reply =
        wireless.call(NM::FUNC_GET_APS);

    if (!reply.isValid())
    {
        qDebug() << "Failed to get access points";
        return;
    }

    for (const QDBusObjectPath &path : reply.value())
    {
        QString apPath = path.path();

        QVariantMap info = getAccessPointInfo(apPath);
        if (!info.isEmpty())
            m_apCache.insert(apPath, info);
    }

    rebuildNetworksList();
}

void WifiController::connectToNetwork(const QString &ssid, const QString &password)
{
    // Find the AP path from cache by SSID
    QString apPath;
    for (auto it = m_apCache.begin(); it != m_apCache.end(); ++it)
    {
        if (it.value()["name"].toString() == ssid)
        {
            apPath = it.value()["path"].toString();
            break;
        }
    }

    if (apPath.isEmpty())
    {
        qWarning() << "Could not find AP path for SSID:" << ssid;
        return;
    }

    // ✅ Check if a saved connection already exists for this SSID
    QString existingConnPath = findSavedConnection(ssid);

    if (!existingConnPath.isEmpty())
    {
        qDebug() << "Found existing connection for" << ssid << "— activating directly";

        QDBusReply<QDBusObjectPath> reply = m_nm->call(
            NM::FUNC_ACTIVATE_CONN,
            QVariant::fromValue(QDBusObjectPath(existingConnPath)),
            QVariant::fromValue(QDBusObjectPath(m_wifiDevicePath)),
            QVariant::fromValue(QDBusObjectPath("/")) // specific AP — let NM pick
        );

        if (!reply.isValid())
            qWarning() << "ActivateConnection failed:" << reply.error().message();
        else
            qDebug() << "Activating saved connection:" << reply.value().path();

        return;
    }

    // No saved connection — create a new one
    QMap<QString, QVariantMap> connectionSettings;

    connectionSettings["connection"] = {
        {"id", ssid},
        {"type", QString("802-11-wireless")}};

    connectionSettings["802-11-wireless"] = {
        {"ssid", ssid.toUtf8()},
        {"mode", QString("infrastructure")}};

    if (!password.isEmpty())
    {
        connectionSettings["802-11-wireless-security"] = {
            {"key-mgmt", QString("wpa-psk")},
            {"psk", password}};
    }

    connectionSettings["ipv4"] = {{"method", QString("auto")}};
    connectionSettings["ipv6"] = {{"method", QString("ignore")}};

    QVariantMap outerMap;
    for (auto it = connectionSettings.begin(); it != connectionSettings.end(); ++it)
        outerMap.insert(it.key(), QVariant::fromValue(it.value()));

    QDBusReply<QDBusObjectPath> reply = m_nm->call(
        "AddAndActivateConnection",
        QVariant::fromValue(outerMap),
        QVariant::fromValue(QDBusObjectPath(m_wifiDevicePath)),
        QVariant::fromValue(QDBusObjectPath(apPath)));

    if (!reply.isValid())
        qWarning() << "AddAndActivateConnection failed:" << reply.error().message();
    else
        qDebug() << "Connecting to" << ssid << "— active connection:" << reply.value().path();
}

QString WifiController::findSavedConnection(const QString &ssid)
{
    QDBusInterface settings(
        NM::SETTINGS_SERVICE,
        NM::SETTINGS_PATH,
        NM::SETTINGS_INTERFACE,
        m_bus);

    QDBusReply<QList<QDBusObjectPath>> reply = settings.call(NM::FUNC_LIST_CONNS);
    if (!reply.isValid())
    {
        qWarning() << "ListConnections failed:" << reply.error().message();
        return {};
    }

    for (const QDBusObjectPath &connPath : reply.value())
    {
        QDBusInterface conn(
            NM::SETTINGS_SERVICE,
            connPath.path(),
            NM::CONN_INTERFACE,
            m_bus);

        QDBusReply<QMap<QString, QVariantMap>> settingsReply = conn.call(NM::FUNC_GET_SETTINGS);
        if (!settingsReply.isValid())
            continue;

        QMap<QString, QVariantMap> connSettings = settingsReply.value();

        // Check the 802-11-wireless section for matching SSID
        if (connSettings.contains("802-11-wireless"))
        {
            QByteArray savedSsid = connSettings["802-11-wireless"].value("ssid").toByteArray();
            if (QString::fromUtf8(savedSsid) == ssid)
                return connPath.path();
        }
    }

    return {};
}