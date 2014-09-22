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

CONFIG += sailfishapp

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
    qml/pages/WizardPage.qml \
    qml/pages/WebViewPage.qml \
    qml/pages/TextInputPage.qml \
    qml/pages/SliderPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/ProgressPage.qml \
    qml/pages/PanelPage.qml \
    qml/pages/PageStackPage.qml \
    qml/pages/OrientationPage.qml \
    qml/pages/OpacityRamp.qml \
    qml/pages/MenuPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/LabelPage.qml \
    qml/pages/InteractionHintPage.qml \
    qml/pages/HapticPage.qml \
    qml/pages/FormatterPage.qml \
    qml/pages/FontComboBox.qml \
    qml/pages/EffectPage.qml \
    qml/pages/DialogPage.qml \
    qml/pages/CoverPage.qml \
    qml/pages/CoverExample.qml \
    qml/pages/Cover.qml \
    qml/pages/ComboBoxPage.qml \
    qml/pages/ButtonPage.qml \
    qml/pages/ButtonGroup.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-advcompogallery-de.ts

