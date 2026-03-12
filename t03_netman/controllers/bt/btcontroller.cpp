#include "btcontroller.h"
#include <QDebug>
#include <algorithm>

namespace BLUEZ
{
    constexpr const char *SERVICE = "org.bluez";
    constexpr const char *PATH = "/org/bluez/hci0";
    constexpr const char *INTERFACE = "org.bluez.Adapter1";

}

BtController::BtController(QObject *parent)
    : QObject{parent}, m_bus{QDBusConnection::systemBus()}
{
    if (!m_bus.isConnected())
    {
        qDebug() << "Cannot connect to system bus";
    }

    adapter = new QDBusInterface(BLUEZ::SERVICE, BLUEZ::PATH, BLUEZ::INTERFACE, m_bus);

    if (!adapter->isValid())
    {
        qDebug() << "Cannot connect to Bluez adapter interface";
    }
}
