#include "systeminfo.h"

Q_INVOKABLE QString SystemInfo::temperature() {
    QFile file("/sys/class/thermal/thermal_zone1/temp");
    if (!file.open(QIODevice::ReadOnly))
        return "N/A";

    int temp = file.readAll().trimmed().toInt();
    return QString::number(temp / 1000.0, 'f', 1) + " °C";
}
