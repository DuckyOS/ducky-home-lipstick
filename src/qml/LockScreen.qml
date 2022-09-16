import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Window 2.15

import org.nemomobile.lipstick 0.1

import "compositor"

Item {
    id: root
    x: 0
    y: 0
    visible: LipstickSettings.lockscreenVisible === true

    function timeChanged() {
        lockscreenTime.text = Qt.formatDateTime(new Date(), "HH:mm");
        lockscreenDate.text = Qt.formatDateTime(new Date(), "dddd, MMMM d");
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Behavior on rotation {
        RotationAnimator { 
            duration: 200
            direction: RotationAnimator.Shortest
        }
    }

    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    Behavior on width {
        NumberAnimation { duration: 200 }
    }

    FastBlur {
        id: blurItem
        source: wallpaperItem
        anchors.fill: parent
        radius: 64
    }

    Rectangle {
        x: 0
        y: 0
        width: root.width
        height: root.height
        color: "black"
        opacity: 0.5
    }

    Item {
        id: contentItem
        x: 0
        y: 0
        width: root.width
        height: root.height

        Wallpaper {
            anchors.fill: contentItem
        }


        StatusBar {
            id: statusbar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            z: 10
        }

        Text { 
            id: lockscreenTime
            color: "white"
            text: Qt.formatDateTime(new Date(), "HH:mm")
            font.pixelSize: 15 * Screen.pixelDensity
            font.family: "Lato"
            font.weight: Font.Light
            anchors { centerIn: parent }
        }

        DropShadow {
            anchors.fill: lockscreenTime
            source: lockscreenTime
            verticalOffset: 3
            color: "#80000000"
            radius: 3
            samples: 3
        }

        Text { 
            id: lockscreenDate
            color: "white"
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
            font.pixelSize: 3 * Screen.pixelDensity
            font.family: "Lato"
            font.weight: Font.Black
            anchors { right: lockscreenTime.right; top: lockscreenTime.bottom }
        }

        DropShadow {
            anchors.fill: lockscreenDate
            source: lockscreenDate
            verticalOffset: 3
            color: "#80000000"
            radius: 3
            samples: 3
        }

        Timer {
            interval: 100; running: true; repeat: true;
            onTriggered: timeChanged()
        }

        ParallelAnimation {
            id: slideLeftAnimation
            NumberAnimation { 
                target: root; 
                property: "opacity";
                running: false
                from: 1
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: contentItem; 
                property: "x";
                running: false
                from: contentItem.x
                to: -root.width
                duration: 200 
            }


            onFinished: {
                LipstickSettings.lockscreenVisible = false;
                root.opacity = 1.0;
                contentItem.x = 0;
            }
        }

        ParallelAnimation {
            id: slideRightAnimation
            NumberAnimation { 
                target: root; 
                property: "opacity";
                running: false
                from: 1
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: contentItem; 
                property: "x";
                running: false
                from: contentItem.x
                to: root.width
                duration: 200 
            }

            onFinished: {
                LipstickSettings.lockscreenVisible = false;
                root.opacity = 1.0;
                contentItem.x = 0;
            }
        }

        ParallelAnimation {
            id: resetAnimation
            NumberAnimation { 
                target: root; 
                property: "opacity";
                running: false
                from: root.opacity
                to: 1
                duration: 200 
            }
            
            NumberAnimation { 
                target: contentItem; 
                property: "x";
                running: false
                from: contentItem.x
                to: 0
                duration: 200 
            }

            onFinished: {
                root.opacity = 1.0;
                contentItem.x = 0;
            }
        }

        MouseArea {
            id: gestureArea
            anchors.fill: parent

            property int threshold: 25 * Screen.pixelDensity

            property int origX
            property int origY

            property bool active: gesture != ""
            property string gesture

            property Item _mapTo: root

            onPressed: {
                var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);
                gesture = "start";
                origX = mouseReal.x;
                origY = mouseReal.y;
            }

            onReleased: {
                var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);
                if (Math.abs(mouseReal.x - origX) > threshold) {
                    if (gesture == "left") {
                        slideLeftAnimation.start()
                    } else if (gesture == "right") {
                        slideRightAnimation.start()
                    } 
                } else {
                    resetAnimation.start()
                }
                gesture = "";
            }

            onPositionChanged: {
                var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);
                if (gesture != "") {
                    if (mouseReal.x < origX) {
                        gesture = "left";
                    } else if (mouseReal.x > origX) {
                        gesture = "right";
                    }
                } 
                
                if (gesture == "left" || gesture == "right") {
                    contentItem.x = mouseReal.x - origX;
                }
            }
        }
    }
}
