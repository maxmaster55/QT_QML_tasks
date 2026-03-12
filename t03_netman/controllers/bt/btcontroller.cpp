#include "btcontroller.h"
#include <QDebug>
#include <algorithm>

namespace BLUEZ
{
    constexpr const char *SERVICE = "org.bluez";
    constexpr const char *PATH = "/org/bluez/hci0";
    constexpr const char *INTERFACE = "org.bluez.Adapter1";
    constexpr const char *PROP_INTERFACE = "org.freedesktop.DBus.Properties";
    constexpr const char *OBJ_MANAGER_IFACE = "org.freedesktop.DBus.ObjectManager";
    constexpr const char *DEVICE_IFACE = "org.bluez.Device1";
    constexpr const char *ENABLED = "Powered";
    constexpr const char *DISCOVERING = "Discovering";
    constexpr const char *PROPS_CHANGED = "PropertiesChanged";
    constexpr const char *IFACES_ADDED = "InterfacesAdded";
    constexpr const char *IFACES_REMOVED = "InterfacesRemoved";
}

BtController::BtController(QObject *parent)
    : QObject{parent}, m_bus{QDBusConnection::systemBus()}
{
    qDBusRegisterMetaType<InterfaceMap>();
    qDBusRegisterMetaType<ManagedObjectMap>();

    if (!m_bus.isConnected())
        qDebug() << "Cannot connect to system bus";

    m_adapter = new QDBusInterface(BLUEZ::SERVICE, BLUEZ::PATH, BLUEZ::INTERFACE, m_bus);
    if (!m_adapter->isValid())
        qDebug() << "Cannot connect to Bluez adapter interface";

    m_btEnabled = m_adapter->property(BLUEZ::ENABLED).toBool();

    QTimer::singleShot(0, this, [this]()
                       {
        emit btEnabledChanged(m_btEnabled);
        qDebug() << "bt on startup is: " << m_btEnabled; });

    // Adapter property changes (Powered, Discovering, etc.)
    m_bus.connect(BLUEZ::SERVICE, BLUEZ::PATH,
                  BLUEZ::PROP_INTERFACE,
                  BLUEZ::PROPS_CHANGED,
                  this,
                  SLOT(onPropertiesChanged(QString, QVariantMap, QStringList)));

    // New device discovered during scan
    m_bus.connect(BLUEZ::SERVICE, "/",
                  BLUEZ::OBJ_MANAGER_IFACE,
                  BLUEZ::IFACES_ADDED,
                  this,
                  SLOT(onInterfacesAdded(QDBusObjectPath, InterfaceMap)));

    // Device removed
    m_bus.connect(BLUEZ::SERVICE, "/",
                  BLUEZ::OBJ_MANAGER_IFACE,
                  BLUEZ::IFACES_REMOVED,
                  this,
                  SLOT(onInterfacesRemoved(QDBusObjectPath, QStringList)));

    if (m_btEnabled)
    {
        scanDevices();
    }
}

void BtController::setBtEnabled(bool enabled)
{
    qDebug() << "setBtEnabled called with:" << enabled;
    if (!m_adapter->isValid())
        return;
    m_adapter->setProperty(BLUEZ::ENABLED, enabled);
}

void BtController::scanDevices()
{
    if (!m_adapter->isValid())
        return;

    if (m_scanning)
    {
        qDebug() << "Stopping discovery";
        m_adapter->call("StopDiscovery");
        m_scanning = false;
        emit scanningChanged(m_scanning);
        return;
    }

    // Load already-known devices first
    QDBusInterface manager(BLUEZ::SERVICE, "/", BLUEZ::OBJ_MANAGER_IFACE, m_bus);
    QDBusReply<ManagedObjectMap> reply = manager.call("GetManagedObjects");

    if (reply.isValid())
    {
        const ManagedObjectMap objects = reply.value();
        for (auto it = objects.begin(); it != objects.end(); ++it)
        {
            if (it.value().contains(BLUEZ::DEVICE_IFACE))
                addOrUpdateDevice(it.value()[BLUEZ::DEVICE_IFACE]);
        }
    }

    qDebug() << "Starting discovery";
    QDBusReply<void> startReply = m_adapter->call("StartDiscovery");
    if (!startReply.isValid())
    {
        qWarning() << "StartDiscovery failed:" << startReply.error().message();
        return;
    }

    m_scanning = true;
    emit scanningChanged(m_scanning);
}

void BtController::pairWithDevice(const QString mac_addr)
{
    QString path = macToPath(mac_addr);
    QDBusInterface device(BLUEZ::SERVICE, path, BLUEZ::DEVICE_IFACE, m_bus);

    if (!device.isValid())
    {
        qWarning() << "Invalid device path:" << path;
        return;
    }

    QDBusReply<void> reply = device.call("Pair");
    if (!reply.isValid())
        qWarning() << "Pair failed:" << reply.error().message();
    else
        qDebug() << "Pairing initiated with" << mac_addr;
}

