/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
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
    id: textInputPage

    property var textAlignment: undefined

    allowedOrientations: allowAllOrientations.checked ? Orientation.All : Orientation.Portrait

    Rectangle {
        color: "blue"
        width: parent.width
        height: 10
        visible: showDebugRects.checked
    }

    Rectangle {
        color: "white"
        anchors.bottom: parent.bottom
        width: parent.width
        height: 10
        visible: showDebugRects.checked
    }

    Rectangle {
        color: "yellow"
        width: 10
        height: parent.height
        visible: showDebugRects.checked
    }

    Rectangle {
        color: "red"
        anchors.right: parent.right
        width: 10
        height: parent.height
        visible: showDebugRects.checked
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: "Window.Landscape"
                onClicked: {
                    mainWindow.allowedOrientations = Orientation.Landscape
                }
            }
            MenuItem {
                text: "Window.Portrait"
                onClicked: {
                    mainWindow.allowedOrientations = Orientation.Portrait
                }
            }
            MenuItem {
                text: "Window.All"
                onClicked: {
                    mainWindow.allowedOrientations = Orientation.All
                }
            }
        }

        PushUpMenu {
            MenuItem {
                text: "Window.All"
                onClicked: {
                    mainWindow.allowedOrientations = Orientation.All
                }
            }
            MenuItem {
                text: "Window.Portrait"
                onClicked: {
                    mainWindow.allowedOrientations = Orientation.Portrait
                }
            }
            MenuItem {
                text: "Window.Landscape"
                onClicked: {
                    mainWindow.allowedOrientations = Orientation.Landscape
                }
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader { title: "Text input" }

            TextSwitch {
                id: allowAllOrientations
                checked: false
                text: "Allow all orientations"
            }

            TextSwitch {
                id: showDebugRects
                checked: false
                text: "Show borders"
            }

            ComboBox {
                width: parent.width
                label: "Horizontal alignment"
                onCurrentIndexChanged: {
                    switch (currentIndex) {
                    case 0:
                        textAlignment = undefined
                        break
                    case 1:
                        textAlignment = TextInput.AlignLeft
                        break
                    case 2:
                        textAlignment = TextInput.AlignRight
                        break
                    case 3:
                        textAlignment = TextInput.AlignHCenter
                        break
                    }
                }

                menu: ContextMenu {
                    MenuItem { text: "Follows text" }
                    MenuItem { text: "Left" }
                    MenuItem { text: "Right" }
                    MenuItem { text: "HorizontalCenter" }
                }
            }

            TextField {
                width: parent.width
                label: "Text field"
                placeholderText: "Type here"
                focus: true
                horizontalAlignment: textAlignment
                EnterKey.onClicked: {
                    text = "Return key pressed";
                    parent.focus = true;
                }
            }

            TextField {
                width: parent.width
                readOnly: true
                label: "Read only text field"
                text: "Can't edit this"
                horizontalAlignment: textAlignment
            }

            TextField {
                width: parent.width
                readOnly: true
                focusOnClick: true
                label: "Read only text field, focusable"
                text: "Can't edit this, but you can focus"
                horizontalAlignment: textAlignment
                EnterKey.onClicked: parent.focus = true
            }

            TextField {

                width: parent.width
                inputMethodHints: Qt.ImhNoPredictiveText
                echoMode: TextInput.Password
                label: "Password input"
                placeholderText: "Enter password"
                horizontalAlignment: textAlignment
                EnterKey.onClicked: parent.focus = true
            }

            TextField {
                width: parent.width
                inputMethodHints: Qt.ImhNoPredictiveText
                validator: RegExpValidator { regExp: /^[a-zA-Z]{3,}$/ }
                label: "Validated input"
                placeholderText: "Enter three or more characters"
                horizontalAlignment: textAlignment
                EnterKey.onClicked: parent.focus = true
            }

            TextField {
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: "Number input"
                placeholderText: "Type number here"
                horizontalAlignment: textAlignment
                EnterKey.onClicked: parent.focus = true
            }

            TextField {
                width: parent.width
                inputMethodHints: Qt.ImhDialableCharactersOnly
                label: "Phone number input"
                placeholderText: "Type phone number"
                placeholderColor: Theme.highlightColor
                color: Theme.highlightColor
                horizontalAlignment: textAlignment
                EnterKey.onClicked: parent.focus = true
            }

            TextField {
                width: parent.width
                inputMethodHints: Qt.ImhNoPredictiveText
                validator: RegExpValidator { regExp: /^[a-zA-Z]{3,}$/ }
                label: "Custom background"
                placeholderText: "Enter three or more characters"
                horizontalAlignment: textAlignment
                textMargin: 15
                EnterKey.onClicked: parent.focus = true
                background: Component {
                    Rectangle {
                        id: customBackground

                        anchors.fill: parent
                        border {
                            color: parent.errorHighlight ?  "red" :"steelblue"
                            width: parent.errorHighlight ? 3 : 1
                        }
                        color: "lightblue"
                        radius: Theme.paddingSmall
                        smooth: true
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: customBackground.color }
                            GradientStop {
                                position: 1.0;
                                color: parent.errorHighlight ? "red" : Qt.darker(customBackground.color, 3.0)
                            }
                        }
                    }
                }
            }

            Column {
                width: parent.width
                TextSwitch { id: iconSource; text: "IconSource" }
                TextSwitch { id: enterkeyText; text: "Text" }
                TextSwitch { id: enabled; text: "Enabled" }
                TextSwitch { id: highlighted; text: "Highlighted" }
            }

            TextField {
                width: parent.width
                label: "Customize EnterKey"
                placeholderText: label
                horizontalAlignment: textAlignment
                focusOutBehavior: FocusBehavior.KeepFocus
                EnterKey.iconSource: iconSource.checked ? "image://theme/icon-m-enter-next" : ""
                EnterKey.text: enterkeyText.checked ? enterkeyText.text : ""
                EnterKey.enabled: enabled.checked
                EnterKey.highlighted: highlighted.checked
                EnterKey.onClicked: parent.focus = true
            }

            TextField {
                width: parent.width
                placeholderText: "labelVisible: false"
                horizontalAlignment: textAlignment
                labelVisible: false
            }

            TextArea {
                width: parent.width
                height: 350
                placeholderText: "Type multi-line text here"
                label: "Text area"
            }

            TextArea {
                width: parent.width
                height: Math.max(textInputPage.width/3, implicitHeight)
                placeholderText: "Type multi-line text here"
                label: "Expanding text area"
            }
        }
    }
}
