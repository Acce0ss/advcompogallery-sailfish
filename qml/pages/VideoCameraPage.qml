import QtQuick 2.0
import QtMultimedia 5.0

import Sailfish.Silica 1.0
import Sailfish.Media 1.0
import com.jolla.camera 1.0

Page {
  id: root

  property int count: 0
  property bool isPortrait: portraitSwitch.checked

  Camera {
    id: camera

    captureMode: Camera.CaptureVideo

    focus {
      focusMode: Camera.FocusMacro
      focusPointMode: Camera.FocusPointCustom
    }

    videoRecorder {
      resolution: extensions.viewfinderResolution

      outputLocation: savePathInput.text

      audioSampleRate: 48000
      audioBitRate: 96
      audioChannels: 1
      audioCodec: "audio/mpeg, mpegversion=(int)4"
      frameRate: 30
      videoCodec: "video/x-h264"
      mediaContainer: "video/x-matroska"
      onRecorderStateChanged: {
        if (camera.videoRecorder.recorderState == CameraRecorder.StoppedState) {
          console.log("saved to: " + camera.videoRecorder.outputLocation)
        }
      }
    }
  }

  function reload() {
    if (root._complete) {
      root._unload = true;
    }
  }

  CameraExtensions {
    id: extensions
    camera: camera
    device: cameraChooser.currentItem.value
    onDeviceChanged: reload()
    viewfinderResolution: "1280x720"
    manufacturer: "Jolla"
    model: "Jolla"
    rotation: root.isPortrait ? 90 : 0
  }

  SilicaFlickable {

    anchors.fill: parent
    contentHeight: content.height

    ScrollDecorator {}

    Column {
      id: content
      width: parent.width

      PageHeader {
        title: qsTr("Video Camera")
      }

      SectionHeader {
        text: qsTr("Controls")
      }

      TextField {
        id: savePathInput

        width: parent.width-2*Theme.paddingLarge

        text: StandardPaths.data + "/test" + root.count + ".mp4";
        label: qsTr("Video save path")
        placeholderText: StandardPaths.data + "/"

      }

      TextSwitch {
        id: activationSwitch
        text: qsTr("Camera active")
        anchors.horizontalCenter: parent.horizontalCenter
        checked: true
        onCheckedChanged: {

          if(camera.cameraState == Camera.ActiveState)
          {
            camera.stop();
          }
          else if(camera.cameraState == Camera.LoadedState)
          {
            camera.start();
          }
        }
      }

      TextSwitch {
        id: portraitSwitch
        text: qsTr("video orientation portrait")
        anchors.horizontalCenter: parent.horizontalCenter
        checked: true
      }

      ComboBox {
        id: cameraChooser
        width: parent.width
        menu: ContextMenu {
          MenuItem {
            text: qsTr("Primary")
            property string value: "primary"
          }
          MenuItem {
            text: qsTr("Secondary")
            property string value: "secondary"
          }
        }
      }

      Button {
        id: captureButton
        text: camera.videoRecorder.recorderState == CameraRecorder.StoppedState ?
                qsTr("Start recording") : qsTr("Stop recording")
        anchors.horizontalCenter: parent.horizontalCenter

        enabled: camera.cameraState == Camera.ActiveState

        onClicked: {

          if(camera.videoRecorder.recorderState == CameraRecorder.StoppedState)
          {
            camera.videoRecorder.record();
          }
          else
          {
            camera.videoRecorder.stop();
            root.count++;
          }
        }
      }

      SectionHeader {
        text: qsTr("Indicators")
      }

      BusyIndicator {
        anchors.horizontalCenter: parent.horizontalCenter
        size: BusyIndicatorSize.Medium
        running: camera.availability == Camera.Busy ||
                 camera.videoRecorder.recorderStatus == CameraRecorder.LoadingStatus ||
                 camera.videoRecorder.recorderStatus == CameraRecorder.FinalizingStatus
      }

      Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 4*Theme.paddingLarge
        height: 500
        color: "transparent"
        border.width: 5
        border.color: switch(camera.lockStatus)
                      {
                      case Camera.Unlocked:
                        return "black";
                      case Camera.Locked:
                        return "red";
                      case Camera.Searching:
                        return "white"
                      }



        Behavior on border.color {
          ColorAnimation { to: border.color; duration: 200 }
        }

        GStreamerVideoOutput {
          id: output

          anchors.fill: parent

          focus: visible
          source: camera
          fillMode: VideoOutput.PreserveAspectCrop

          MouseArea {
            anchors.fill: parent
            onClicked: {
              camera.focus.customFocusPoint = Qt.point(mouse.x, mouse.y);
              camera.searchAndLock();
            }
          }
        }
      }
      Label {
        x: Theme.paddingLarge
        width: parent.width-2*Theme.paddingLarge
        wrapMode: Text.Wrap
        function simpleTimeString(duration)
        {
          var time = new Date(duration);
          return time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds();
        }
        text: qsTr("Length of video: %1").arg(simpleTimeString(camera.videoRecorder.duration))
      }
      Label {
        x: Theme.paddingLarge
        width: parent.width-2*Theme.paddingLarge
        wrapMode: Text.Wrap
        text: qsTr("Error: %1").arg(camera.errorString == "" ? qsTr("No errors") : camera.errorString)
      }
      Label {
        x: Theme.paddingLarge
        width: parent.width-2*Theme.paddingLarge
        wrapMode: Text.Wrap
        text: qsTr("Capture error: %1")
        .arg(camera.videoRecorder.errorString == "" ? qsTr("No errors") : camera.videoRecorder.errorString)
      }
    }
  }
}
