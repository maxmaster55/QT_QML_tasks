#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <systeminfo.h>


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

    qmlRegisterSingletonInstance("Backend", 1, 0, "SystemInfo", new SystemInfo);
    engine.loadFromModule("t01_gallery", "Splash");

    return app.exec();
}
