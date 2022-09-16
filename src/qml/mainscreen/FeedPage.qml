import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtFeedback 5.0

import Ducky 1.0

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

import "../scripts/desktop.js" as Desktop

Item {
    id: feedPage
    width: root.width
    height: root.height

    Label {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 5 * Screen.pixelDensity
        anchors.topMargin: 3 * Screen.pixelDensity
        text: "Notifications"
        font.pixelSize: 5 * Screen.pixelDensity
        font.weight: Font.Light
        color: "white"
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
}