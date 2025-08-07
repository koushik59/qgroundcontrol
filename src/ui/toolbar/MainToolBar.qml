// /****************************************************************************
//  *
//  * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
//  *
//  * QGroundControl is licensed according to the terms in the file
//  * COPYING.md in the root of the source code directory.
//  *
//  ****************************************************************************/

// // import QtQuick          2.12
// import QtQuick 2.15
// import QtQuick.Controls 2.4
// import QtQuick.Layouts  1.11
// // import QtQuick.Layouts 1.15
// import QtQuick.Dialogs  1.3
// import QGroundControl.Controls 1.0
// import "qrc:/custom"

// import QGroundControl                       1.0
// import QGroundControl.Controls              1.0
// import QGroundControl.Palette               1.0
// import QGroundControl.MultiVehicleManager   1.0
// import QGroundControl.ScreenTools           1.0
// import QGroundControl.Controllers           1.0

// Rectangle {
//     id:     _root
//     color:  qgcPal.toolbarBackground

//     property int currentToolbar: flyViewToolbar

//     readonly property int flyViewToolbar:   0
//     readonly property int planViewToolbar:  1
//     readonly property int simpleToolbar:    2

//     property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
//     property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
//     property color  _mainStatusBGColor: qgcPal.brandingPurple

//     function dropMessageIndicatorTool() {
//         if (currentToolbar === flyViewToolbar) {
//             indicatorLoader.item.dropMessageIndicatorTool();
//         }
//     }

//     QGCPalette { id: qgcPal }

//     /// Bottom single pixel divider
//     Rectangle {
//         anchors.left:   parent.left
//         anchors.right:  parent.right
//         anchors.bottom: parent.bottom
//         height:         1
//         color:          "black"
//         visible:        qgcPal.globalTheme === QGCPalette.Light
//     }

//     Rectangle {
//         anchors.fill:   viewButtonRow
//         visible:        currentToolbar === flyViewToolbar

//         gradient: Gradient {
//             orientation: Gradient.Horizontal
//             GradientStop { position: 0;                                     color: _mainStatusBGColor }
//             GradientStop { position: currentButton.x + currentButton.width; color: _mainStatusBGColor }
//             GradientStop { position: 1;                                     color: _root.color }
//         }
//     }

//     RowLayout {
//         id:                     viewButtonRow
//         anchors.bottomMargin:   1
//         anchors.top:            parent.top
//         anchors.bottom:         parent.bottom
//         spacing:                ScreenTools.defaultFontPixelWidth / 2

//         QGCToolBarButton {
//             id:                     currentButton
//             Layout.preferredHeight: viewButtonRow.height
//             icon.source:            "/res/QGCLogoFull"
//             logo:                   true
//             onClicked:              mainWindow.showToolSelectDialog()
//         }

//         MainStatusIndicator {
//             Layout.preferredHeight: viewButtonRow.height
//             visible:                currentToolbar === flyViewToolbar
//         }

//         QGCButton {
//             id:                 disconnectButton
//             text:               qsTr("Disconnect")
//             onClicked:          _activeVehicle.closeVehicle()
//             visible:            _activeVehicle && _communicationLost && currentToolbar === flyViewToolbar
//         }
//     }

//     QGCFlickable {
//         id:                     toolsFlickable
//         anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
//         anchors.left:           viewButtonRow.right
//         anchors.bottomMargin:   1
//         anchors.top:            parent.top
//         anchors.bottom:         parent.bottom
//         anchors.right:          parent.right
//         contentWidth:           indicatorLoader.x + indicatorLoader.width
//         flickableDirection:     Flickable.HorizontalFlick

//         Loader {
//             id:                 indicatorLoader
//             anchors.left:       parent.left
//             anchors.top:        parent.top
//             anchors.bottom:     parent.bottom
//             source:             currentToolbar === flyViewToolbar ?
//                                     "qrc:/toolbar/MainToolBarIndicators.qml" :
//                                     (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
//         }
//     }

//     //-------------------------------------------------------------------------
//     //-- Branding Logo
//     Image {
//         anchors.right:          parent.right
//         anchors.top:            parent.top
//         anchors.bottom:         parent.bottom
//         anchors.margins:        ScreenTools.defaultFontPixelHeight * 0.66
//         visible:                currentToolbar !== planViewToolbar && _activeVehicle && !_communicationLost && x > (toolsFlickable.x + toolsFlickable.contentWidth + ScreenTools.defaultFontPixelWidth)
//         fillMode:               Image.PreserveAspectFit
//         source:                 _outdoorPalette ? _brandImageOutdoor : _brandImageIndoor
//         mipmap:                 true

//         property bool   _outdoorPalette:        qgcPal.globalTheme === QGCPalette.Light
//         property bool   _corePluginBranding:    QGroundControl.corePlugin.brandImageIndoor.length != 0
//         property string _userBrandImageIndoor:  QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor.value
//         property string _userBrandImageOutdoor: QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor.value
//         property bool   _userBrandingIndoor:    _userBrandImageIndoor.length != 0
//         property bool   _userBrandingOutdoor:   _userBrandImageOutdoor.length != 0
//         property string _brandImageIndoor:      brandImageIndoor()
//         property string _brandImageOutdoor:     brandImageOutdoor()

//         function brandImageIndoor() {
//             if (_userBrandingIndoor) {
//                 return _userBrandImageIndoor
//             } else {
//                 if (_userBrandingOutdoor) {
//                     return _userBrandingOutdoor
//                 } else {
//                     if (_corePluginBranding) {
//                         return QGroundControl.corePlugin.brandImageIndoor
//                     } else {
//                         return _activeVehicle ? _activeVehicle.brandImageIndoor : ""
//                     }
//                 }
//             }
//         }

//         function brandImageOutdoor() {
//             if (_userBrandingOutdoor) {
//                 return _userBrandingOutdoor
//             } else {
//                 if (_userBrandingIndoor) {
//                     return _userBrandingIndoor
//                 } else {
//                     if (_corePluginBranding) {
//                         return QGroundControl.corePlugin.brandImageOutdoor
//                     } else {
//                         return _activeVehicle ? _activeVehicle.brandImageOutdoor : ""
//                     }
//                 }
//             }
//         }
//     }

