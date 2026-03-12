#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "controllers/wifi/wificontroller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("t03_netman", "Main");

    return app.exec();
}
