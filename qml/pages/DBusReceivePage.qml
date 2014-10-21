import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 1.0

Page {
  id: root

  DBusInterface {
    id: dbus
    destination: serviceInput.text //rename property to service, when 2.0 ready
    iface: interfaceInput.text
    path: pathInput.text
    busType: DBusInterface.SessionBus

    function send()
    {
      dbus.typedCallWithReturn(methodInput.text, [], function (result) {
        // This will be called when the result is available
        console.log('Got profile: ' + result);
        outputField.text = result;
    });
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
        title: qsTr("DBus receiving")
      }

      SectionHeader {
        text: qsTr("Controls")
      }
      TextField {
        id: serviceInput
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        inputMethodHints: Qt.ImhDigitsOnly
        placeholderText: label
        label: qsTr("DBus service (destination)")
        text: "com.nokia.profiled"
      }
      TextField {
        id: interfaceInput
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        inputMethodHints: Qt.ImhDigitsOnly
        placeholderText: label
        label: qsTr("DBus interface")
        text: "com.nokia.profiled"
      }
      TextField {
        id: pathInput
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        inputMethodHints: Qt.ImhDigitsOnly
        placeholderText: label
        label: qsTr("DBus object path")
        text: "/com/nokia/profiled"
      }
      TextField {
        id: methodInput
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        inputMethodHints: Qt.ImhDigitsOnly
        placeholderText: label
        label: qsTr("method name")
        text: "get_profile"
      }

      Button {
        id: sendButton
        text: qsTr("Send request")
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
          dbus.send();
        }
      }

      SectionHeader {
        text: qsTr("Content")
      }

      TextField {
        id: outputField
        enableSoftwareInputPanel: false
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
      }
    }
  }
}