//     // Small parameter download progress bar
//     Rectangle {
//         anchors.bottom: parent.bottom
//         height:         _root.height * 0.05
//         width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
//         color:          qgcPal.colorGreen
//         visible:        !largeProgressBar.visible
//     }

//     // Large parameter download progress bar
//     Rectangle {
//         id:             largeProgressBar
//         anchors.bottom: parent.bottom
//         anchors.left:   parent.left
//         anchors.right:  parent.right
//         height:         parent.height
//         color:          qgcPal.window
//         visible:        _showLargeProgress

//         property bool _initialDownloadComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : true
//         property bool _userHide:                false
//         property bool _showLargeProgress:       !_initialDownloadComplete && !_userHide && qgcPal.globalTheme === QGCPalette.Light

//         Connections {
//             target:                 QGroundControl.multiVehicleManager
//             function onActiveVehicleChanged(activeVehicle) { largeProgressBar._userHide = false }
//         }

//         Rectangle {
//             anchors.top:    parent.top
//             anchors.bottom: parent.bottom
//             width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
//             color:          qgcPal.colorGreen
//         }

//         QGCLabel {
//             anchors.centerIn:   parent
//             text:               qsTr("Downloading")
//             font.pointSize:     ScreenTools.largeFontPointSize
//         }

//         QGCLabel {
//             anchors.margins:    _margin
//             anchors.right:      parent.right
//             anchors.bottom:     parent.bottom
//             text:               qsTr("Click anywhere to hide")

//             property real _margin: ScreenTools.defaultFontPixelWidth / 2
//         }

//         MouseArea {
//             anchors.fill:   parent
//             onClicked:      largeProgressBar._userHide = true
//         }
//     }

//     QGCButton {
//         id: customStatusButton
//         text: "Vehicle Status"
//         anchors.top: parent.top
//         anchors.right: parent.right
//         anchors.margins: 8
//         height: 50

//         onClicked: {
//             statusDialog.open()
//         }
//     }

//     Popup {
//         id: statusDialog
//         x: parent.width - width - 20
//         y: customStatusButton.height + 20
//         width: 250
//         height: 180
//         modal: true  // Optional: enables background blocking
//         focus: true  // Ensures keyboard input (if needed)

//         background: Rectangle {
//             color: "#262626"
//             radius: 8
//         }

//         contentItem: Column {
//             anchors.centerIn: parent
//             spacing: 10
//             padding: 10

//             Text {
//                 text: "GPS: " + (QGroundControl.multiVehicleManager.activeVehicle ?
//                                  QGroundControl.multiVehicleManager.activeVehicle.gps.count.valueString : "N/A")
//                 color: "white"
//             }

//             Text {
//                 text: "Battery: " + (QGroundControl.multiVehicleManager.activeVehicle ?
//                                          QGroundControl.multiVehicleManager.activeVehicle.battery.percentRemaining.valueString +
//                                                                  QGroundControl.multiVehicleManager.activeVehicle.battery.percentRemaining.units : "N/A")
//                 color: "white"
//             }

//             Text {
//                 text: "Mode: " + (QGroundControl.multiVehicleManager.activeVehicle ?
//                                    QGroundControl.multiVehicleManager.activeVehicle.flightMode : "N/A")
//                 color: "white"
//             }

//             QGCButton {
//                 text: "Close"
//                 onClicked: statusDialog.close()
//             }
//         }
//     }



// // After the existing Vehicle Status button (around line 220), add this:

//     // REMOVE THIS DUPLICATE SECTION:
//     QGCButton {
//         id: customStatusButton  // This ID already exists above!
//         text: "Vehicle Status"
//         anchors.top: parent.top
//         anchors.right: parent.right
//         anchors.margins: 8
//         height: 50

//         onClicked: {
//             statusDialog.open()
//         }
//     }
//     // KEEP ONLY THIS SECTION (make sure there's only ONE of this):
//     Row {
//         id: topRightControls
//         anchors.top: parent.top
//         anchors.right: parent.right
//         anchors.margins: 8
//         height: 50
//         spacing: 8

//         // User info display
//         Rectangle {
//             width: userInfoRow.width + 16
//             height: parent.height
//             color: Qt.rgba(0, 0, 0, 0.3)
//             radius: 4

//             Row {
//                 id: userInfoRow
//                 anchors.centerIn: parent
//                 spacing: 4

//                 QGCLabel {
//                     text: "User:"
//                     color: "white"
//                     anchors.verticalCenter: parent.verticalCenter
//                 }

//                 QGCLabel {
//                     text: QGroundControl.settingsManager.appSettings.userLoginRole.rawValue
//                     color: "white"
//                     font.bold: true
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//             }
//         }

//         // Separator
//         Rectangle {
//             width: 1
//             height: parent.height * 0.6
//             color: qgcPal.text
//             opacity: 0.5
//             anchors.verticalCenter: parent.verticalCenter
//         }

//         // Vehicle Status button
//         QGCButton {
//             id: vehicleStatusButton  // Make sure this ID is unique
//             text: "Vehicle Status"
//             height: parent.height

//             onClicked: {
//                 statusDialog.open()
//             }
//         }

//         // Separator
//         Rectangle {
//             width: 1
//             height: parent.height * 0.6
//             color: qgcPal.text
//             opacity: 0.5
//             anchors.verticalCenter: parent.verticalCenter
//         }

//         // Logout button
//         LogoutButton {
//             id: logoutBtn
//             height: parent.height
//         }
//     }

// }


//second code

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

// import QtQuick 2.15
// import QtQuick.Controls 2.4
// import QtQuick.Layouts 1.11
// import QtQuick.Dialogs 1.3
// import QGroundControl.Controls 1.0

// import QGroundControl 1.0
// import QGroundControl.Controls 1.0
// import QGroundControl.Palette 1.0
// import QGroundControl.MultiVehicleManager 1.0
// import QGroundControl.ScreenTools 1.0
// import QGroundControl.Controllers 1.0

// Rectangle {
//     id:     _root
//     color:  qgcPal.toolbarBackground

//     property int currentToolbar: flyViewToolbar

//     readonly property int flyViewToolbar:   0
//     readonly property int planViewToolbar:  1
//     readonly property int simpleToolbar:    2

//     property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
//     property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
//     property color  _mainStatusBGColor: qgcPal.brandingPurple

//     function dropMessageIndicatorTool() {
//         if (currentToolbar === flyViewToolbar) {
//             indicatorLoader.item.dropMessageIndicatorTool();
//         }
//     }

