import QtQuick 2.0
import QtMultimedia 5.0

import Sailfish.Silica 1.0

import com.jolla.camera 1.0

Page {
  id: root

  property int count: 0
  property bool isPortrait: portraitSwitch.checked

  property bool _complete
  property bool _unload

  Camera {
    id: camera

    captureMode: Camera.CaptureVideo

    cameraState: (root._complete && !root._unload)
                 ? Camera.ActiveState
                 : Camera.UnloadedState

    onCameraStateChanged: {
      console.log("state: " + cameraState)
    }

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
          camera.cameraState = Camera.UnloadedState;
          root._complete = false;
          console.log("saved to: " + camera.videoRecorder.outputLocation)
          var source = savePathInput.text; //copy with current filename to prevent binding
          pageStack.push("VideoPreviewPage.qml", {source: source}, PageStackAction.Animated);
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
    device: "primary"
    onDeviceChanged: reload()
    viewfinderResolution: "1280x720"
    manufacturer: "Jolla"
    model: "Jolla"
    rotation: root.isPortrait ? 0 : 90
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

        text: StandardPaths.videos + "/test" + root.count + ".mkv";
        label: qsTr("Video save path")
        placeholderText: StandardPaths.videos + "/"

      }

//      TextSwitch {
//        id: activationSwitch
//        text: qsTr("Camera active")
//        anchors.horizontalCenter: parent.horizontalCenter
//        checked: true
//        onCheckedChanged: {

//          if(camera.cameraState == Camera.ActiveState)
//          {
//            camera.cameraState = Camera.UnloadedState;
//          }
//          else if(camera.cameraState == Camera.UnloadedState)
//          {
//            camera.cameraState = Camera.ActiveState;
//          }
//        }
//      }

      TextSwitch {
        id: portraitSwitch
        text: qsTr("video orientation portrait")
        anchors.horizontalCenter: parent.horizontalCenter
        checked: true
      }

      ComboBox {
        id: cameraChooser
        width: parent.width
        enabled: camera.videoRecorder.recorderState == CameraRecorder.StoppedState
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
        onCurrentIndexChanged: {
          extensions.device = currentItem.value;
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
            durationLabel.startTime = new Date();
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
                 camera.videoRecorder.recorderStatus == CameraRecorder.LoadingStatus //||
                 //camera.videoRecorder.recorderStatus == CameraRecorder.FinalizingStatus
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

        VideoOutput {
          id: output

          anchors.fill: parent

          visible: root.status == PageStatus.Active
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
        id: durationLabel
        x: Theme.paddingLarge
        width: parent.width-2*Theme.paddingLarge
        wrapMode: Text.Wrap
        property date startTime
        function simpleTimeString(duration)
        {
          var now = new Date();
          var time = new Date((now - startTime) + now.getTimezoneOffset()*60*1000);
          return time.getHours() + ":"
              + time.getMinutes() + ":"
              + time.getSeconds();
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

  Timer {
    id: reloadTimer
    interval: 100
    running: root._unload && camera.cameraStatus == Camera.UnloadedStatus
    onTriggered: {
      console.log("Reloaded")
      root._unload = false
    }
  }

  onStatusChanged: {

    if(root.status == PageStatus.Active)
    {
      _complete = true;
      console.log("what's happening?" + _complete + _unload)
      reload();
    }
  }

  Component.onCompleted: {
    _complete = true;
  }


  Component.onDestruction: {
    if (camera.cameraState != Camera.UnloadedState) {
      camera.cameraState = Camera.UnloadedState
    }
  }
}
