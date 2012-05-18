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
    id: aFunctKey
    property string icon: ""
    property string caption: ""
    property alias mouseArea: mouse_area
    property int fontSize: UI.FONT_SIZE
    property int sourceWidth: -1
    property int sourceHeight: -1
    property bool landscape: false
    property bool repeat: false

    signal clickedPass()
    signal released()
    signal pressedAndHoldPass()



    PlasmaCore.FrameSvgItem {
        imagePath: "widgets/button"
        prefix: mouse_area.pressed ? "pressed" : "normal"
        anchors.fill: parent
    }


    MouseArea {
        id: mouse_area
        anchors.fill: parent

        onClicked: clickedPass()
        onPressed: aFunctKey.opacity = 0.6

        onPressAndHold: {
            if (repeat) { functRepeater.start() }
            pressedAndHoldPass()
        }

        onReleased: {
            functRepeater.stop()
            parent.released()
            aFunctKey.opacity = 1
        }

        onCanceled:{ functRepeater.stop(); aFunctKey.opacity = 1 }

        onExited: functRepeater.stop()
    }

    Timer {
        id: functRepeater
        interval: 80; repeat: true
        triggeredOnStart: true
        onTriggered: parent.clickedPass()
    }

    Image {
        anchors.centerIn: parent
        source: icon
        sourceSize.width: (sourceWidth == -1) ? width : sourceWidth
        sourceSize.height: (sourceHeight == -1) ? height : sourceHeight
    }

    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "sans"
        font.pixelSize: fontSize
        color: theme.textColor
        text: caption
    }
}