//     QGCPalette { id: qgcPal }

//     /// Bottom single pixel divider
//     Rectangle {
//         anchors.left:   parent.left
//         anchors.right:  parent.right
//         anchors.bottom: parent.bottom
//         height:         1
//         color:          "black"
//         visible:        qgcPal.globalTheme === QGCPalette.Light
//     }

//     Rectangle {
//         anchors.fill:   viewButtonRow
//         visible:        currentToolbar === flyViewToolbar

//         gradient: Gradient {
//             orientation: Gradient.Horizontal
//             GradientStop { position: 0;                                     color: _mainStatusBGColor }
//             GradientStop { position: currentButton.x + currentButton.width; color: _mainStatusBGColor }
//             GradientStop { position: 1;                                     color: _root.color }
//         }
//     }

//     RowLayout {
//         id:                     viewButtonRow
//         anchors.bottomMargin:   1
//         anchors.top:            parent.top
//         anchors.bottom:         parent.bottom
//         spacing:                ScreenTools.defaultFontPixelWidth / 2

//         QGCToolBarButton {
//             id:                     currentButton
//             Layout.preferredHeight: viewButtonRow.height
//             icon.source:            "/res/QGCLogoFull"
//             logo:                   true
//             onClicked:              mainWindow.showToolSelectDialog()
//         }

//         MainStatusIndicator {
//             Layout.preferredHeight: viewButtonRow.height
//             visible:                currentToolbar === flyViewToolbar
//         }

//         QGCButton {
//             id:                 disconnectButton
//             text:               qsTr("Disconnect")
//             onClicked:          _activeVehicle.closeVehicle()
//             visible:            _activeVehicle && _communicationLost && currentToolbar === flyViewToolbar
//         }
//     }

//     QGCFlickable {
//         id:                     toolsFlickable
//         anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
//         anchors.left:           viewButtonRow.right
//         anchors.bottomMargin:   1
//         anchors.top:            parent.top
//         anchors.bottom:         parent.bottom
//         anchors.right:          parent.right
//         contentWidth:           indicatorLoader.x + indicatorLoader.width
//         flickableDirection:     Flickable.HorizontalFlick

//         Loader {
//             id:                 indicatorLoader
//             anchors.left:       parent.left
//             anchors.top:        parent.top
//             anchors.bottom:     parent.bottom
//             source:             currentToolbar === flyViewToolbar ?
//                                     "qrc:/toolbar/MainToolBarIndicators.qml" :
//                                     (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
//         }
//     }

//     //-------------------------------------------------------------------------
//     //-- Branding Logo
//     Image {
//         anchors.right:          parent.right
//         anchors.top:            parent.top
//         anchors.bottom:         parent.bottom
//         anchors.margins:        ScreenTools.defaultFontPixelHeight * 0.66
//         visible:                currentToolbar !== planViewToolbar && _activeVehicle && !_communicationLost && x > (toolsFlickable.x + toolsFlickable.contentWidth + ScreenTools.defaultFontPixelWidth)
//         fillMode:               Image.PreserveAspectFit
//         source:                 _outdoorPalette ? _brandImageOutdoor : _brandImageIndoor
//         mipmap:                 true

//         property bool   _outdoorPalette:        qgcPal.globalTheme === QGCPalette.Light
//         property bool   _corePluginBranding:    QGroundControl.corePlugin.brandImageIndoor.length != 0
//         property string _userBrandImageIndoor:  QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor.value
//         property string _userBrandImageOutdoor: QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor.value
//         property bool   _userBrandingIndoor:    _userBrandImageIndoor.length != 0
//         property bool   _userBrandingOutdoor:   _userBrandImageOutdoor.length != 0
//         property string _brandImageIndoor:      brandImageIndoor()
//         property string _brandImageOutdoor:     brandImageOutdoor()

//         function brandImageIndoor() {
//             if (_userBrandingIndoor) {
//                 return _userBrandImageIndoor
//             } else {
//                 if (_userBrandingOutdoor) {
//                     return _userBrandingOutdoor
//                 } else {
//                     if (_corePluginBranding) {
//                         return QGroundControl.corePlugin.brandImageIndoor
//                     } else {
//                         return _activeVehicle ? _activeVehicle.brandImageIndoor : ""
//                     }
//                 }
//             }
//         }

//         function brandImageOutdoor() {
//             if (_userBrandingOutdoor) {
//                 return _userBrandingOutdoor
//             } else {
//                 if (_userBrandingIndoor) {
//                     return _userBrandingIndoor
//                 } else {
//                     if (_corePluginBranding) {
//                         return QGroundControl.corePlugin.brandImageOutdoor
//                     } else {
//                         return _activeVehicle ? _activeVehicle.brandImageOutdoor : ""
//                     }
//                 }
//             }
//         }
//     }

//     // Small parameter download progress bar
//     Rectangle {
//         anchors.bottom: parent.bottom
//         height:         _root.height * 0.05
//         width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
//         color:          qgcPal.colorGreen
//         visible:        !largeProgressBar.visible
//     }

//     // Large parameter download progress bar
//     Rectangle {
//         id:             largeProgressBar
//         anchors.bottom: parent.bottom
//         anchors.left:   parent.left
//         anchors.right:  parent.right
//         height:         parent.height
//         color:          qgcPal.window
//         visible:        _showLargeProgress

//         property bool _initialDownloadComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : true
//         property bool _userHide:                false
//         property bool _showLargeProgress:       !_initialDownloadComplete && !_userHide && qgcPal.globalTheme === QGCPalette.Light

//         Connections {
//             target:                 QGroundControl.multiVehicleManager
//             function onActiveVehicleChanged(activeVehicle) { largeProgressBar._userHide = false }
//         }

//         Rectangle {
//             anchors.top:    parent.top
//             anchors.bottom: parent.bottom
//             width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
//             color:          qgcPal.colorGreen
//         }

//         QGCLabel {
//             anchors.centerIn:   parent
//             text:               qsTr("Downloading")
//             font.pointSize:     ScreenTools.largeFontPointSize
//         }

//         QGCLabel {
//             anchors.margins:    _margin
//             anchors.right:      parent.right
//             anchors.bottom:     parent.bottom
//             text:               qsTr("Click anywhere to hide")

//             property real _margin: ScreenTools.defaultFontPixelWidth / 2
//         }

