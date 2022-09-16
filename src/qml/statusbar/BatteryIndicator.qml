/****************************************************************************************
**
** Copyright (C) 2019-2021 Chupligin Sergey <neochapay@gmail.com>
** Copyright (C) 2022-2022 Erik Inkinen <erik.inkinen@gmail.com>
** All rights reserved.
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
**     * Neither the name of the author nor the
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


import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Nemo.Mce 1.0

import Nemo.Configuration 1.0

Item {
    id: root
    height: 5 * Screen.pixelDensity
    width: batteryIndicator.width + percentageIndicator.width + 1.5 * Screen.pixelDensity
    Rectangle {
        id: batteryIndicator
        color: "transparent"
        border.width: 0.3 * Screen.pixelDensity
        border.color: (batteryChargeState.value == MceBatteryState.Charging) ? "green" : "white"
        height: 0.6 * root.height
        width: 1.2 * root.height

        anchors {
            right: root.right
            verticalCenter: root.verticalCenter    
        }

        Rectangle {
            color: (batteryChargeState.value == MceBatteryState.Charging) ? "green" : "white"
            height: 0.4 * root.height
            width: batteryChargePercentage.percent * root.height / 100

            anchors {
                left: parent.left
                leftMargin: 0.1 * root.height
                verticalCenter: parent.verticalCenter    
            }
        }

        Rectangle {
            color: (batteryChargeState.value == MceBatteryState.Charging) ? "green" : "white"
            height: 0.4 * root.height
            width: 0.075 * root.height

            anchors {
                left: parent.left
                leftMargin: 1.2 * root.height
                verticalCenter: parent.verticalCenter    
            }
        }
    }

    Text { 
        id: percentageIndicator
        color: "white"
        text: batteryChargePercentage.percent + " %"
        font.pixelSize: 2.5 * Screen.pixelDensity
        font.family: "Lato"
        anchors {
            right: batteryIndicator.left
            rightMargin: 1.5 * Screen.pixelDensity
            verticalCenter: root.verticalCenter    
        }
    }

    MceBatteryLevel {
        id: batteryChargePercentage
    }

    MceBatteryState {
        id:  batteryChargeState
    }

    MceCableState{
        id: cableState
    }

    MceBatteryStatus{
        id: batteryStatus
    }

}
