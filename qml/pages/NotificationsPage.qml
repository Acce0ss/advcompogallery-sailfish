import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.notifications 1.0

Page {
  id: root

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
      activeIndicator.checked = false;
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
        text: qsTr("Publish notification")
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
          notification.timestamp = new Date();
          notification.publish();
          activeIndicator.checked = true;
        }
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

      SectionHeader {
        text: qsTr("Content")
      }
      TextSwitch {
        id: activeIndicator
        enabled: false
        text: qsTr("Notification active")
        checked: false
      }
      TextField {
        id: notificationSummary
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: "x-nemo.email"
        placeholderText: label
        label: qsTr("Category of the notification")
      }
      TextField {
        id: notificationCategory
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
