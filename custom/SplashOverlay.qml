import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: splashOverlay
    anchors.fill: parent
    color: "#000000"  // Solid black background
    z: 1000  // High z-order to appear on top

    // Splash content
    Column {
        anchors.centerIn: parent
        spacing: 30

        // Logo
        Image {
            source: "/custom/img/CustomAppIcon.png"  // Your splash logo
            width: 150
            height: 150
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }

        // Title
        Text {
            text: "INDRONES"
            color: "#FFD700"
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Subtitle
        Text {
            text: "QGroundControl"
            color: "#FFFFFF"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Loading indicator
        Row {
            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: 3
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: "#FFD700"

                    SequentialAnimation on opacity {
                        running: true
                        loops: Animation.Infinite
                        PauseAnimation { duration: index * 200 }
                        NumberAnimation { to: 0.3; duration: 600 }
                        NumberAnimation { to: 1.0; duration: 600 }
                    }
                }
            }
        }

        Text {
            text: "Loading..."
            color: "#AAAAAA"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
