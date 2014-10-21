/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Martin Jones <martin.jones@jollamobile.com>
** All rights reserved.
** 
** This file is part of Sailfish Silica UI component package.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
** 
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
  id: mainPage

  ListModel {
    id: pagesModel

    ListElement {
      page: "SensorListPage.qml"
      title: QT_TR_NOOP("Sensor list")
      subtitle: QT_TR_NOOP("Shows available sensors")
      section: QT_TR_NOOP("Sensors and measurement")
    }

    ListElement {
      page: "PositioningPage.qml"
      title: QT_TR_NOOP("Positioning")
      subtitle: QT_TR_NOOP("Getting GPS coordinates etc.")
      section: QT_TR_NOOP("Sensors and measurement")
    }

    ListElement {
      page: "CompassPage.qml"
      title: QT_TR_NOOP("Compass")
      subtitle: QT_TR_NOOP("Reading the values from E-compass")
      section: QT_TR_NOOP("Sensors and measurement")
    }

    ListElement {
      page: "AccelerationPage.qml"
      title: QT_TR_NOOP("Accelerometer")
      subtitle: QT_TR_NOOP("Getting various acceleration data")
      section: QT_TR_NOOP("Sensors and measurement")
    }

    ListElement {
      page: "GyroscopePage.qml"
      title: QT_TR_NOOP("Gyroscope")
      subtitle: QT_TR_NOOP("Getting various acceleration data")
      section: QT_TR_NOOP("Sensors and measurement")
    }

    ListElement {
      page: "ProximityPage.qml"
      title: QT_TR_NOOP("Proximity")
      subtitle: QT_TR_NOOP("Sensing when something is close")
      section: QT_TR_NOOP("Sensors and measurement")
    }


    // Doesn't seem to work yet, gives timestamp from year 4147..
//    ListElement {
//      page: "TapsPage.qml"
//      title: QT_TR_NOOP("Taps")
//      subtitle: QT_TR_NOOP("Sensing tapping")
//      section: QT_TR_NOOP("Sensors and measurement")
//    }

    ListElement {
      page: "CameraPage.qml"
      title: QT_TR_NOOP("Camera")
      subtitle: QT_TR_NOOP("Viewfinder and saving an image")
      section: QT_TR_NOOP("Multimedia")
    }

    ListElement {
      page: "VideoCameraPage.qml"
      title: QT_TR_NOOP("Video Camera")
      subtitle: QT_TR_NOOP("Viewfinder and saving a video")
      section: QT_TR_NOOP("Multimedia")
    }

    ListElement {
      page: "NotificationsPage.qml"
      title: QT_TR_NOOP("Notifications")
      subtitle: QT_TR_NOOP("Creating text notifications")
      section: QT_TR_NOOP("Nemo and system APIs")
    }
    ListElement {
      page: "DBusSendPage.qml"
      title: QT_TR_NOOP("Sending DBus requests")
      subtitle: QT_TR_NOOP("Using DBus calls from QML")
      section: QT_TR_NOOP("Nemo and system APIs")
    }

    ListElement {
      page: "DBusReceivePage.qml"
      title: QT_TR_NOOP("Receiving the reply from DBus")
      subtitle: QT_TR_NOOP("Using DBus calls from QML")
      section: QT_TR_NOOP("Nemo and system APIs")
    }

    ListElement {
      page: "DBusListenPage.qml"
      title: QT_TR_NOOP("Listening to a DBus signal")
      subtitle: QT_TR_NOOP("Using DBus calls from QML")
      section: QT_TR_NOOP("Nemo and system APIs")
    }

    //        ListElement {
    //            page: "Page.qml"
    //            title: QT_TR_NOOP("")
    //            subtitle: QT_TR_NOOP("")
    //            section: QT_TR_NOOP("")
    //        }
  }
  SilicaListView {
    id: listView
    anchors.fill: parent
    model: pagesModel
    header: PageHeader { title: qsTr("Components") }
    section {
      property: 'section'
      delegate: SectionHeader {
        text: qsTr(section)
      }
    }
    delegate: BackgroundItem {
      width: listView.width
      Label {
        id: firstName
        text: qsTr(model.title)
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
        anchors.verticalCenter: parent.verticalCenter
        x: Theme.paddingLarge
      }
      onClicked: pageStack.push(Qt.resolvedUrl(page))
    }
    VerticalScrollDecorator {}
  }
}





