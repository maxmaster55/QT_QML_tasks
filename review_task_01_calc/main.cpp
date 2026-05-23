#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <calc.h>

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

    calc calc;

    engine.rootContext()->setContextProperty("backend", &calc);

    engine.loadFromModule("t02_calc", "Main");

    return app.exec();
}
