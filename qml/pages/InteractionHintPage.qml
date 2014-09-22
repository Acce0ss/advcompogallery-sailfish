/****************************************************************************************
**
** Copyright (C) 2014 Jolla Ltd.
** Contact: Joona Petrell <joona.petrell@jollamobile.com>
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
    id: root

    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageStack.pushAttached(attachedPage)
        }
    }
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        PullDownMenu {
            MenuItem {
                text: "Clear"
                onClicked: {
                    swipeCombobox.currentIndex = 0
                    flickCombobox.currentIndex = 0
                }
            }
        }

        Column {
            id: column
            width: root.width
            PageHeader { title: "Touch hints" }
            ComboBox {
                id: swipeCombobox

                width: parent.width
                label: "Swipe hint"
                menu: ContextMenu {
                    onActivated: flickCombobox.currentIndex = 0

                    MenuItem { text: "None" }
                    MenuItem { text: "Top" }
                    MenuItem { text: "Bottom" }
                    MenuItem { text: "Left" }
                    MenuItem { text: "Right" }
                }

                Component.onCompleted: update()
                onCurrentIndexChanged: update()

                function update() {
                    verticalSwipe.stop()
                    horizontalSwipe.stop()

                    switch (currentIndex) {
                    case 0: // "None"
                        break
                    case 1: // "Top"
                        verticalSwipe.direction = TouchInteraction.Down
                        verticalSwipe.startY = -verticalSwipe.height
                        verticalSwipe.start()
                        break
                    case 2: // "Bottom"
                        verticalSwipe.direction = TouchInteraction.Up
                        verticalSwipe.startY = root.height
                        verticalSwipe.start()
                        break
                    case 3: // "Left"
                        horizontalSwipe.direction = TouchInteraction.Right
                        horizontalSwipe.startX = -horizontalSwipe.width
                        horizontalSwipe.start()
                        break
                    case 4: // "Right"
                        horizontalSwipe.direction = TouchInteraction.Left
                        horizontalSwipe.startX = root.width
                        horizontalSwipe.start()
                        break
                    default:
                        console.log("Unknown option")
                        break
                    }
                }
            }
            ComboBox {
                id: flickCombobox

                currentIndex: 4
                width: parent.width
                label: "Flick hint"
                menu: ContextMenu {
                    onActivated: swipeCombobox.currentIndex = 0

                    MenuItem { text: "None" }
                    MenuItem { text: "Up" }
                    MenuItem { text: "Down" }
                    MenuItem { text: "Left" }
                    MenuItem { text: "Right" }
                }

                Component.onCompleted: update()
                onCurrentIndexChanged: update()

                function update() {
                    verticalFlick.stop()
                    horizontalFlick.stop()

                    switch (currentIndex) {
                    case 0: // "None"
                        break
                    case 1: // "Up"
                        verticalFlick.direction = TouchInteraction.Up
                        verticalFlick.start()
                        break
                    case 2: // "Down"
                        verticalFlick.direction = TouchInteraction.Down
                        verticalFlick.start()
                        break
                    case 3: // "Left"
                        horizontalFlick.direction = TouchInteraction.Left
                        horizontalFlick.start()
                        break
                    case 4: // "Right"
                        horizontalFlick.direction = TouchInteraction.Right
                        horizontalFlick.start()
                        break
                    default:
                        console.log("Unknown option")
                        break
                    }
                }
            }
            Item {
                width: parent.width
                height: Screen.height
            }
            InfoLabel { text: "More content :)" }
            Item {
                width: parent.width
                height: Screen.height/3
            }
        }

        VerticalScrollDecorator {}
    }
    InteractionHintLabel {
        anchors.bottom: parent.bottom
        Behavior on opacity { FadeAnimation { duration: 1000 } }
        text: {
            switch (swipeCombobox.currentIndex) {
            case 1:
                return "Swipe from top to close the application"
            case 2:
                return "Swipe from bottom to access events view"
            case 3:
            case 4:
                return "Swipe from either edge to go back to home"
            }
            switch (flickCombobox.currentIndex) {
            case 1:
                return "Flick up to scroll for more content"
            case 2:
                return "Flick down to access pulley menu"
            case 3:
                return "Flick left to access attached page"
            case 4:
                return "Flick right to return to previous page"
            }
            return "Select example gesture hint"
        }
    }
    TouchInteractionHint {
        id: verticalSwipe
        loops: Animation.Infinite
        anchors.horizontalCenter: parent.horizontalCenter
    }
    TouchInteractionHint {
        id: horizontalSwipe
        loops: Animation.Infinite
        anchors.verticalCenter: parent.verticalCenter
    }
    TouchInteractionHint {
        id: verticalFlick
        loops: Animation.Infinite
        anchors.horizontalCenter: parent.horizontalCenter
    }
    TouchInteractionHint {
        id: horizontalFlick
        loops: Animation.Infinite
        anchors.verticalCenter: parent.verticalCenter
    }
    Page {
        id: attachedPage
        InfoLabel {
            text: "Attached page"
            anchors.centerIn: parent
        }
    }
}
