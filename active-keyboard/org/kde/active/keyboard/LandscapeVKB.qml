/*
 * This file is part of Maliit Plugins
 *
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
 *
 * Contact: Mohammad Anwari <Mohammad.Anwari@nokia.com>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Nokia Corporation nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import "KeyboardUiConstants.js" as UI

PlasmaCore.FrameSvgItem {
    id: vkb
    imagePath: "dialogs/background"
    width:  mainColumn.width + margins.left + margins.right
    height: mainColumn.height + margins.top + margins.bottom
    y: pluginClose.atBottom ? parent.height - height + margins.bottom + translation : - margins.top - translation

    property bool shown: pluginClose.state != "closed"
    onShownChanged: if (!shown) accentsPopup.visible = false
    property real translation: shown ? 0 : height

    anchors.horizontalCenter: parent.horizontalCenter

    z: 100
    property variant row1:["q1€", "w2£", "e3$", "r4¥", "t5₹", "y6%", "u7<", "i8>", "o9[", "p0]"]
    property variant row2: ["a*`", "s#^", "d+|", "f-_", "g=§", "h({", "j)}", "k?¿", "l!¡"]
    property variant row3: ["z@«", "x~»", "c/\"", "v\\“", "b'”", "n;„", "m:&", ".,,."]
    property variant row4: [":;;:"]
    property variant accents_row1: ["", "", "eèéêë", "", "tþ", "yý", "uûùúü", "iîïìí", "oöôòó", ""]
    property variant accents_row2: ["aäàâáãå", "", "dð", "", "", "", "", "", ""]
    property variant accents_row3: ["", "", "cç", "", "", "nñ", ""]
    property variant accents_row1_shift: ["", "", "EÈÉÊË", "", "TÞ", "YÝ", "UÛÙÚÜ", "IÎÏÌÍ", "OÖÔÒÓ", ""]
    property variant accents_row2_shift: ["AÄÀÂÁÃÅ", "", "DÐ", "", "", "", "", "", ""]
    property variant accents_row3_shift: ["", "", "CÇ", "", "", "NÑ", ""]

    property int columns: Math.max(row1.length, row2.length, row3.length)
    property int keyWidth: (columns == 11) ? UI.landscapeWidthNarrow
                                           : UI.landscapeWidth
    property int keyHeight: UI.landscapeHeight
    property int keyMargin: (columns == 11) ? UI.landscapeMarginNarrow
                                            : UI.landscapeMargin
    property bool isShifted: false
    property bool isShiftLocked: false
    property bool inSymView: false
    property bool inSymView2: false

    Behavior on y {
        SequentialAnimation {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
            ScriptAction {
                script: {
                    if (!shown) {
                        MInputMethodQuick.userHide()
                    }
                    MInputMethodQuick.setInputMethodArea(
                         Qt.rect(vkb.x, vkb.y, mainColumn.width, vkb.height))
                }
            }
        }
    }

    //only purpose: avoid keyboard dismiss on clisk
    MouseArea {
        anchors.fill: parent 
        onPressed: mouse.accepted = true
    }

    //dismiss accents popup
    MouseArea {
        anchors.fill: parent
        z: accentsPopup.z -1
        visible: accentsPopup.visible
        onClicked: accentsPopup.visible = false
    }
    PlasmaCore.FrameSvgItem {
        id: accentsPopup
        visible: false
        z: 9999
        property string accents: ""
        imagePath: "dialogs/background"
        width: childrenRect.width + margins.left + margins.right
        height: childrenRect.height + margins.top + margins.bottom
        Row {
            x: accentsPopup.margins.left
            y: accentsPopup.margins.top
            spacing: UI.landscapeMargin
            Repeater {
                model: accentsPopup.accents.length
                CharacterKey {
                    width: keyWidth; height: keyHeight
                    caption: accentsPopup.accents[modelData]
                    captionShifted: caption
                }
            }
        }
    }
    CharacterKeyProxy {
        keysContainer: accentsPopup
    }

    Column { //Holder for the VKB rows
        id: mainColumn
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: vkb.margins.left
            topMargin: vkb.margins.top
        }
        spacing: 4

        Row { //Row 1
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: keyMargin
            z: pluginClose.atBottom ? 1 : 4
            Repeater {
                model: row1
                CharacterKey {
                    width: keyWidth; height: keyHeight
                    caption: row1[index][0]
                    captionShifted: row1[index][0].toUpperCase()
                    symView: row1[index][1]
                    symView2: row1[index][2]
                    accents: accents_row1[index]
                    accentsShifted: accents_row1_shift[index]
                }
            }

        } //end Row1

        Row { //Row 2
            id: keys2
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: parent.leftMargin * 2
                rightMargin: parent.leftMargin * 2
            }
            spacing: keyMargin
            z: pluginClose.atBottom ? 2 : 3
            FunctionKey {
                id: tabKey
                width: keyWidth * 2;
                height: keyHeight
                landscape: true
                caption: inSymView ? 'Esc' : ''
                icon: inSymView ? '' : (isShifted) ? "icon-m-input-methods-untab.svg"
                                  : "icon-m-input-methods-tab.svg"
                onClickedPass: inSymView ? MInputMethodQuick.sendKey(Qt.Key_Escape) : MInputMethodQuick.sendCommit("\t")
            }
            Repeater {
                model: row2
                CharacterKey {
                    width: keyWidth; height: keyHeight
                    caption: row2[index][0]
                    captionShifted: row2[index][0].toUpperCase()
                    symView: row2[index][1]
                    symView2: row2[index][2]
                    accents: accents_row2[index]
                    accentsShifted: accents_row2_shift[index]
                }
            }
            FunctionKey {
                width: tabKey.width;
                height: keyHeight
                landscape: true
                repeat: true
                icon: "icon-m-input-methods-backspace.svg"
                onClickedPass: MInputMethodQuick.sendCommit("\b");
            }
        } //end Row2

        Row { //Row 3
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: parent.leftMargin * 2
                rightMargin: parent.leftMargin * 2
            }
            spacing: keyMargin
            z: pluginClose.atBottom ? 3 : 2

            FunctionKey {
                id: shiftKey
                width: (keys2.width - row3.length * (keyWidth + keyMargin) - keyMargin) / 2;
                height: keyHeight
                landscape: true
                icon: inSymView ? ""
                    : (isShiftLocked) ? "icon-m-input-methods-capslock.svg"
                    : (isShifted) ? "icon-m-input-methods-shift-uppercase.svg"
                    : "icon-m-input-methods-shift-lowercase.svg"

                caption: inSymView ? (inSymView2 ? "2/2" : "1/2") : ""
                opacity: (mouseArea.containsMouse || (isShiftLocked && (!inSymView))) ? 0.6 : 1
                onClickedPass: {
                    if (inSymView) {
                        inSymView2 = !inSymView2
                    } else {
                        isShifted = (!isShifted)
                        isShiftLocked = false
                    }
                }
                onPressedAndHoldPass: {
                    if (!inSymView) {
                        isShifted = true
                        isShiftLocked = true
                    }
                }
            }

            Repeater {
                model: row3
                CharacterKey {
                    width: keyWidth; height: keyHeight
                    caption: row3[index][0]
                    captionShifted: row3[index][0].toUpperCase()
                    symView: row3[index][1]
                    symView2: row3[index][2]
                }
            }

            FunctionKey {
                width: (keys2.width - row3.length * (keyWidth + keyMargin) - keyMargin) / 2;
                height: keyHeight
                landscape: true
                repeat: true
                icon: MInputMethodQuick.actionKeyOverride.icon
                caption: MInputMethodQuick.actionKeyOverride.label
                onClickedPass: MInputMethodQuick.activateActionKey()
            }
        } //end Row3

        Row { //Row 4
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: keyMargin
            z: pluginClose.atBottom ? 4 : 1
            FunctionKey {
                id: symKey
                width: 145; height: keyHeight
                landscape: true
                caption: inSymView ? "ABC" : "?123"
                onClickedPass: inSymView = (!inSymView)
            }

            Repeater {
                model: row4
                CharacterKey {
                    width: keyWidth; height: keyHeight
                    caption: row4[index][0]
                    captionShifted: row4[index][0].toUpperCase()
                    symView: row4[index][1]
                    symView2: row4[index][2]
                }
            }

            CharacterKey {
                caption: " ";
                captionShifted: " ";
                width: keys2.width - symKey.width - (row4.length * (keyWidth + keyMargin)) - keyWidth * 4 - (5 * keyMargin);
                height: keyHeight
            }

            FunctionKey {
                width: keyWidth; height: keyHeight
                landscape: true
                icon: "icon-m-input-methods-up.svg"
                onClickedPass: MInputMethodQuick.sendKey(Qt.Key_Up)
            }
            FunctionKey {
                width: keyWidth; height: keyHeight
                landscape: true
                icon: "icon-m-input-methods-down.svg"
                onClickedPass: MInputMethodQuick.sendKey(Qt.Key_Down)
            }
            FunctionKey {
                width: keyWidth; height: keyHeight
                landscape: true
                icon: "icon-m-input-methods-left.svg"
                onClickedPass: MInputMethodQuick.sendKey(Qt.Key_Left)
            }
            FunctionKey {
                width: keyWidth; height: keyHeight
                landscape: true
                icon: "icon-m-input-methods-right.svg"
                onClickedPass: MInputMethodQuick.sendKey(Qt.Key_Right)
            }
        } //end Row4
    }//end Column

    CharacterKeyProxy {
        keysContainer: mainColumn
    }
} //end VKB area