//         MouseArea {
//             anchors.fill:   parent
//             onClicked:      largeProgressBar._userHide = true
//         }
//     }

//     // Top right controls row with all buttons
//     // Row {
//     //     id: topRightControls
//     //     anchors.top: parent.top
//     //     anchors.right: parent.right
//     //     anchors.margins: 8
//     //     height: 40
//     //     spacing: 8

//     //     // User info display
//     //     Rectangle {
//     //         width: userInfoRow.width + 16
//     //         height: parent.height
//     //         color: Qt.rgba(0, 0, 0, 0.3)
//     //         radius: 4

//     //         Row {
//     //             id: userInfoRow
//     //             anchors.centerIn: parent
//     //             spacing: 4

//     //             QGCLabel {
//     //                 text: "User:"
//     //                 color: "white"
//     //                 anchors.verticalCenter: parent.verticalCenter
//     //             }

//     //             QGCLabel {
//     //                 text: QGroundControl.settingsManager.appSettings.userLoginRole.rawValue
//     //                 color: "white"
//     //                 font.bold: true
//     //                 anchors.verticalCenter: parent.verticalCenter
//     //             }
//     //         }
//     //     }

//     //     // Separator
//     //     Rectangle {
//     //         width: 1
//     //         height: parent.height * 0.6
//     //         color: qgcPal.text
//     //         opacity: 0.5
//     //         anchors.verticalCenter: parent.verticalCenter
//     //     }

//     //     // Custom Dashboard button
//     //     QGCButton {
//     //         id: customDashboardButton
//     //         text: "Dashboard"
//     //         height: parent.height

//     //         onClicked: {
//     //             dashboardDialog.open()
//     //         }
//     //     }

//     //     // Separator
//     //     Rectangle {
//     //         width: 1
//     //         height: parent.height * 0.6
//     //         color: qgcPal.text
//     //         opacity: 0.5
//     //         anchors.verticalCenter: parent.verticalCenter
//     //     }

//     //     // Logout button
//     //     QGCButton {
//     //         id: logoutBtn
//     //         text: qsTr("Logout")
//     //         height: parent.height

//     //         onClicked: {
//     //             logoutConfirmDialog.open()
//     //         }
//     //     }
//     // }
//     //^

//     // Update the topRightControls Row with yellow theme
//     Row {
//         id: topRightControls
//         anchors.verticalCenter: parent.verticalCenter
//         anchors.right: parent.right
//         anchors.rightMargin: 8
//         height: parent.height - 8
//         spacing: 6

//         // User info display with yellow theme
//         Rectangle {
//             height: parent.height - 4
//             width: userInfoRow.width + 12
//             color: "#000000"
//             border.color: "#FFD700"
//             border.width: 1
//             radius: height / 2

//             Row {
//                 id: userInfoRow
//                 anchors.centerIn: parent
//                 spacing: 4

//                 Text {
//                     text: "USER:"
//                     color: "#FFD700"
//                     font.pointSize: ScreenTools.smallFontPointSize
//                     font.bold: true
//                     anchors.verticalCenter: parent.verticalCenter
//                 }

//                 Text {
//                     text: QGroundControl.settingsManager.appSettings.userLoginRole.rawValue.toUpperCase()
//                     color: "#FFFFFF"
//                     font.bold: true
//                     font.pointSize: ScreenTools.smallFontPointSize
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//             }
//         }

//         // Dashboard button with yellow theme
//         Rectangle {
//             width: 90
//             height: parent.height - 4
//             color: "transparent"
//             border.color: "#FFD700"
//             border.width: 2
//             radius: height / 2

//             MouseArea {
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 onEntered: parent.color = "#FFD700"
//                 onExited: parent.color = "transparent"
//                 onClicked: dashboardDialog.open()

//                 Text {
//                     anchors.centerIn: parent
//                     text: "DASHBOARD"
//                     color: parent.parent.color == "#FFD700" ? "#ffffff" : "#FFD700"
//                     font.bold: true
//                     font.pointSize: ScreenTools.smallFontPointSize
//                 }
//             }
//         }

//         // Logout button with yellow theme
//         Rectangle {
//             width: 70
//             height: parent.height - 4
//             color: "transparent"
//             border.color: "#FFD700"
//             border.width: 2
//             radius: height / 2

//             MouseArea {
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 onEntered: parent.color = "#FFD700"
//                 onExited: parent.color = "transparent"
//                 onClicked: logoutConfirmDialog.open()

//                 Text {
//                     anchors.centerIn: parent
//                     text: "LOGOUT"
//                     color: parent.parent.color == "#FFD700" ? "#ffffff" : "#FFD700"
//                     font.bold: true
//                     font.pointSize: ScreenTools.smallFontPointSize
//                 }
//             }
//         }
//     }


// //working model-1
//     // // Custom Dashboard Popup
//     // Popup {
//     //     id: dashboardDialog
//     //     x: parent.width - width - 20
//     //     y: topRightControls.height + topRightControls.y + 10
//     //     width: 300
//     //     height: 250
//     //     modal: true
//     //     focus: true

//     //     background: Rectangle {
//     //         color: "#262626"
//     //         radius: 8
//     //         border.color: "#444444"
//     //         border.width: 1
//     //     }

//     //     contentItem: Column {
//     //         anchors.fill: parent
//     //         anchors.margins: 15
//     //         spacing: 15

//     //         // Title
//     //         Text {
//     //             text: "Flight Dashboard"
//     //             color: "white"
//     //             font.pixelSize: 18
//     //             font.bold: true
//     //             anchors.horizontalCenter: parent.horizontalCenter
//     //         }

//     //         // Separator line
//     //         Rectangle {
//     //             width: parent.width
//     //             height: 1
//     //             color: "#444444"
//     //         }

//     //         // GPS Status
//     //         Row {
//     //             spacing: 10
//     //             QGCLabel {
//     //                 text: "GPS:"
//     //                 color: "#888888"
//     //                 width: 80
//     //             }
//     //             QGCLabel {
//     //                 text: _activeVehicle ? _activeVehicle.gps.count.valueString + " Sats" : "N/A"
//     //                 color: _activeVehicle && _activeVehicle.gps.count.value >= 6 ? "#00ff00" : "#ff0000"
//     //                 font.bold: true
//     //             }
//     //         }

