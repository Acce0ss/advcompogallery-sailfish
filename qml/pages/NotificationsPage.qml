import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0

Page {
  id: root

  property bool addNew: true
  property bool removing: false

  Notification {
    id: notification
    category: notificationCategory.text
    summary: persistentSwitch.checked ? notificationSummary.text : ""
    body: persistentSwitch.checked ? notificationContent.text : ""
    previewBody: popupSwitch.checked ? notificationPreviewContent.text : ""
    previewSummary: popupSwitch.checked ? notificationPreviewSummary.text : ""
    itemCount: numberOfItems.value

    onClicked: {
      app.activate();

    }

    onReplacesIdChanged: {
      console.log("Now at id " + replacesId)
      if(replacesId == 0 && root.removing)
      {
        root.removing = false;
        if(idModel.count > 0)
        {
          notification.replacesId = idModel.get(0).notificationId;
        }
      }

    }

    onClosed: {
      if(replacesId != 0) //circumvent a bug in the notifications plugin
      {
        reasonLabel.text = qsTr("Close reason number %1").arg(reason);
        var toBeRemoved = replacesIdLabel.currentIndex;
        console.log("removing index: " + toBeRemoved + ", id: ", notification.replacesId)
        idModel.remove(toBeRemoved);
        root.removing = true;
      }
    }
  }

  Timer {
    id: delayTimer
    interval: delaySlider.value
    onTriggered: {
      notification.timestamp = new Date();
      notification.publish();
      stop();
      if(root.addNew)
      {
        idModel.append({"notificationId": notification.replacesId});
        replacesIdLabel.currentIndex = idModel.count-1;
        root.addNew = false;
      }
    }
  }

  Connections {
    target: Qt.application
    onAboutToQuit: notification.close()
  }

  SilicaFlickable {
    anchors.fill: parent
    contentHeight: content.height

    ScrollDecorator {}

    Column {
      id: content
      width: parent.width
      PageHeader {
        title: qsTr("Notifications")
      }

      SectionHeader {
        text: qsTr("Controls")
      }

      Button {
        id: sendButton
        text: qsTr("Publish new notification")
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
          notification.replacesId = 0;
          root.addNew = true;
          delayTimer.start();
        }
      }
      Button {
        id: updateButton
        text: qsTr("Update current notification")
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: notification.replacesId > 0
        onClicked: {
          root.addNew = false;
          delayTimer.start();
        }
      }
      Button {
        id: closeButton
        text: qsTr("Close current notification")
        anchors.horizontalCenter: parent.horizontalCenter
        enabled: notification.replacesId > 0
        onClicked: {

          notification.close();
          if(idModel.count > 0)
          {
            //needs to be called because of a bug in
            // org.nemomobile.notifications plugin
            // so that closed() signal is properly emitted
            notification.replacesId = replacesIdLabel.currentItem.value;
          }
        }
      }
      Slider {
        id: delaySlider
        x: Theme.paddingLarge
        width: parent.width-2*Theme.paddingLarge

        label: qsTr("Delay")
        minimumValue: 1
        maximumValue: 10000
        value: 100
        stepSize: 100
        valueText: qsTr("%1 ms").arg(value)

      }
      TextSwitch {
        id: popupSwitch
        text: qsTr("Create the popup")
        checked: true
      }
      TextSwitch {
        id: persistentSwitch
        text: qsTr("Create persistent notification")
        checked: true
      }
      ComboBox {
        id: replacesIdLabel
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        label: qsTr("Current notification id:")
        visible: idModel.count > 0

        menu: ContextMenu {
          Repeater {
            id: idSpawner
            model: idModel

            delegate: MenuItem {
              text: notificationId
              property int value: notificationId
            }
          }
        }


        onCurrentIndexChanged: {
          if(replacesIdLabel.currentItem != null)
          {
            notification.replacesId = replacesIdLabel.currentItem.value;
          }
        }

        ListModel {
          id: idModel
        }
      }

      SectionHeader {
        text: qsTr("Indicators")
      }
      Label {
        id: reasonLabel
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: qsTr("Close reason number:")
      }

      SectionHeader {
        text: qsTr("Content")
      }
      TextField {
        id: notificationCategory
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: "x-nemo.email"
        placeholderText: label
        label: qsTr("Category of the notification")
      }
      TextField {
        id: notificationSummary
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: qsTr("test")
        placeholderText: label
        label: qsTr("Summary of the notification")
      }
      TextField {
        id: notificationPreviewSummary
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: qsTr("test")
        placeholderText: label
        label: qsTr("Summary for the popup")
      }
      TextField {
        id: notificationContent
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: qsTr("test")
        placeholderText: label
        label: qsTr("Content of the notification")
      }
      TextField {
        id: notificationPreviewContent
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: qsTr("test")
        placeholderText: label
        label: qsTr("Content of the popup")
      }
      Slider {
        id: numberOfItems

        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge

        maximumValue: 10
        minimumValue: 1
        stepSize: 1
        value: 1
        valueText: value
        label: qsTr("Number of notification items")
      }
    }
  }
}
