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

MouseArea {
    property Item keysContainer

    anchors.fill: keysContainer
    z: keysContainer.z + 1
    visible: keysContainer.visible
    preventStealing: true
    function keyAt(x, y)
    {
        var child = keysContainer
        var posChild = {"x": x, "y": y}
        while (child) {
            child = child.childAt(posChild.x, posChild.y)
            if (!child) {
                return null
            } else if (child && child.objectName == "characterKey") {
                return child
            }
            posChild = keysContainer.mapToItem(child, posChild.x, posChild.y)
        }
    }
    property variant currentChild
    onPressed: {
        var newChild = keyAt(mouse.x, mouse.y)
        if (newChild && newChild.pressed) {
            currentChild = newChild
            currentChild.pressed(mouse)
        } else {
            mouse.accepted = false
        }
    }
    onReleased: {
        if (currentChild && currentChild.released && (!accentsPopup.visible || currentChild.accents.length == 0)) {
            currentChild.released(mouse)
        }
    }
    onClicked: {
        if (currentChild && currentChild.clicked) {
            currentChild.clicked(mouse)
        }
        accentsPopup.visible = false
    }
    onPressAndHold: {
        if (currentChild && currentChild.pressAndHold) {
            var eaten = currentChild.pressAndHold(mouse)
            if (eaten && currentChild.canceled) {
                currentChild.canceled()
            }
        }
    }
    onPositionChanged: {
        var newChild = keyAt(mouse.x, mouse.y)
        if (newChild && newChild != currentChild) {
            if (currentChild && currentChild.exited) {
                currentChild.exited(mouse)
            }
            if (currentChild && currentChild.pressed) {
                currentChild = newChild
                currentChild.pressed(mouse)
            }
        }
    }
    onCanceled: {
        if (currentChild && currentChild.canceled) {
            currentChild.canceled()
        }
    }
    onExited: {
        if (currentChild && currentChild.exited) {
            currentChild.exited()
        }
    }
}

