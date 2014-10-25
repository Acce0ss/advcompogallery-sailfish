import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0

Page {
  id: root

  DBusInterface {
    id: smsSend
    service: 'org.nemomobile.qmlmessages' //rename property to service, when 2.0 ready
    iface: 'org.nemomobile.qmlmessages'
    path: '/'
    bus: DBus.SessionBus

    function send()
    {
      smsSend.typedCall("startSMS", [
                     { 'type':'as', 'value':[smsTarget.text] },
                     { 'type':'s', 'value':smsContent.text }
                 ])
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
        title: qsTr("DBus sending")
      }

      SectionHeader {
        text: qsTr("Controls")
      }

      Button {
        id: sendButton
        text: qsTr("Open SMS window")
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
          smsSend.send();
        }
      }

      SectionHeader {
        text: qsTr("Content")
      }

      TextField {
        id: smsTarget
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        inputMethodHints: Qt.ImhDigitsOnly
        placeholderText: label
        label: qsTr("Number for SMS window")
      }
      TextField {
        id: smsContent
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge

        placeholderText: label
        label: qsTr("Content for the SMS")
      }
    }
  }
}
