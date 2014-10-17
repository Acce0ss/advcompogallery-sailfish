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

    captureMode: Camera.CaptureStillImage

    focus {
      focusMode: Camera.FocusMacro
      focusPointMode: Camera.FocusPointCustom
      //customFocusPoint: Qt.point(0.2, 0.2) // Focus relative to top-left corner
    }

    imageCapture {

      resolution: "640x480"

      //Not working:
      onImageCaptured: {
        console.log("moi")
      }

      onImageSaved: {
        var source = savePathInput.text; //copy with current filename to prevent binding
        pageStack.push("PhotoPreviewPage.qml", {source: source}, PageStackAction.Animated);

        root.count++;
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

          BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Medium
            running: camera.cameraStatus == Camera.Busy
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
}