//     //         // Battery Status
//     //         Row {
//     //             spacing: 10
//     //             QGCLabel {
//     //                 text: "Battery:"
//     //                 color: "#888888"
//     //                 width: 80
//     //             }
//     //             QGCLabel {
//     //                 text: _activeVehicle ?
//     //                       _activeVehicle.battery.percentRemaining.valueString + _activeVehicle.battery.percentRemaining.units :
//     //                       "N/A"
//     //                 color: {
//     //                     if (!_activeVehicle) return "#888888"
//     //                     var percent = _activeVehicle.battery.percentRemaining.value
//     //                     if (percent > 50) return "#00ff00"
//     //                     else if (percent > 20) return "#ffaa00"
//     //                     else return "#ff0000"
//     //                 }
//     //                 font.bold: true
//     //             }
//     //         }

//     //         // Flight Mode
//     //         Row {
//     //             spacing: 10
//     //             QGCLabel {
//     //                 text: "Mode:"
//     //                 color: "#888888"
//     //                 width: 80
//     //             }
//     //             QGCLabel {
//     //                 text: _activeVehicle ? _activeVehicle.flightMode : "N/A"
//     //                 color: "#00aaff"
//     //                 font.bold: true
//     //             }
//     //         }

//     //         // Altitude
//     //         Row {
//     //             spacing: 10
//     //             QGCLabel {
//     //                 text: "Altitude:"
//     //                 color: "#888888"
//     //                 width: 80
//     //             }
//     //             QGCLabel {
//     //                 text: _activeVehicle ?
//     //                       _activeVehicle.altitudeRelative.valueString + _activeVehicle.altitudeRelative.units :
//     //                       "N/A"
//     //                 color: "white"
//     //                 font.bold: true
//     //             }
//     //         }

//     //         // Close button
//     //         QGCButton {
//     //             text: "Close"
//     //             anchors.horizontalCenter: parent.horizontalCenter
//     //             onClicked: dashboardDialog.close()
//     //         }
//     //     }
//     // }



//     // Custom Dashboard Popup with Yellow/Black Theme
//     Popup {
//         id: dashboardDialog
//         x: parent.width - width - 20
//         y: topRightControls.height + topRightControls.y + 10
//         width: 350
//         height: 320
//         modal: true
//         focus: true

//         background: Rectangle {
//             color: "#000000"
//             radius: 15
//             border.color: "#FFD700"  // Gold yellow border
//             border.width: 2

//             // Add subtle gradient
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: "#1a1a1a" }
//                 GradientStop { position: 1.0; color: "#000000" }
//             }
//         }

//         contentItem: Column {
//             anchors.fill: parent
//             anchors.margins: 20
//             spacing: 15

//             // Title Section
//             Rectangle {
//                 width: parent.width
//                 height: 40
//                 color: "#FFD700"
//                 radius: 8

//                 Row {
//                     anchors.centerIn: parent
//                     spacing: 10

//                     // Drone Icon
//                     Text {
//                         text: "\uf5b0"
//                         font.family: "Font Awesome 5 Free"
//                         font.pixelSize: 24
//                         color: "#000000"
//                         font.bold: true
//                     }

//                     Text {
//                         text: "FLIGHT DASHBOARD"
//                         color: "#000000"
//                         font.pixelSize: 18
//                         font.bold: true
//                         font.letterSpacing: 1
//                     }
//                 }
//             }

//             // Main Content Area
//             Rectangle {
//                 width: parent.width
//                 height: 190
//                 color: "transparent"

//                 Grid {
//                     columns: 2
//                     spacing: 15
//                     width: parent.width

//                     // GPS Indicator
//                     Rectangle {
//                         width: 150
//                         height: 80
//                         color: "#000000"
//                         border.color: "#FFD700"
//                         border.width: 1
//                         radius: 10

//                         Column {
//                             anchors.centerIn: parent
//                             spacing: 5

//                             // GPS Icon with dynamic color
//                             Rectangle {
//                                 width: 36
//                                 height: 36
//                                 radius: 18
//                                 color: _activeVehicle && _activeVehicle.gps.count.value >= 6 ? "#FFD700" : "#444444"
//                                 anchors.horizontalCenter: parent.horizontalCenter

//                                 Text {
//                                     anchors.centerIn: parent
//                                     text: "\uf3c5"  // Satellite icon
//                                     font.family: "Font Awesome 5 Free"
//                                     font.pixelSize: 20
//                                     color: "#ffffff"
//                                     font.bold: true
//                                 }
//                             }

//                             Text {
//                                 text: "GPS"
//                                 color: "#FFD700"
//                                 font.pixelSize: 10
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }

//                             Text {
//                                 text: _activeVehicle ? _activeVehicle.gps.count.valueString + " SATS" : "NO GPS"
//                                 color: _activeVehicle && _activeVehicle.gps.count.value >= 6 ? "#00FF00" : "#FF0000"
//                                 font.pixelSize: 12
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }
//                         }
//                     }

//                     // Battery Indicator
//                     Rectangle {
//                         width: 150
//                         height: 80
//                         color: "#1a1a1a"
//                         border.color: "#FFD700"
//                         border.width: 1
//                         radius: 10

//                         Column {
//                             anchors.centerIn: parent
//                             spacing: 5

//                             // Battery level visual
//                             Rectangle {
//                                 width: 40
//                                 height: 20
//                                 border.color: "#FFD700"
//                                 border.width: 2
//                                 radius: 3
//                                 color: "transparent"
//                                 anchors.horizontalCenter: parent.horizontalCenter

//                                 Rectangle {
//                                     x: 2
//                                     y: 2
//                                     width: _activeVehicle ? (parent.width - 4) * (_activeVehicle.battery.percentRemaining.value / 100) : 0
//                                     height: parent.height - 4
//                                     color: {
//                                         if (!_activeVehicle) return "#444444"
//                                         var percent = _activeVehicle.battery.percentRemaining.value
//                                         if (percent > 50) return "#00FF00"
//                                         else if (percent > 20) return "#FFD700"
//                                         else return "#FF0000"
//                                     }
//                                     radius: 2
//                                 }
//                             }

//                             Text {
//                                 text: "BATTERY"
//                                 color: "#FFD700"
//                                 font.pixelSize: 10
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }

