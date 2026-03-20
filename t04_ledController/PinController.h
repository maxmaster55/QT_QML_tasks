// pincontroller.h
#ifndef PINCONTROLLER_H
#define PINCONTROLLER_H

#include <QObject>
#include <QtQml/qqml.h>
#include <mypin.h>

class PinController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(bool pinState READ pinState WRITE setPinState NOTIFY pinStateChanged)

private:
    bool m_pinState;
    mypin led_pin;

public:
    explicit PinController(QObject *parent = nullptr);
    bool pinState() const;
    void setPinState(bool state);

signals:
    void pinStateChanged();
};

#endif // PINCONTROLLER_H