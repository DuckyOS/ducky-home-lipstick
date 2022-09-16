import QtQuick 2.15
import QtGraphicalEffects 1.15

import org.nemomobile.lipstick 0.1

Item {
    id: wrapper

    property Item window
    property Item oMaskItem: oMask
    width: window !== null ? window.width : 0
    height: window !== null ? window.height : 0
    NumberAnimation on opacity { 
        id: fadeInAnimation
        running: false
        from: 0
        to: 1
        duration: 200 

        onStarted: {
            wrapper.visible = true;
        }
    }
    NumberAnimation on opacity { 
        id: fadeOutAnimation
        running: false
        from: oMask.opacity
        to: 0
        duration: 200 

        onFinished: {
            wrapper.visible = false;
        }
    }
    function animateIn() { fadeInAnimation.start(); }
    function animateOut() { fadeOutAnimation.start(); }
    function slideLeft() { slideLeftAnimation.start(); }
    function slideRight() { slideRightAnimation.start(); }
    function slideDown() { slideDownAnimation.start(); }
    function resetLeft() { resetLeftAnimation.start(); }
    function resetRight() { resetRightAnimation.start(); }
    function resetDown() { resetDownAnimation.start(); }

    Component.onCompleted: window.parent = wrapper

    OpacityMask {
        id: oMask
        anchors.fill: wrapper
        source: wrapper.window
        visible: false

        property int clipX: 0
        property int clipY: 0
        property int clipW: wrapper.width
        property int clipH: wrapper.height

        maskSource: Item {
            x: 0
            y: 0
            width: wrapper.width
            height: wrapper.height
            Rectangle {
                color: "black"
                x: oMask.clipX
                y: oMask.clipY
                width: oMask.clipW
                height: oMask.clipH
            }
        }

        ParallelAnimation {
            id: slideLeftAnimation
            NumberAnimation { 
                target: oMask; 
                property: "opacity";
                running: false
                from: oMask.opacity
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipW";
                running: false
                from: oMask.clipW
                to: 0
                duration: 200 
            }

            onFinished: {
                wrapper.visible = false;
                wrapper.window.visible = true;
                oMask.visible = false;
                oMask.clipW = wrapper.width;
                oMask.clipX = 0;
                oMask.opacity = 1.0;

                Lipstick.compositor.setCurrentWindow(Lipstick.compositor.homeWindow);
            }
        }

        ParallelAnimation {
            id: slideRightAnimation
            NumberAnimation { 
                target: oMask; 
                property: "opacity";
                running: false
                from: oMask.opacity
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipW";
                running: false
                from: oMask.clipW
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipX";
                running: false
                from: oMask.clipX
                to: wrapper.width
                duration: 200 
            }

            onFinished: {
                wrapper.visible = false;
                wrapper.window.visible = true;
                oMask.visible = false;
                oMask.clipW = wrapper.width;
                oMask.clipX = 0;
                oMask.opacity = 1.0;

                Lipstick.compositor.setCurrentWindow(Lipstick.compositor.homeWindow);
            }
        }

        ParallelAnimation {
            id: slideDownAnimation
            NumberAnimation { 
                target: oMask; 
                property: "opacity";
                running: false
                from: oMask.opacity
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipH";
                running: false
                from: oMask.clipH
                to: 0
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipY";
                running: false
                from: oMask.clipY
                to: wrapper.height
                duration: 200 
            }

            onFinished: {
                wrapper.visible = false;
                wrapper.window.visible = true;
                oMask.visible = false;
                oMask.clipH = wrapper.width;
                oMask.clipY = 0;
                oMask.opacity = 1.0;

                Lipstick.compositor.closeClientForWindowId(wrapper.window.windowId);
            }
        }

        ParallelAnimation {
            id: resetLeftAnimation
            NumberAnimation { 
                target: oMask; 
                property: "opacity";
                running: false
                from: oMask.opacity
                to: 1
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipW";
                running: false
                from: oMask.clipW
                to: wrapper.width
                duration: 200 
            }

            onFinished: {
                wrapper.visible = true;
                wrapper.window.visible = true;
                oMask.visible = false;
                oMask.clipW = wrapper.width;
                oMask.clipX = 0;
                oMask.opacity = 1.0;
            }
        }

        ParallelAnimation {
            id: resetRightAnimation
            NumberAnimation { 
                target: oMask; 
                property: "opacity";
                running: false
                from: oMask.opacity
                to: 1
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipW";
                running: false
                from: oMask.clipW
                to: wrapper.width
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipX";
                running: false
                from: oMask.clipX
                to: 0
                duration: 200 
            }

            onFinished: {
                wrapper.visible = true;
                wrapper.window.visible = true;
                oMask.visible = false;
                oMask.clipW = wrapper.width;
                oMask.clipX = 0;
                oMask.opacity = 1.0;
            }
        }

        ParallelAnimation {
            id: resetDownAnimation
            NumberAnimation { 
                target: oMask; 
                property: "opacity";
                running: false
                from: oMask.opacity
                to: 1
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipH";
                running: false
                from: oMask.clipH
                to: wrapper.height
                duration: 200 
            }
            
            NumberAnimation { 
                target: oMask; 
                property: "clipY";
                running: false
                from: oMask.clipY
                to: 0
                duration: 200 
            }

            onFinished: {
                wrapper.visible = true;
                wrapper.window.visible = true;
                oMask.visible = false;
                oMask.clipH = wrapper.width;
                oMask.clipY = 0;
                oMask.opacity = 1.0;
            }
        }
    }
}