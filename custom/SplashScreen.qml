// import QtQuick 2.15
// import QtQuick.Window 2.15

// Window {
//     id: splashWindow
//     width: 800
//     height: 600
//     flags: Qt.SplashScreen
//     color: "black"
//     visible: true
//     title: "Splash"

//     Image {
//         anchors.fill: parent
//         source: "qrc:/custom/img/custom_splash.png"
//         fillMode: Image.PreserveAspectCrop
//         cache: false
//     }

//     Timer {
//         interval: 3000
//         running: true
//         repeat: false
//         onTriggered: {
//             splashWindow.close()
//             if (mainWindow) {
//                 mainWindow.showNormal()
//                 mainWindow.raise()
//                 mainWindow.requestActivate()
//             }
//         }
//     }

//     property var mainWindow
// }

import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: splashWindow
    width: 800
    height: 600
    flags: Qt.SplashScreen
    color: "black"
    visible: true
    title: "Splash"

    signal splashDone()  // <== define this signal

    Image {
        anchors.fill: parent
        source: "qrc:/custom/img/custom_splash.png"
        fillMode: Image.PreserveAspectCrop
        cache: false
    }

    Timer {
        interval: 3000
        running: true
        repeat: false
        onTriggered: {
            splashWindow.close()
            splashDone()   // <== emit the signal
        }
    }
}
