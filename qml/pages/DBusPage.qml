import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 1.0

Page {
  id: root

  DBusInterface {
    id: smsSend
    destination: 'org.nemomobile.qmlmessages' //rename property to service, when 2.0 ready
    iface: 'org.nemomobile.qmlmessages'
    path: '/'
    busType: DBusInterface.SessionBus

    function send()
    {
      smsSend.call("startSMS", "array:string:\'"+smsTarget.text+"\' string:\'"+smsContent.text+"\'")
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
        placeholderText: qsTr("Number for SMS window")
        label: qsTr("Number for SMS window")
      }
      TextField {
        id: smsContent
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge

        placeholderText: qsTr("Content for the SMS")
        label: qsTr("Content for the SMS")
      }
    }
  }
}
