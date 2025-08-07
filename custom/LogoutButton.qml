import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0

QGCButton {
    id: logoutButton
    text: qsTr("Logout")
    
    property var qgcPal: QGCPalette { colorGroupEnabled: enabled }
    
    onClicked: {
        logoutDialog.open()
    }
    
    // Confirmation dialog
    MessageDialog {
        id: logoutDialog
        title: qsTr("Logout Confirmation")
        text: qsTr("Are you sure you want to logout?")
        standardButtons: StandardButton.Yes | StandardButton.No
        icon: StandardIcon.Question
        
        onYes: {
            // Call the logout function
            if (typeof CustomPlugin !== 'undefined' && CustomPlugin) {
                CustomPlugin.logout()
            }
        }
    }
}