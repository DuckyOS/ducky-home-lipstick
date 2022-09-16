import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtFeedback 5.0

import Ducky 1.0

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

import "mainscreen"
import "scripts/desktop.js" as Desktop

Page {
    id: root
    focus: true
    width: Screen.width
    height: Screen.height
    visible: true
    background: Rectangle {
        color: "transparent"
    }

    DuckyWindowModel {
        id: switcherModel
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

    Wallpaper {
        id: wallpaperItem
	    anchors.fill: parent
        z: 1
    }

    Item {
        id: backgroundShader
        opacity: 0
        anchors.fill: wallpaperItem
        z: 5
        FastBlur {
            id: blurItem
            source: wallpaperItem
            anchors.fill: parent
            radius: 64
        }

        Rectangle {
            opacity: 0.6
            anchors.fill: parent
            color: "black"
        }
    }

    StatusBar {
        id: statusbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        z: 10
    }

    SwipeView{
        id: homeSwipe
        interactive: true
        anchors.top: statusbar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        property bool onFeedPage: false
        property bool handleIndex: false
        z: 10

        contentItem: ListView {
            model: homeSwipe.contentModel
            interactive: homeSwipe.interactive
            currentIndex: homeSwipe.currentIndex

            spacing: homeSwipe.spacing
            orientation: homeSwipe.orientation
            snapMode: ListView.SnapOneItem
            boundsBehavior: Flickable.StopAtBounds

            highlightRangeMode: ListView.StrictlyEnforceRange
            preferredHighlightBegin: 0
            preferredHighlightEnd: 0
            highlightMoveDuration: 250

            maximumFlickVelocity: 4 * (homeSwipe.orientation === 
            Qt.Horizontal ? width : height)

            onContentXChanged: {
                let x1 = (Math.abs(contentX) % (2*root.width)) / root.width;
                backgroundShader.opacity = x1 < 1 ? x1 : 2 - x1;
            }
        }
        
        Component.onCompleted: {
            appgridComponent.createObject(homeSwipe, {});
            feedPageComponent.createObject(homeSwipe, {});
            appgridComponent.createObject(homeSwipe, {});
            feedPageComponent.createObject(homeSwipe, {});
            homeSwipe.currentIndex = 2;
            homeSwipe.handleIndex = true;
        }

        onCurrentIndexChanged: {
            if (!homeSwipe.handleIndex) return;
            if (currentIndex == 1) {
                homeSwipe.handleIndex = false;
                insertItem(0, takeItem(3));
                currentIndex = 2;
                homeSwipe.handleIndex = true;
            } else if (currentIndex == 3) {
                homeSwipe.handleIndex = false;
                moveItem(0,4);
                currentIndex = 2;
                homeSwipe.handleIndex = true;
            }
        }
    }

    Component {
        id: feedPageComponent
        FeedPage {}
    }

    Component {
        id: appgridComponent
        AppGrid {}
    }
}
