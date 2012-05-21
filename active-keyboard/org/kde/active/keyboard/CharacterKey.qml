/*
 * This file is part of Maliit plugins
 *
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
 *
 * Contact: Jakub Pavelek <jpavelek@live.com>
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

import Qt 4.7
import org.kde.plasma.core 0.1 as PlasmaCore
import "KeyboardUiConstants.js" as UI

Item {
    id: aCharKey
    property string caption: ""
    property string captionShifted: ""
    property int fontSize: UI.FONT_SIZE
    property string symView: ""
    property string symView2: ""
    property bool isPressed: false
    property string accents: ""

    property bool isNormal: !isShifted && !inSymView && !inSymView2

    PlasmaCore.FrameSvgItem {
        imagePath: "widgets/button"
        prefix: aCharKey.isPressed ? "pressed" : "normal"
        anchors.fill: parent
    }

    Text {
        id: key_label
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "sans"
        font.pixelSize: fontSize
        color: theme.textColor
        text: (inSymView && symView.length) > 0 ? (inSymView2 ? symView2 : symView) : (isShifted ? captionShifted : caption)
    }

    Popper {
        id: popper
        anchors.horizontalCenter: parent.horizontalCenter
        y: pluginClose.atBottom ? parent.y - height : parent.height
        text: key_label.text
        pressed: aCharKey.caption != "" && aCharKey.caption != " " && aCharKey.isPressed
    }


    function pressed(mouse) {
        aCharKey.isPressed = true
    }

    function clicked(mouse) {
        //not used at the moment
    }

    function pressAndHold(mouse) {
        if (isNormal && aCharKey.accents.length > 0) {
            var pos = aCharKey.mapToItem(vkb, 0, - aCharKey.height)
            accentsPopup.accents = aCharKey.accents
            accentsPopup.y = pos.y
            accentsPopup.x = Math.min(pos.x, vkb.width - accentsPopup.width)
            accentsPopup.visible = true
        } else {
            charRepeater.start()
        }
    }

    function released(mouse) {
        charRepeater.stop()
        aCharKey.isPressed = false
        MInputMethodQuick.sendCommit(key_label.text)
        isShifted = isShiftLocked ? isShifted : false
    }

    function canceled() {
        charRepeater.stop()
        aCharKey.isPressed = false
    }

    function exited() {
        charRepeater.stop()
        aCharKey.isPressed = false
    }

    Timer {
        id: charRepeater
        interval: 80
        repeat: true
        triggeredOnStart: true
        onTriggered: MInputMethodQuick.sendCommit(key_label.text)
    }
}
