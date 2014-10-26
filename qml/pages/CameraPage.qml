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

    captureMode: Camera.CaptureStillImage

    cameraState: root._complete && !root._unload
                 ? Camera.ActiveState
                 : Camera.UnloadedState

    focus {
      focusMode: Camera.FocusMacro
      focusPointMode: Camera.FocusPointCustom
      //customFocusPoint: Qt.point(0.2, 0.2) // Focus relative to top-left corner
    }

    imageCapture {

      resolution: extensions.viewfinderResolution

      //Not working:
      onImageCaptured: {
        console.log("moi")
      }

      onImageSaved: {
        //camera.cameraState = Camera.UnloadedState;
        var source = savePathInput.text; //copy with current filename to prevent binding
        pageStack.push("PhotoPreviewPage.qml", {source: source}, PageStackAction.Animated);

        root.count++;
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
    viewfinderResolution: "640x480"
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
        title: qsTr("Camera")
      }

      SectionHeader {
        text: qsTr("Controls")
      }

      TextField {
        id: savePathInput

        width: parent.width-2*Theme.paddingLarge

        text: StandardPaths.data + "/test" + root.count + ".jpg";
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
            camera.cameraState = Camera.UnloadedState;
          }
          else if(camera.cameraState == Camera.UnloadedState)
          {
            camera.cameraState = Camera.ActiveState;
          }
        }
      }
      TextSwitch {
        id: portraitSwitch
        text: qsTr("picture orientation portrait")
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

        onCurrentIndexChanged: {
          extensions.device = currentItem.value;
        }
      }

//      TextSwitch {
//        id: portaitSwitch
//        text: qsTr("Save as portrait")
//        anchors.horizontalCenter: parent.horizontalCenter
//        checked: true
//      }
//      TextSwitch {
//        id: cameraSwitch
//        text: qsTr("Use primary camera")
//        anchors.horizontalCenter: parent.horizontalCenter
//        checked: true
//      }

      Button {
        id: captureButton
        text: qsTr("Capture")
        anchors.horizontalCenter: parent.horizontalCenter

        enabled: camera.imageCapture.ready

        onClicked: {

          camera.imageCapture.captureToLocation(savePathInput.text);
          //invokes imageSaved signal when ready
        }
      }

      SectionHeader {
        text: qsTr("Indicators")
      }
      BusyIndicator {
        anchors.horizontalCenter: parent.horizontalCenter
        size: BusyIndicatorSize.Medium
        running: !camera.imageCapture.ready
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

          visible: camera.cameraState == Camera.ActiveState
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
        text: qsTr("Error: %1").arg(camera.errorString == "" ? qsTr("No errors") : camera.errorString)
      }
      Label {
        x: Theme.paddingLarge
        width: parent.width-2*Theme.paddingLarge
        wrapMode: Text.Wrap
        text: qsTr("Capture error: %1")
        .arg(camera.imageCapture.errorString == "" ? qsTr("No errors") : camera.imageCapture.errorString)
      }
    }
  }

  Timer {
    id: reloadTimer
    interval: 100
    running: root._unload && camera.cameraStatus == Camera.UnloadedStatus
    onTriggered: {
      root._unload = false
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
