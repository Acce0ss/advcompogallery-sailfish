import QtQuick 2.0
import QtMultimedia 5.0

import Sailfish.Silica 1.0
import Sailfish.Media 1.0
import CameraSelector 1.0

Page {
  id: root

  property int count: 0
  //property bool isPortrait: portaitSwitch.checked

  CameraSelector {
    id: selector
    cameraObject: camera
  }

  Camera {
    id: camera

    captureMode: Camera.CaptureVideo

    focus {
      focusMode: Camera.FocusMacro
      focusPointMode: Camera.FocusPointCustom
    }

    videoRecorder {
      resolution: "640x480"
      frameRate: 15

      mediaContainer: "mp4"
      outputLocation: savePathInput.text

      onRecorderStatusChanged:{

      }
    }
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
        label: qsTr("Image save path")
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

      ComboBox {
        id: cameraChooser
        width: parent.width
        menu: ContextMenu {
          MenuItem {
            text: qsTr("Primary")
          }
          MenuItem {
            text: qsTr("Secondary")
          }
        }

        onCurrentIndexChanged: {
          camera.stop();
          selector.selectedCameraDevice = currentIndex;
          camera.start();
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
          }
        }
      }

      Button {
        id: pauseButton
        text: camera.videoRecorder.recorderStatus == CameraRecorder.PausedStatus ?
                qsTr("Pause recording") : qsTr("Continue recording")
        anchors.horizontalCenter: parent.horizontalCenter

        enabled: camera.videoRecorder.recorderStatus == CameraRecorder.RecordingStatus

        onClicked: {

          if(camera.videoRecorder.recorderStatus == CameraRecorder.RecordingStatus)
          {
            camera.videoRecorder.record();
          }
          else
          {
            camera.videoRecorder.stop();
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
