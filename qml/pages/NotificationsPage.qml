import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0

Page {
  id: root

  property bool addNew: true

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

    onClosed: {
      reasonLabel.text = qsTr("Close reason number %1").arg(reason);
      activeIndicator.checked = false;
      idModel.remove(replacesIdLabel.currentIndex, 1);
      if(idModel.count > 0)
      {
        replacesId = replacesIdLabel.currentItem.value;
      }
    }
  }

  Timer {
    id: delayTimer
    interval: delaySlider.value
    onTriggered: {
      notification.timestamp = new Date();
      notification.publish();
      activeIndicator.checked = true;
      stop();
      if(root.addNew)
      {
        idModel.append({"notificationId": notification.replacesId})
        replacesIdLabel.currentIndex = idModel.count - 1; // change to latest added
        root.addNew = false
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
          notification.closed(3); // 3 means "closed by call to CloseNotification"
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
          notification.replacesId = currentItem.value;
        }

        ListModel {
          id: idModel
        }
      }

      SectionHeader {
        text: qsTr("Indicators")
      }
      TextSwitch {
        id: activeIndicator
        enabled: false
        text: qsTr("Notification active")
        checked: false
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
        placeholderText: label
        label: qsTr("Summary of the notification")
      }
      TextField {
        id: notificationPreviewSummary
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        placeholderText: label
        label: qsTr("Summary for the popup")
      }
      TextField {
        id: notificationContent
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        placeholderText: label
        label: qsTr("Content of the notification")
      }
      TextField {
        id: notificationPreviewContent
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
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
