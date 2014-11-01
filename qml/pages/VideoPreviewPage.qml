import QtQuick 2.0
import QtMultimedia 5.0

import Sailfish.Silica 1.0

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
      property bool stoppedOrPaused: mediaPlayer.playbackState != MediaPlayer.PlayingState
      Button {
        width: parent.width / 2
        text: parent.stoppedOrPaused ? qsTr("Play") : qsTr("Pause")
        onClicked: {
          if(parent.stoppedOrPaused)
          {
            mediaPlayer.play();
          }
          else
          {
            mediaPlayer.pause();
          }
        }
      }
      Button {
        width: parent.width / 2
        text: qsTr("Stop")
        enabled: !parent.stoppedOrPaused
        onClicked: {
          mediaPlayer.stop();
        }
      }
    }

    Slider {
      id: seekSlider
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      enabled: mediaPlayer.seekable
      minimumValue: 0
      value: 0
      onValueChanged: {
        var now = new Date();
        var time = new Date(value * 1000 + now.getTimezoneOffset()*60*1000);

        valueText = time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds();
      }

      onReleased: {
        mediaPlayer.seek(value * 1000);
      }

    }
    VideoOutput {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      height: 500

      fillMode: VideoOutput.PreserveAspectCrop
      rotation: 90
      source:  mediaPlayer
    }
  }

  MediaPlayer {
    id: mediaPlayer

    onPositionChanged: {
      seekSlider.value = position / 1000;
    }

    onDurationChanged: {
      seekSlider.maximumValue = duration / 1000;
    }
  }

  onStatusChanged: {
    if(root.status == PageStatus.Deactivating)
    {
      mediaPlayer.stop();
      mediaPlayer.source = "";
    }
  }

}
