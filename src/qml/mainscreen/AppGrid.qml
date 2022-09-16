import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtFeedback 5.0

import Ducky 1.0

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

import "../scripts/desktop.js" as Desktop

GridView {
    id: appgrid
    width: root.width
    height: root.height
    cellWidth: switcherModel.itemCount > 4 ? width / Math.ceil(Math.sqrt(switcherModel.itemCount)) : width / 2
    cellHeight: switcherModel.itemCount > 4 ? height / Math.ceil(Math.sqrt(switcherModel.itemCount)) : height / 2
    model: switcherModel
    interactive: false
    delegate: Item {
        width: appgrid.cellWidth
        height: appgrid.cellHeight

        Rectangle {
            id: dimItem
            anchors.fill: parent
            anchors.margins: Screen.pixelDensity
            color: "white"
            opacity: 0.6
        }

        WindowPixmapItem {
            id: windowPixmap
            anchors.fill: parent
            anchors.margins: Screen.pixelDensity
            windowId: model.window
            smooth: true
            opacity: 1
        }

        MouseArea {
            anchors.fill: parent
            property int threshold: 5 * Screen.pixelDensity
            property Item _mapTo: root
            onClicked: {
                Lipstick.compositor.animateInById(model.window);
            }
        }
    }
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }
}