//                             Text {
//                                 text: _activeVehicle ? _activeVehicle.battery.percentRemaining.valueString + "%" : "N/A"
//                                 color: {
//                                     if (!_activeVehicle) return "#444444"
//                                     var percent = _activeVehicle.battery.percentRemaining.value
//                                     if (percent > 50) return "#00FF00"
//                                     else if (percent > 20) return "#FFD700"
//                                     else return "#FF0000"
//                                 }
//                                 font.pixelSize: 16
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }
//                         }
//                     }

//                     // Flight Mode Indicator
//                     Rectangle {
//                         width: 150
//                         height: 80
//                         color: "#1a1a1a"
//                         border.color: "#FFD700"
//                         border.width: 1
//                         radius: 10

//                         Column {
//                             anchors.centerIn: parent
//                             spacing: 5

//                             Rectangle {
//                                 width: 36
//                                 height: 36
//                                 radius: 18
//                                 color: "#FFD700"
//                                 anchors.horizontalCenter: parent.horizontalCenter

//                                 Text {
//                                     anchors.centerIn: parent
//                                     text: "\uf072"  // Plane icon
//                                     font.family: "Font Awesome 5 Free"
//                                     font.pixelSize: 20
//                                     color: "#000000"
//                                     font.bold: true
//                                 }
//                             }

//                             Text {
//                                 text: "MODE"
//                                 color: "#FFD700"
//                                 font.pixelSize: 10
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }

//                             Text {
//                                 text: _activeVehicle ? _activeVehicle.flightMode : "NONE"
//                                 color: "#FFFFFF"
//                                 font.pixelSize: 12
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }
//                         }
//                     }

//                     // Altitude Indicator
//                     Rectangle {
//                         width: 150
//                         height: 80
//                         color: "#1a1a1a"
//                         border.color: "#FFD700"
//                         border.width: 1
//                         radius: 10

//                         Column {
//                             anchors.centerIn: parent
//                             spacing: 5

//                             Rectangle {
//                                 width: 36
//                                 height: 36
//                                 radius: 18
//                                 color: "#FFD700"
//                                 anchors.horizontalCenter: parent.horizontalCenter

//                                 Text {
//                                     anchors.centerIn: parent
//                                     text: "\uf062"  // Arrow up
//                                     font.family: "Font Awesome 5 Free"
//                                     font.pixelSize: 20
//                                     color: "#000000"
//                                     font.bold: true
//                                 }
//                             }

//                             Text {
//                                 text: "ALTITUDE"
//                                 color: "#FFD700"
//                                 font.pixelSize: 10
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }

//                             Text {
//                                 text: _activeVehicle ? _activeVehicle.altitudeRelative.valueString + " m" : "0 m"
//                                 color: "#FFFFFF"
//                                 font.pixelSize: 14
//                                 font.bold: true
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                             }
//                         }
//                     }
//                 }
//             }

//             // Close button
//             Rectangle {
//                 width: 100
//                 height: 35
//                 color: "transparent"
//                 border.color: "#FFD700"
//                 border.width: 2
//                 radius: 17
//                 anchors.horizontalCenter: parent.horizontalCenter

//                 MouseArea {
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     onEntered: parent.color = "#FFD700"
//                     onExited: parent.color = "transparent"
//                     onClicked: dashboardDialog.close()

//                     Text {
//                         anchors.centerIn: parent
//                         text: "CLOSE"
//                         color: parent.parent.color == "#FFD700" ? "#ffffff" : "#FFD700"
//                         font.bold: true
//                         font.pixelSize: 12
//                     }
//                 }
//             }
//         }
//     }

//     // Logout confirmation dialog
//     MessageDialog {
//         id: logoutConfirmDialog
//         title: qsTr("Logout Confirmation")
//         text: qsTr("Are you sure you want to logout?")
//         standardButtons: StandardButton.Yes | StandardButton.No

//         onYes: {
//             if (typeof CustomPlugin !== 'undefined' && CustomPlugin) {
//                 CustomPlugin.logout()
//             }
//         }
//     }
// }


/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.3
import QGroundControl.Controls 1.0

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Palette 1.0
import QGroundControl.MultiVehicleManager 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Controllers 1.0
import QtGraphicalEffects 1.12

