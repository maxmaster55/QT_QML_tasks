#ifndef CALC_H
#define CALC_H

#include <QObject>
#include <QDebug>

class calc : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString display MEMBER m_display NOTIFY displayChanged)
    Q_PROPERTY(QString expression MEMBER m_expression NOTIFY expressionChanged)

public:
    explicit calc(QObject *parent = nullptr);

    Q_INVOKABLE void input(const QString &value);
    Q_INVOKABLE void setOperation(const QString &op);
    Q_INVOKABLE void equals();
    Q_INVOKABLE void clear();
    Q_INVOKABLE void toggleSign();
    Q_INVOKABLE void percent();
    Q_INVOKABLE void decimal();

signals:
    void displayChanged();
    void expressionChanged();

private:
    QString m_display = "0";
    QString m_expression = "";

    double m_firstOperand = 0.0;
    QString m_pendingOperator = "";

    bool m_waitingForSecond = false;
};

#endif // CALC_H
