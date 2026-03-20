// PinController.cpp
#include "PinController.h"

PinController::PinController(QObject *parent)
    : QObject{parent}, m_pinState{false}
{
    led_pin = mypin(26, pin_mode_t::mode_write);
}

bool PinController::pinState() const
{
    return m_pinState;
}

void PinController::setPinState(bool state)
{
    if (m_pinState == state)
        return;

    led_pin << static_cast<int>(state);
    m_pinState = state;
    emit pinStateChanged();
}