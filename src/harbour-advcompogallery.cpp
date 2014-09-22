#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QGuiApplication>
#include <QQuickView>
#include <QTranslator>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QScopedPointer<QQuickView> viewer(SailfishApp::createView());

    QTranslator appTranslator;
    appTranslator.load("harbour-advcompogallery-" + QLocale::system().name(),
                        "/usr/share/harbour-advcompogallery/translations");
    app->installTranslator(&appTranslator);

    qDebug() << QLocale::system().name();

    viewer->setSource(SailfishApp::pathTo("qml/harbour-advcompogallery.qml"));
    viewer->show();
    return app->exec();
}

