#include "calc.h"

calc::calc(QObject *parent)
    : QObject(parent)
{
}

void calc::input(const QString &value)
{
    if (m_waitingForSecond) {
        m_display = value;
        m_waitingForSecond = false;
    } else {
        m_display = (m_display == "0")
        ? value
        : m_display + value;
    }

    emit displayChanged();
}

void calc::setOperation(const QString &op)
{
    m_firstOperand = m_display.toDouble();
    m_pendingOperator = op;

    m_expression = m_display + " " + op;
    m_waitingForSecond = true;

    emit expressionChanged();
}

void calc::equals()
{
    if (m_pendingOperator.isEmpty())
        return;

    double second = m_display.toDouble();

    double result = 0;

    m_expression += " " + m_display + " =";

    emit expressionChanged();

    if (m_pendingOperator == "+") {
        result = m_firstOperand + second;
    }
    else if (m_pendingOperator == "-") {
        result = m_firstOperand - second;
    }
    else if (m_pendingOperator == "X") {
        result = m_firstOperand * second;
    }
    else if (m_pendingOperator == "÷") {

        if (second == 0) {

            m_display = "Error";

            emit displayChanged();

            m_pendingOperator.clear();

            m_waitingForSecond = true;

            return;
        }

        result = m_firstOperand / second;
    }

    m_display = QString::number(result);

    m_pendingOperator.clear();

    m_waitingForSecond = true;

    emit displayChanged();
}

void calc::clear()
{
    m_display = "0";

    m_expression.clear();

    m_firstOperand = 0.0;

    m_pendingOperator.clear();

    m_waitingForSecond = false;

    emit displayChanged();

    emit expressionChanged();
}

void calc::toggleSign()
{
    m_display = QString::number(m_display.toDouble() * -1);

    emit displayChanged();
}

void calc::percent()
{
    m_display = QString::number(m_display.toDouble() / 100.0);

    emit displayChanged();
}

void calc::decimal()
{
    if (!m_display.contains('.')) {

        m_display += ".";

        emit displayChanged();
    }
}