Rectangle {
    id:     _root
    color:  qgcPal.toolbarBackground

    property int currentToolbar: flyViewToolbar

    readonly property int flyViewToolbar:   0
    readonly property int planViewToolbar:  1
    readonly property int simpleToolbar:    2

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property color  _mainStatusBGColor: qgcPal.brandingPurple

    function dropMessageIndicatorTool() {
        if (currentToolbar === flyViewToolbar) {
            indicatorLoader.item.dropMessageIndicatorTool();
        }
    }

    QGCPalette { id: qgcPal }

    /// Bottom single pixel divider
    Rectangle {
        anchors.left:   parent.left
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        height:         1
        color:          "black"
        visible:        qgcPal.globalTheme === QGCPalette.Light
    }

    Rectangle {
        anchors.fill:   viewButtonRow
        visible:        currentToolbar === flyViewToolbar

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0;                                     color: _mainStatusBGColor }
            GradientStop { position: currentButton.x + currentButton.width; color: _mainStatusBGColor }
            GradientStop { position: 1;                                     color: _root.color }
        }
    }

    RowLayout {
        id:                     viewButtonRow
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        spacing:                ScreenTools.defaultFontPixelWidth / 2

        QGCToolBarButton {
            id:                     currentButton
            Layout.preferredHeight: viewButtonRow.height
            icon.source:            "/res/QGCLogoFull"
            logo:                   true
            onClicked:              mainWindow.showToolSelectDialog()
        }

        MainStatusIndicator {
            Layout.preferredHeight: viewButtonRow.height
            visible:                currentToolbar === flyViewToolbar
        }

        QGCButton {
            id:                 disconnectButton
            text:               qsTr("Disconnect")
            onClicked:          _activeVehicle.closeVehicle()
            visible:            _activeVehicle && _communicationLost && currentToolbar === flyViewToolbar
        }
    }

    QGCFlickable {
        id:                     toolsFlickable
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
        anchors.left:           viewButtonRow.right
        anchors.bottomMargin:   1
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.right:          parent.right
        contentWidth:           indicatorLoader.x + indicatorLoader.width
        flickableDirection:     Flickable.HorizontalFlick

        Loader {
            id:                 indicatorLoader
            anchors.left:       parent.left
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             currentToolbar === flyViewToolbar ?
                                    "qrc:/toolbar/MainToolBarIndicators.qml" :
                                    (currentToolbar == planViewToolbar ? "qrc:/qml/PlanToolBarIndicators.qml" : "")
        }
    }

    //-------------------------------------------------------------------------
    //-- Branding Logo
    Image {
        anchors.right:          parent.right
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.margins:        ScreenTools.defaultFontPixelHeight * 0.66
        visible:                currentToolbar !== planViewToolbar && _activeVehicle && !_communicationLost && x > (toolsFlickable.x + toolsFlickable.contentWidth + ScreenTools.defaultFontPixelWidth)
        fillMode:               Image.PreserveAspectFit
        source:                 _outdoorPalette ? _brandImageOutdoor : _brandImageIndoor
        mipmap:                 true

        property bool   _outdoorPalette:        qgcPal.globalTheme === QGCPalette.Light
        property bool   _corePluginBranding:    QGroundControl.corePlugin.brandImageIndoor.length != 0
        property string _userBrandImageIndoor:  QGroundControl.settingsManager.brandImageSettings.userBrandImageIndoor.value
        property string _userBrandImageOutdoor: QGroundControl.settingsManager.brandImageSettings.userBrandImageOutdoor.value
        property bool   _userBrandingIndoor:    _userBrandImageIndoor.length != 0
        property bool   _userBrandingOutdoor:   _userBrandImageOutdoor.length != 0
        property string _brandImageIndoor:      brandImageIndoor()
        property string _brandImageOutdoor:     brandImageOutdoor()

        function brandImageIndoor() {
            if (_userBrandingIndoor) {
                return _userBrandImageIndoor
            } else {
                if (_userBrandingOutdoor) {
                    return _userBrandingOutdoor
                } else {
                    if (_corePluginBranding) {
                        return QGroundControl.corePlugin.brandImageIndoor
                    } else {
                        return _activeVehicle ? _activeVehicle.brandImageIndoor : ""
                    }
                }
            }
        }

        function brandImageOutdoor() {
            if (_userBrandingOutdoor) {
                return _userBrandingOutdoor
            } else {
                if (_userBrandingIndoor) {
                    return _userBrandingIndoor
                } else {
                    if (_corePluginBranding) {
                        return QGroundControl.corePlugin.brandImageOutdoor
                    } else {
                        return _activeVehicle ? _activeVehicle.brandImageOutdoor : ""
                    }
                }
            }
        }
    }

    // Small parameter download progress bar
    Rectangle {
        anchors.bottom: parent.bottom
        height:         _root.height * 0.05
        width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
        color:          qgcPal.colorGreen
        visible:        !largeProgressBar.visible
    }

    // Large parameter download progress bar
    Rectangle {
        id:             largeProgressBar
        anchors.bottom: parent.bottom
        anchors.left:   parent.left
        anchors.right:  parent.right
        height:         parent.height
        color:          qgcPal.window
        visible:        _showLargeProgress

        property bool _initialDownloadComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : true
        property bool _userHide:                false
        property bool _showLargeProgress:       !_initialDownloadComplete && !_userHide && qgcPal.globalTheme === QGCPalette.Light

        Connections {
            target:                 QGroundControl.multiVehicleManager
            function onActiveVehicleChanged(activeVehicle) { largeProgressBar._userHide = false }
        }

        Rectangle {
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            width:          _activeVehicle ? _activeVehicle.loadProgress * parent.width : 0
            color:          qgcPal.colorGreen
        }

        QGCLabel {
            anchors.centerIn:   parent
            text:               qsTr("Downloading")
            font.pointSize:     ScreenTools.largeFontPointSize
        }

        QGCLabel {
            anchors.margins:    _margin
            anchors.right:      parent.right
            anchors.bottom:     parent.bottom
            text:               qsTr("Click anywhere to hide")

            property real _margin: ScreenTools.defaultFontPixelWidth / 2
        }

        MouseArea {
            anchors.fill:   parent
            onClicked:      largeProgressBar._userHide = true
        }
    }

    // Update the topRightControls Row with yellow theme
    Row {
        id: topRightControls
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        height: parent.height - 8
        spacing: 6

        // User info display with yellow theme
        Rectangle {
            height: parent.height - 4
            width: userInfoRow.width + 12
            color: "#000000"
            border.color: "#FFD700"
            border.width: 1
            radius: height / 2

            Row {
                id: userInfoRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: "USER:"
                    color: "#FFD700"
                    font.pointSize: ScreenTools.smallFontPointSize
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: QGroundControl.settingsManager.appSettings.userLoginRole.rawValue.toUpperCase()
                    color: "#FFFFFF"
                    font.bold: true
                    font.pointSize: ScreenTools.smallFontPointSize
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Dashboard button with yellow theme
        Rectangle {
            width: 90
            height: parent.height - 4
            color: "transparent"
            border.color: "#FFD700"
            border.width: 2
            radius: height / 2

            property bool isHovered: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = "#FFD700"
                    parent.isHovered = true
                }
                onExited: {
                    parent.color = "transparent"
                    parent.isHovered = false
                }
                onClicked: dashboardDialog.open()

                Text {
                    anchors.centerIn: parent
                    text: "DASHBOARD"
                    color: parent.parent.isHovered ? "#000000" : "#FFD700"
                    font.bold: true
                    font.pointSize: ScreenTools.smallFontPointSize
                }
            }
        }

        // Logout button with yellow theme
        Rectangle {
            width: 70
            height: parent.height - 4
            color: "transparent"
            border.color: "#FFD700"
            border.width: 2
            radius: height / 2

            property bool isHovered: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.color = "#FFD700"
                    parent.isHovered = true
                }
                onExited: {
                    parent.color = "transparent"
                    parent.isHovered = false
                }
                onClicked: logoutConfirmDialog.open()

                Text {
                    anchors.centerIn: parent
                    text: "LOGOUT"
                    color: parent.parent.isHovered ? "#000000" : "#FFD700"
                    font.bold: true
                    font.pointSize: ScreenTools.smallFontPointSize
                }
            }
        }
    }

    // Custom Dashboard Popup with Yellow/Black Theme
    Popup {
        id: dashboardDialog
        x: parent.width - width - 20
        y: topRightControls.height + topRightControls.y + 10
        width: 350
        height: 320
        modal: true
        focus: true
        parent: _root  // Explicitly set parent

        background: Rectangle {
            color: "#000000"
            radius: 15
            border.color: "#FFD700"  // Gold yellow border
            border.width: 2

            // Add subtle gradient
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1a1a1a" }
                GradientStop { position: 1.0; color: "#000000" }
            }
        }

        contentItem: Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Title Section
            Rectangle {
                width: parent.width
                height: 40
                color: "#FFD700"
                radius: 8

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    // Drone Icon
                    Text {
                        text: "\uf5b0"
                        font.family: "Font Awesome 5 Free"
                        font.pixelSize: 24
                        color: "#000000"
                        font.bold: true
                    }

                    Text {
                        text: "FLIGHT DASHBOARD"
                        color: "#000000"
                        font.pixelSize: 18
                        font.bold: true
                        font.letterSpacing: 1
                    }
                }
            }

            // Main Content Area
            Rectangle {
                width: parent.width
                height: 190
                color: "transparent"

                Grid {
                    columns: 2
                    spacing: 15
                    width: parent.width

                    // GPS Indicator
                    Rectangle {
                        width: 150
                        height: 80
                        color: "#000000"
                        border.color: "#FFD700"
                        border.width: 1
                        radius: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            // GPS Icon with dynamic color
                            Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                                color: _activeVehicle && _activeVehicle.gps.count.value >= 6 ? "#FFD700" : "#444444"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf3c5"  // Satellite icon
                                    font.family: "Font Awesome 5 Free"
                                    font.pixelSize: 20
                                    color: "#ffffff"
                                    font.bold: true
                                }
                            }

                            Text {
                                text: "GPS"
                                color: "#FFD700"
                                font.pixelSize: 10
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: _activeVehicle ? _activeVehicle.gps.count.valueString + " SATS" : "NO GPS"
                                color: _activeVehicle && _activeVehicle.gps.count.value >= 6 ? "#00FF00" : "#FF0000"
                                font.pixelSize: 12
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // Battery Indicator
                    Rectangle {
                        width: 150
                        height: 80
                        color: "#1a1a1a"
                        border.color: "#FFD700"
                        border.width: 1
                        radius: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            // Battery level visual
                            Rectangle {
                                width: 40
                                height: 20
                                border.color: "#FFD700"
                                border.width: 2
                                radius: 3
                                color: "transparent"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Rectangle {
                                    x: 2
                                    y: 2
                                    width: _activeVehicle ? (parent.width - 4) * (_activeVehicle.battery.percentRemaining.value / 100) : 0
                                    height: parent.height - 4
                                    color: {
                                        if (!_activeVehicle) return "#444444"
                                        var percent = _activeVehicle.battery.percentRemaining.value
                                        if (percent > 50) return "#00FF00"
                                        else if (percent > 20) return "#FFD700"
                                        else return "#FF0000"
                                    }
                                    radius: 2
                                }
                            }

                            Text {
                                text: "BATTERY"
                                color: "#FFD700"
                                font.pixelSize: 10
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: _activeVehicle ? _activeVehicle.battery.percentRemaining.valueString + "%" : "N/A"
                                color: {
                                    if (!_activeVehicle) return "#444444"
                                    var percent = _activeVehicle.battery.percentRemaining.value
                                    if (percent > 50) return "#00FF00"
                                    else if (percent > 20) return "#FFD700"
                                    else return "#FF0000"
                                }
                                font.pixelSize: 16
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // Flight Mode Indicator
                    Rectangle {
                        width: 150
                        height: 80
                        color: "#1a1a1a"
                        border.color: "#FFD700"
                        border.width: 1
                        radius: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                                color: "#FFD700"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf072"  // Plane icon
                                    font.family: "Font Awesome 5 Free"
                                    font.pixelSize: 20
                                    color: "#000000"
                                    font.bold: true
                                }
                            }

                            Text {
                                text: "MODE"
                                color: "#FFD700"
                                font.pixelSize: 10
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: _activeVehicle ? _activeVehicle.flightMode : "NONE"
                                color: "#FFFFFF"
                                font.pixelSize: 12
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }

                    // Altitude Indicator
                    Rectangle {
                        width: 150
                        height: 80
                        color: "#1a1a1a"
                        border.color: "#FFD700"
                        border.width: 1
                        radius: 10

                        Column {
                            anchors.centerIn: parent
                            spacing: 5

                            Rectangle {
                                width: 36
                                height: 36
                                radius: 18
                                color: "#FFD700"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "\uf062"  // Arrow up
                                    font.family: "Font Awesome 5 Free"
                                    font.pixelSize: 20
                                    color: "#000000"
                                    font.bold: true
                                }
                            }

                            Text {
                                text: "ALTITUDE"
                                color: "#FFD700"
                                font.pixelSize: 10
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: _activeVehicle ? _activeVehicle.altitudeRelative.valueString + " m" : "0 m"
                                color: "#FFFFFF"
                                font.pixelSize: 14
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // Close button
            Rectangle {
                width: 100
                height: 35
                color: "transparent"
                border.color: "#FFD700"
                border.width: 2
                radius: 17
                anchors.horizontalCenter: parent.horizontalCenter

                property bool isHovered: false

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.color = "#FFD700"
                        parent.isHovered = true
                    }
                    onExited: {
                        parent.color = "transparent"
                        parent.isHovered = false
                    }
                    onClicked: dashboardDialog.close()

                    Text {
                        anchors.centerIn: parent
                        text: "CLOSE"
                        color: parent.parent.isHovered ? "#000000" : "#FFD700"
                        font.bold: true
                        font.pixelSize: 12
                    }
                }
            }
        }
    }

    // Dashboard refresh timer
    Timer {
        interval: 1000  // Update every second
        running: dashboardDialog.visible
        repeat: true
        onTriggered: {
            // Values automatically update through bindings
        }
    }

    // Logout confirmation dialog
    MessageDialog {
        id: logoutConfirmDialog
        title: qsTr("Logout Confirmation")
        text: qsTr("Are you sure you want to logout?")
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            if (typeof CustomPlugin !== 'undefined' && CustomPlugin) {
                CustomPlugin.logout()
            }
        }
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    // Remove the DropShadow effect that's causing issues
    /*
    DropShadow {
        anchors.fill: dashboardDialog
        source: dashboardDialog
        radius: 8
        samples: 16
        color: "#80000000"
    }
    */
}
