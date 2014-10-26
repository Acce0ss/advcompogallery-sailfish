import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
  id: root

  property alias source: mediaPlayer.source

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Video")
    }

    Row {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      property bool stopped: mediaPlayer.playbackState == MediaPlayer.StoppedState
      property bool paused: mediaPlayer.playbackState == MediaPlayer.PausedState
      Button {
        width: parent.width / 2
        text: parent.stopped ? qsTr("Play") : (paused ? qsTr("Play") : qsTr("Stop"))
        onClicked: {
          if(parent.stopped || parent.paused)
          {
            mediaPlayer.play();
          }
          else
          {
            mediaPlayer.stop();
          }
        }
      }
      Button {
        width: parent.width / 2
        text: qsTr("Pause")
        enabled: !parent.paused
        onClicked: {
          mediaPlayer.pause();
        }
      }
    }

    Slider {
      enabled: mediaPlayer.seekable
      minimumValue: 0
      maximumValue: mediaPlayer.duration+1
      stepSize: (1.0/15.0)*1000
      onValueChanged: {
        var time = new Date(value);
        valueText = time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds();
      }

    }

    VideoOutput {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      height: 500

      source: MediaPlayer {
        id: mediaPlayer
      }
      visible: mediaPlayer.status >= MediaPlayer.Loaded && mediaPlayer.status <= MediaPlayer.EndOfMedia
    }
  }
}
