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

#include <gst/gst.h>
#include <gst/gstpreset.h>


int main(int argc, char *argv[])
{
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QScopedPointer<QQuickView> viewer(SailfishApp::createView());

    app->setApplicationName("advCompoGallery");
    app->setOrganizationName("Skrolli");

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

    gst_init(0, 0);
    gst_preset_set_app_dir("/usr/share/harbour-advcompogallery/presets");

    QTranslator appTranslator;
    appTranslator.load("harbour-advcompogallery-" + QLocale::system().name(),
                       "/usr/share/harbour-advcompogallery/translations");
    app->installTranslator(&appTranslator);

    qDebug() << "TEst";

    viewer->setSource(SailfishApp::pathTo("qml/harbour-advcompogallery.qml"));
    viewer->show();
    return app->exec();
}

