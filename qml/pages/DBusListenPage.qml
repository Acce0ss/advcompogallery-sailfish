import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 1.0

Page {
  id: root

  DBusInterface {
    id: dbus
    destination: "com.nokia.profiled" //rename property to service, when 2.0 ready
    iface: "com.nokia.profiled"
    path: "/com/nokia/profiled"
    busType: DBusInterface.SessionBus

    signalsEnabled: true

    //called on dbus signal
    function profile_changed(arg1, arg2, arg3)
    {

      outputField.text = qsTr("changed to different: %1<br>active: %2<br>")
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
        title: qsTr("Listening signals")
      }
      SectionHeader {
        text: qsTr("Controls")
      }

      Label {
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: qsTr("Try to change profile now")
      }

//            TextField {
//              id: serviceInput
//              x: Theme.paddingLarge
//              width: parent.width - 2*Theme.paddingLarge
//              inputMethodHints: Qt.ImhDigitsOnly
//              placeholderText: label
//              label: qsTr("DBus service (destination)")
//              text: "com.nokia.profiled"
//            }

//            Button {
//              id: sendButton
//              text: qsTr("Send request")
//              anchors.horizontalCenter: parent.horizontalCenter

//              onClicked: {
//                dbus.send();
//              }
//            }


      SectionHeader {
        text: qsTr("Indicators")
      }

      Label {
        id: outputField

        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge

        wrapMode: Text.Wrap
      }
    }
  }
}
