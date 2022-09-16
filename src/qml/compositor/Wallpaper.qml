import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15

import org.nemomobile.lipstick 0.1
import org.nemomobile.configuration 1.0

Item {
    id: wallpaper

    ConfigurationValue {
        id: wallpaperSource
        key: "/home/ducky/homeScreen/wallpaper"
        defaultValue: "/usr/share/lipstick-ducky-home-qt5/qml/images/wallpaper.jpg"
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

    Image {
        id: wallpaperImage
        anchors.fill: parent
        source: wallpaperSource.value
        fillMode: Image.PreserveAspectCrop
    }
}