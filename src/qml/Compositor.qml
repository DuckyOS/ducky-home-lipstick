// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQml.Models 2.15
import QtFeedback 5.0

import org.nemomobile.lipstick 0.1
import org.nemomobile.devicelock 1.0
import org.nemomobile.configuration 1.0

import "compositor"
import "scripts/desktop.js" as Desktop

Item {
    id: root
    anchors.fill: parent

    HapticsEffect {
        id: rumbleEffect
        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 100
        fadeTime: 250
        fadeIntensity: 0.0
    }

    Wallpaper {
        id: wallpaperItem
        width: parent.width
        height: parent.height
        transformOrigin: Item.Center
	    anchors.centerIn: parent
    }

    Component.onCompleted: {
        Desktop.compositor = root
    }

    Item {
        id: layersParent
        anchors.fill: parent

        Item {
            id: homeLayer
            z: 1
            anchors.fill: parent
            opacity: LipstickSettings.lockscreenVisible ? 0 : 1

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        Item {
            id: appLayer
            z: 2
            opacity: LipstickSettings.lockscreenVisible ? 0 : 1

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        Item {
            id: overlayLayer
            z: 5
        }

        Item {
            id: notificationLayer
            z: 8
        }
        Item {
            id: alarmsLayer
            z: 3
        }
    }

    Component {
        id: windowWrapper
        WindowWrapperBase {
        }
    }

    Compositor {
        id: comp

        property Item homeWindow
        property Item topmostWindow
        property Item topmostApplicationWindow

        homeActive: topmostWindow == homeWindow 
        screenOrientation: Qt.PortraitOrientation
	    topmostWindowOrientation: screenOrientation

        onSensorOrientationChanged: {
            screenOrientation = sensorOrientation;
        }

        onScreenOrientationChanged: {
            orientationConfig.value = screenOrientation;
        }

        function animateInById(winId) {
            var o = comp.windowForId(winId);
            var window = null;

            if (o) {
                window = o.userData;
            }

            if (window == null) return;

            if (comp.topmostWindow) 
                if (!comp.homeActive) comp.topmostWindow.animateOut();
            setCurrentWindow(window);
            window.animateIn();
        }

        function setCurrentWindow(w) {
            if (w == null) {
                w = homeWindow
            }

            if (w.window.title !== "maliit-server") {
                topmostWindow = w;
            }

            if (topmostWindow == homeWindow || topmostWindow == null) {
                clearKeyboardFocus();
            } else {
                topmostApplicationWindow = topmostWindow;
                topmostApplicationWindow.visible = true;

                if (w.window) w.window.takeFocus();
            }
        }

        onWindowAdded: {
            console.log("Compositor: Window added \"" + window.title + "\"" + " category: " + window.category);

            var isHomeWindow = window.isInProcess && comp.homeWindow == null && window.title === "Home";
            var isDialogWindow = window.category == "dialog";
            var isNotificationWindow = window.category == "notification";
            var isOverlayWindow = window.category == "overlay" || window.title === "maliit-server";
            var isAlarmWindow = window.category == "alarm"

            var parent = null;
            if (isHomeWindow) {
                parent = homeLayer;
            } else if (isNotificationWindow) {
                parent = notificationLayer;
            } else if (isOverlayWindow) {
                parent = overlayLayer;
            } else if (isAlarmWindow) {
                parent = alarmsLayer;
            } else {
                parent = appLayer;
            }

            var w;
            w = windowWrapper.createObject(parent, { window: window });
            window.userData = w;

            if (isHomeWindow) {
                comp.homeWindow = w
                animateInById(w.window.windowId);
            } else if (isNotificationWindow) {
            } else if (isOverlayWindow) {
            } else if (isDialogWindow) {
            } else if (isAlarmWindow) {
                animateInById(w.window.windowId);
            } else {
                animateInById(w.window.windowId); 
            }

            appLauncher.close();
        }   

        onWindowRemoved: {
            if (window == topmostWindow.window) {
                comp.animateInById(comp.homeWindow.window.windowId);
            }
        }     
    }

    MouseArea {
        id: gestureArea
        rotation: Screen.angleBetween(comp.screenOrientation, Screen.primaryOrientation)
        width: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? parent.width : parent.height)
        height: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? parent.height : parent.width)
        transformOrigin: Item.Center
	    anchors.centerIn: parent
        z: 7

        property int boundary: 2 * Screen.pixelDensity
        property int threshold: 15 * Screen.pixelDensity

        property bool active: gesture != ""
        property string gesture

        property Item _mapTo: gestureArea
        
        onPressed: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);
            
            if (mouseReal.y < boundary && (mouseReal.x < _mapTo.width / 4 || mouseReal.x > 3 * _mapTo.width / 4)) {
                gesture = "close";
                if (!comp.homeActive) {
                    comp.topmostWindow.oMaskItem.visible = true;
                    comp.topmostWindow.window.visible = false;
                }
            } else if (mouseReal.x < boundary) {
                gesture = "left";
                if (!comp.homeActive) {
                    comp.topmostWindow.oMaskItem.visible = true;
                    comp.topmostWindow.window.visible = false;
                }
            } else if (mouseReal.x > _mapTo.width - boundary) {
                gesture = "right";
                if (!comp.homeActive) {
                    comp.topmostWindow.oMaskItem.visible = true;
                    comp.topmostWindow.window.visible = false;
                }
            } else {
                mouse.accepted = false;
            }
        }

        onReleased: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);

            if (gesture == "close") {
                if (!comp.homeActive && mouseReal.y > threshold) {
                    comp.topmostApplicationWindow.slideDown();
                } else if (!comp.homeActive) {
                    comp.topmostApplicationWindow.resetDown();
                }
            } else if (gesture == "left") {
                if (!comp.homeActive && mouseReal.x > threshold) {
                    comp.topmostApplicationWindow.slideRight();
                } else if (!comp.homeActive) {
                    comp.topmostApplicationWindow.resetRight();
                }
            } else if (gesture == "right") {
                if (!comp.homeActive && mouseReal.x < _mapTo.width - threshold) {
                    comp.topmostApplicationWindow.slideLeft();
                } else if (!comp.homeActive) {
                    comp.topmostApplicationWindow.resetLeft();
                }
            } else {
                mouse.accepted = false;
            }

            gesture = "";
        }

        onPositionChanged: {
            var mouseReal = mapToItem(_mapTo, mouse.x, mouse.y);

            if (gesture == "close") {
                if (!comp.homeActive) {
                    comp.topmostApplicationWindow.oMaskItem.opacity = 1 - mouseReal.y / _mapTo.height;
                    comp.topmostApplicationWindow.oMaskItem.clipY = mouseReal.y;
                    comp.topmostApplicationWindow.oMaskItem.clipH = _mapTo.height - mouseReal.y;
                }
            } else if (gesture == "left") {
                if (!comp.homeActive) {
                    comp.topmostApplicationWindow.oMaskItem.opacity = 1 - mouseReal.x / _mapTo.width;
                    comp.topmostApplicationWindow.oMaskItem.clipX = mouseReal.x;
                    comp.topmostApplicationWindow.oMaskItem.clipW = _mapTo.width - mouseReal.x;
                }
            } else if (gesture == "right") {
                if (!comp.homeActive) {
                    comp.topmostApplicationWindow.oMaskItem.opacity = mouseReal.x / _mapTo.width;
                    comp.topmostApplicationWindow.oMaskItem.clipW = mouseReal.x;
                }
            }
        }
    }

    AppLauncher {
        id: appLauncher
        wallpaperItem: root
        z: 6
    }

    Connections {
        target: Lipstick.compositor
        function onDisplayOff() {
            appLauncher.close();
        }
    }

    function setLockScreen(enabled) {
        if (enabled) {
            LipstickSettings.lockscreenVisible = true
        } else {
            LipstickSettings.lockscreenVisible = false
        }
    }

    LockScreen {
        id: lockScreen
        z: 7
        rotation: Screen.angleBetween(comp.screenOrientation, Screen.primaryOrientation)
        width: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? parent.width : parent.height)
        height: ((comp.screenOrientation == Qt.PortraitOrientation || 
            comp.screenOrientation == Qt.InvertedPortraitOrientation) 
            ? parent.height : parent.width)

        Component.onCompleted: {
            setLockScreen(true);
        }
    }
}
