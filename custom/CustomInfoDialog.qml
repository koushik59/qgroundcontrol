// In custom/CustomInfoDialog.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QGroundControl.Controls 1.0
import QGroundControl.Vehicle 1.0
import QGroundControl.ScreenTools 1.0

QGCSimpleMessageDialog {
    id:     _root
    title:  qsTr("Essential Flight Data")

    property var _vehicle: QGroundControl.multiVehicleManager.activeVehicle

    // We provide custom content instead of the standard 'text' property
    text:   "" 

    // Custom content goes here
    Column {
        anchors.fill: parent
        spacing: 15
        anchors.margins: 10

        QGCLabel {
            text: "GPS: " + (_vehicle.gps.count > 0 ? "Fixed (" + _vehicle.gps.count + " sats)" : "No Lock")
            font.pointSize: ScreenTools.defaultFontPointSize * 1.2
        }

        QGCLabel {
            text: "Battery: " + _vehicle.battery.percentRemaining.toFixed(0) + "% (" + _vehicle.battery.voltage.toFixed(2) + "V)"
            font.pointSize: ScreenTools.defaultFontPointSize * 1.2
        }

        QGCLabel {
            text: "Mode: " + _vehicle.flightMode
            font.pointSize: ScreenTools.defaultFontPointSize * 1.2
        }
    }

    // Standard close button for the dialog
    standardButtons: StandardButton.Close
}