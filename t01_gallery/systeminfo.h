#ifndef SYSTEMINFO_H
#define SYSTEMINFO_H

#include <QObject>
#include <QFile>

class SystemInfo: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString temperature();
};

#endif // SYSTEMINFO_H
