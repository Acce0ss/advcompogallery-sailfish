import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
  id: root

  function playSound(){
    effectComponent.createObject(root);
  }

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Playing a sound effect")
    }

    SectionHeader {
      text: qsTr("Controls")
    }

    Button {
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
      text: qsTr("Play")
      onClicked: {
        root.playSound();
      }
    }

    TextSwitch {
      id: muteSwitch
      text: qsTr("Mute sound effect")
      checked: false
    }
  }

  Component {
    id: effectComponent
    SoundEffect {
      id: effect
      source: "/usr/share/harbour-advcompogallery/sounds/explosion.wav"

      muted: muteSwitch.checked

      Component.onCompleted: {
        console.log("sound created!")
        effect.play();
      }

      onPlayingChanged: {
        if(!playing)
        {
          effect.destroy(); //don't do if using a Loader or Repeater!
        }
      }
    }
  }
}
