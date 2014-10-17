#ifndef CAMERASELECTOR_H
#define CAMERASELECTOR_H

#include <QObject>
#include <QCamera>
#include <QVideoDeviceSelectorControl>

class CameraSelector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* cameraObject WRITE setCameraObject)
    Q_PROPERTY(int selectedCameraDevice WRITE setSelectedCameraDevice)

public:
    explicit CameraSelector(QObject *parent = 0);




signals:

public slots:
    void setCameraObject(QObject *cam);
    void setSelectedCameraDevice(int cameraId);
private:
    QCamera *m_camera;
    QVideoDeviceSelectorControl *m_deviceSelector;

};

#endif // CAMERASELECTOR_H
