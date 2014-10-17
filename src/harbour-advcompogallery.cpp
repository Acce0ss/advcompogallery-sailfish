#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QGuiApplication>
#include <QQuickView>
#include <QTranslator>
#include <QDebug>
#include <QDir>

#include <QtMultimedia/QCamera>

#include <QList>
#include <QStringList>
#include <QByteArray>

#include "cameraselector.h"

int main(int argc, char *argv[])
{
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QScopedPointer<QQuickView> viewer(SailfishApp::createView());

    app->setApplicationName("advCompoGallery");
    app->setOrganizationName("Skrolli");

    qmlRegisterType<CameraSelector>("CameraSelector", 1, 0, "CameraSelector");

    QDir data(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
    QDir test(QStandardPaths::writableLocation(QStandardPaths::DataLocation)+"/test");
    if(!data.exists())
    {
        data.mkpath(data.path());
    }
    if(!test.exists())
    {
        test.mkpath(test.path());
    }

    QTranslator appTranslator;
    appTranslator.load("harbour-advcompogallery-" + QLocale::system().name(),
                        "/usr/share/harbour-advcompogallery/translations");
    app->installTranslator(&appTranslator);

    viewer->setSource(SailfishApp::pathTo("qml/harbour-advcompogallery.qml"));
    viewer->show();
    return app->exec();
}

