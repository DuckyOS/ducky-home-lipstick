// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Copyright (c) 2017, Eetu Kahelin
// Copyright (c) 2013, Jolla Ltd <robin.burchell@jollamobile.com>
// Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>
// Copyright (c) 2011, Tom Swindell <t.swindell@rubyx.co.uk>

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import org.nemomobile.lipstick 0.1
import QtFeedback 5.0

MouseArea {
    id: root

    property Text iconText: iconText
    property Item iconImage: iconImage

    function handleTap() {
        if (modelData.object.type !== LauncherModel.Folder) {
            rumbleEffect.start();
            modelData.object.launchApplication();
            appLauncher.close();
        }
    }

    onClicked: {
        handleTap();
    }

    HapticsEffect {
        id: rumbleEffect
        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 100
        fadeTime: 250
        fadeIntensity: 0.0
    }

    Item {
        id: iconWrapper
        height: width
        width: parent.width - Screen.pixelDensity * 6
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        Button {
            id: iconImage
            anchors.centerIn: parent
            height: parent.height
            width: parent.width
            background: Item {}
            onClicked: {
                root.handleTap();
            }
            icon.color: "transparent"
            icon.width: parent.width
            icon.height: parent.height
        }
    }

    Text {
        id: iconText
        width: root.width
        height: Screen.pixelDensity * 2
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Screen.pixelDensity * 2
        color: "white"

        wrapMode: Text.WordWrap

        anchors {
            top: iconWrapper.bottom
            topMargin: Screen.pixelDensity
            horizontalCenter: iconWrapper.horizontalCenter
        }
    }
}