void BtController::connect(const QString mac_addr)
{
    QString path = macToPath(mac_addr);
    QDBusInterface device(BLUEZ::SERVICE, path, BLUEZ::DEVICE_IFACE, m_bus);

    if (!device.isValid())
    {
        qWarning() << "Invalid device path:" << path;
        return;
    }

    QDBusReply<void> reply = device.call("Connect");
    if (!reply.isValid())
        qWarning() << "Connect failed:" << reply.error().message();
    else
        qDebug() << "Connected to" << mac_addr;
}

void BtController::disconnect(const QString mac_addr)
{
    QString path = macToPath(mac_addr);
    QDBusInterface device(BLUEZ::SERVICE, path, BLUEZ::DEVICE_IFACE, m_bus);

    if (!device.isValid())
    {
        qWarning() << "Invalid device path:" << path;
        return;
    }

    QDBusReply<void> reply = device.call("Disconnect");
    if (!reply.isValid())
        qWarning() << "Disconnect failed:" << reply.error().message();
    else
        qDebug() << "Disconnected from" << mac_addr;
}

// --- Private slots ---

void BtController::onPropertiesChanged(QString interface,
                                       QVariantMap changed,
                                       QStringList invalidated)
{
    Q_UNUSED(interface)
    Q_UNUSED(invalidated)

    if (changed.contains(BLUEZ::ENABLED))
    {
        bool enabled = changed[BLUEZ::ENABLED].toBool();
        if (m_btEnabled != enabled)
        {
            m_btEnabled = enabled;
            qDebug() << "bt changed from system to:" << m_btEnabled;
            emit btEnabledChanged(m_btEnabled);

            if (!m_btEnabled)
            {
                m_devices.clear();
                emit devicesChanged();
            }
        }
    }

    if (changed.contains(BLUEZ::DISCOVERING))
    {
        bool discovering = changed[BLUEZ::DISCOVERING].toBool();
        if (m_scanning != discovering)
        {
            m_scanning = discovering;
            emit scanningChanged(m_scanning);
        }
    }
}

void BtController::onInterfacesAdded(const QDBusObjectPath &path,
                                     const InterfaceMap &interfaces)
{
    Q_UNUSED(path)
    if (!interfaces.contains(BLUEZ::DEVICE_IFACE))
        return;

    addOrUpdateDevice(interfaces[BLUEZ::DEVICE_IFACE]);
}

void BtController::onInterfacesRemoved(const QDBusObjectPath &path,
                                       const QStringList &interfaces)
{
    if (!interfaces.contains(BLUEZ::DEVICE_IFACE))
        return;

    // Extract MAC from path e.g. /org/bluez/hci0/dev_AA_BB_CC_DD_EE_FF
    QString pathStr = path.path();
    QString devPart = pathStr.section('/', -1); // "dev_AA_BB_CC_DD_EE_FF"
    QString mac = devPart.mid(4).replace('_', ':').toUpper();

    // Remove from list
    auto it = std::remove_if(m_devices.begin(), m_devices.end(),
                             [&mac](const QVariant &v)
                             {
                                 return v.toMap().value("address").toString() == mac;
                             });

    if (it != m_devices.end())
    {
        m_devices.erase(it, m_devices.end());
        emit devicesChanged();
    }
}

// --- Helpers ---

void BtController::addOrUpdateDevice(const QVariantMap &props)
{
    QString address = props.value("Address").toString();
    if (address.isEmpty())
        return;

    QString name = props.value("Name").toString();
    if (name.isEmpty())
        return;

    QVariantMap device;
    device["address"] = address;
    device["name"] = props.value("Name", "Unknown").toString();
    device["paired"] = props.value("Paired", false).toBool();
    device["connected"] = props.value("Connected", false).toBool();
    device["rssi"] = props.value("RSSI", 0).toInt();

    // Update if exists, otherwise append
    for (int i = 0; i < m_devices.size(); ++i)
    {
        if (m_devices[i].toMap().value("address") == address)
        {
            m_devices[i] = device;
            emit devicesChanged();
            return;
        }
    }

    m_devices.append(device);
    emit devicesChanged();
    qDebug() << "Device found:" << device["name"] << address;
}

QString BtController::macToPath(const QString &mac)
{
    // AA:BB:CC:DD:EE:FF  ->  /org/bluez/hci0/dev_AA_BB_CC_DD_EE_FF
    QString formatted = mac;
    formatted.replace(':', '_');
    formatted = formatted.toUpper();
    return QString("%1/dev_%2").arg(BLUEZ::PATH, formatted);
}