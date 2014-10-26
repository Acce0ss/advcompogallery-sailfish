# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-advcompogallery

CONFIG += sailfishapp link_pkgconfig
PKGCONFIG += sailfishapp gstreamer-0.10

QT += multimedia

SOURCES += src/harbour-advcompogallery.cpp

OTHER_FILES += qml/harbour-advcompogallery.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-advcompogallery.changes.in \
    rpm/harbour-advcompogallery.spec \
    rpm/harbour-advcompogallery.yaml \
    translations/*.ts \
    harbour-advcompogallery.desktop \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/PositioningPage.qml \
    translations/harbour-advcompogallery-fi.ts \
    qml/pages/AccelerationPage.qml \
    qml/pages/ProximityPage.qml \
    qml/pages/TapsPage.qml \
    qml/pages/TemplatePage.qml \
    qml/pages/GyroscopePage.qml \
    qml/pages/CompassPage.qml \
    qml/pages/SensorListPage.qml \
    qml/components/CircleIndicator.qml \
    qml/pages/CameraPage.qml \
    qml/pages/PhotoPreviewPage.qml \
    qml/pages/NotificationsPage.qml \
    qml/pages/DBusSendPage.qml \
    qml/pages/DBusReceivePage.qml \
    qml/pages/DBusListenPage.qml \
    qml/pages/VideoCameraPage.qml \
    qml/pages/VideoPreviewPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
CODECFORTR = UTF-8
TRANSLATIONS += translations/harbour-advcompogallery-fi.ts

presets.files = presets
presets.path = /usr/share/harbour-advcompogallery

INSTALLS = presets

HEADERS +=

