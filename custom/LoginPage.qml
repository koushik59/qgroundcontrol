// // File: qgroundcontrol/custom/LoginPage.qml

// import QtQuick 2.15
// import QtQuick.Controls 2.15
// import QtQuick.Layouts 1.15

// ApplicationWindow {
//     id: loginWindow
//     visible: true
//     width: 640
//     height: 480
//     title: "Login Page"
//     color: "#f0f0f0"

//     // Step 6: Signal definition
//     signal loginSuccess()

//     ColumnLayout {
//         anchors.centerIn: parent
//         spacing: 16

//         Label {
//             text: "Login"
//             font.pixelSize: 24
//             Layout.alignment: Qt.AlignHCenter
//         }

//         TextField {
//             id: usernameField
//             placeholderText: "Username"
//             Layout.preferredWidth: 300
//         }

//         TextField {
//             id: passwordField
//             placeholderText: "Password"
//             echoMode: TextInput.Password
//             Layout.preferredWidth: 300
//         }

//         Label {
//             id: errorLabel
//             text: ""
//             visible: false
//             color: "red"
//             Layout.alignment: Qt.AlignHCenter
//         }

//         Button {
//             text: "Login"
//             Layout.alignment: Qt.AlignHCenter
//             onClicked: {
//                 if (usernameField.text === "koushik" && passwordField.text === "12345") {
//                     console.log("✅ Login success: Emitting loginSuccess signal")
//                     errorLabel.visible = false
//                     loginSuccess() // Step 6: Signal emitted on valid credentials
//                 } else {
//                     errorLabel.text = "❌ Invalid username or password"
//                     errorLabel.visible = true
//                 }
//             }
//         }
//     }
// }

//final code 1

// import QtQuick 2.12
// import QtQuick.Window 2.12
// import QtQuick.Controls 2.12
// import QtQuick.Layouts 1.12

// Window {
//     id: loginWindow
//     width: 400
//     height: 500
//     title: "QGroundControl Login"
//     flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
//     modality: Qt.ApplicationModal
//     color: "#f0f0f0"
    
//     // Signals
//     signal loginSuccess()
//     signal loginFailed()
    
//     Rectangle {
//         anchors.fill: parent
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: "#f0f0f0" }
//             GradientStop { position: 1.0; color: "#e0e0e0" }
//         }
        
//         ColumnLayout {
//             anchors.centerIn: parent
//             spacing: 20
//             width: 300
            
//             // Logo
//             Image {
//                 source: "/custom/img/CustomAppIcon.png"
//                 Layout.preferredWidth: 100
//                 Layout.preferredHeight: 100
//                 Layout.alignment: Qt.AlignHCenter
//                 fillMode: Image.PreserveAspectFit
//             }
            
//             // Title
//             Text {
//                 text: "QGroundControl Login"
//                 font.pixelSize: 24
//                 font.bold: true
//                 color: "#333333"
//                 Layout.alignment: Qt.AlignHCenter
//             }
            
//             // Username field
//             TextField {
//                 id: usernameField
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 placeholderText: "Username"
//                 font.pixelSize: 14
//                 leftPadding: 10
                
//                 background: Rectangle {
//                     radius: 5
//                     border.color: usernameField.focus ? "#007ACC" : "#cccccc"
//                     border.width: 1
//                 }
//             }
            
//             // Password field
//             TextField {
//                 id: passwordField
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 placeholderText: "Password"
//                 echoMode: TextInput.Password
//                 font.pixelSize: 14
//                 leftPadding: 10
                
//                 background: Rectangle {
//                     radius: 5
//                     border.color: passwordField.focus ? "#007ACC" : "#cccccc"
//                     border.width: 1
//                 }
                
//                 Keys.onReturnPressed: loginButton.clicked()
//             }
            
//             // Error message
//             Text {
//                 id: errorMessage
//                 color: "#e03131"
//                 font.pixelSize: 12
//                 visible: false
//                 Layout.alignment: Qt.AlignHCenter
//                 Layout.topMargin: -10
//             }
            
//             // Login button
//             Button {
//                 id: loginButton
//                 text: "Login"
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 font.pixelSize: 16
//                 font.bold: true
                
//                 background: Rectangle {
//                     color: loginButton.pressed ? "#005a9e" : (loginButton.hovered ? "#0078d4" : "#007ACC")
//                     radius: 5
//                 }
                
//                 contentItem: Text {
//                     text: loginButton.text
//                     font: loginButton.font
//                     color: "white"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                 }
                
//                 onClicked: {
//                     // Validate credentials
//                     if (validateLogin(usernameField.text, passwordField.text)) {
//                         loginWindow.loginSuccess()
//                     } else {
//                         errorMessage.text = "Invalid username or password"
//                         errorMessage.visible = true
//                         passwordField.clear()
//                         passwordField.focus = true
                        
//                         // Hide error message after 3 seconds
//                         errorTimer.restart()
//                     }
//                 }
//             }
            
//             // Cancel button
//             Button {
//                 text: "Cancel"
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 font.pixelSize: 14
                
//                 background: Rectangle {
//                     color: cancelButton.pressed ? "#666666" : (cancelButton.hovered ? "#888888" : "#999999")
//                     radius: 5
//                 }
                
//                 contentItem: Text {
//                     text: cancelButton.text
//                     font: cancelButton.font
//                     color: "white"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                 }
                
//                 id: cancelButton
//                 onClicked: {
//                     loginWindow.loginFailed()
//                 }
//             }
//         }
//     }
    
//     // Timer to hide error message
//     Timer {
//         id: errorTimer
//         interval: 3000
//         onTriggered: errorMessage.visible = false
//     }
    
//     // Login validation function
//     function validateLogin(username, password) {
//         // TODO: Replace with actual authentication logic
//         // This is just a simple example
//         if (username === "admin" && password === "password") {
//             return true
//         }
        
//         // You can add more users or connect to a real authentication system
//         if (username === "pilot" && password === "pilot123") {
//             return true
//         }
        
//         if (username === "engineer" && password === "engineer123") {
//             // Set user role for the showFirmwareUpgrade check
//             // You'll need to store this in your settings
//             return true
//         }
        
//         return false
//     }
    
//     Component.onCompleted: {
//         // Focus on username field when window opens
//         usernameField.focus = true
//     }
// }


// // final code 2
// import QtQuick 2.12
// import QtQuick.Window 2.12
// import QtQuick.Controls 2.12
// import QtQuick.Layouts 1.12

// import QGroundControl 1.0
// import QGroundControl.SettingsManager 1.0

// Window {
//     id: loginWindow
//     width: 400
//     height: 550
//     title: "QGroundControl Login"
//     flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
//     modality: Qt.ApplicationModal
//     color: "#f0f0f0"

//     // Signals
//     signal loginSuccess()
//     signal loginFailed()

//     // Property to store selected role
//     property string selectedRole: "Operator"

//     Rectangle {
//         anchors.fill: parent
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: "#f0f0f0" }
//             GradientStop { position: 1.0; color: "#e0e0e0" }
//         }

//         ColumnLayout {
//             anchors.centerIn: parent
//             spacing: 20
//             width: 300

//             // Logo
//             Image {
//                 source: "/custom/img/CustomAppIcon.png"
//                 Layout.preferredWidth: 100
//                 Layout.preferredHeight: 100
//                 Layout.alignment: Qt.AlignHCenter
//                 fillMode: Image.PreserveAspectFit
//             }

//             // Title
//             Text {
//                 text: "QGroundControl Login"
//                 font.pixelSize: 24
//                 font.bold: true
//                 color: "#333333"
//                 Layout.alignment: Qt.AlignHCenter
//             }

//             // Username field
//             TextField {
//                 id: usernameField
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 placeholderText: "Username"
//                 font.pixelSize: 14
//                 leftPadding: 10

//                 background: Rectangle {
//                     radius: 5
//                     border.color: usernameField.focus ? "#007ACC" : "#cccccc"
//                     border.width: 1
//                 }
//             }

//             // Password field
//             TextField {
//                 id: passwordField
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 placeholderText: "Password"
//                 echoMode: TextInput.Password
//                 font.pixelSize: 14
//                 leftPadding: 10

//                 background: Rectangle {
//                     radius: 5
//                     border.color: passwordField.focus ? "#007ACC" : "#cccccc"
//                     border.width: 1
//                 }

//                 Keys.onReturnPressed: loginButton.clicked()
//             }

//             // Role selection
//             Column {
//                 Layout.fillWidth: true
//                 spacing: 10

//                 Text {
//                     text: "Select Role:"
//                     font.pixelSize: 14
//                     font.bold: true
//                     color: "#333333"
//                 }

//                 RadioButton {
//                     id: operatorRadio
//                     text: "Operator"
//                     checked: true
//                     font.pixelSize: 14

//                     onCheckedChanged: {
//                         if (checked) {
//                             selectedRole = "Operator"
//                         }
//                     }
//                 }

//                 RadioButton {
//                     id: engineerRadio
//                     text: "Engineer"
//                     font.pixelSize: 14

//                     onCheckedChanged: {
//                         if (checked) {
//                             selectedRole = "Engineer"
//                         }
//                     }
//                 }
//             }

//             // Error message
//             Text {
//                 id: errorMessage
//                 color: "#e03131"
//                 font.pixelSize: 12
//                 visible: false
//                 Layout.alignment: Qt.AlignHCenter
//                 Layout.topMargin: -10
//             }

//             // Login button
//             Button {
//                 id: loginButton
//                 text: "Login"
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 font.pixelSize: 16
//                 font.bold: true

//                 background: Rectangle {
//                     color: loginButton.pressed ? "#005a9e" : (loginButton.hovered ? "#0078d4" : "#007ACC")
//                     radius: 5
//                 }

//                 contentItem: Text {
//                     text: loginButton.text
//                     font: loginButton.font
//                     color: "white"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                 }

//                 onClicked: {
//                     // Validate credentials
//                     if (validateLogin(usernameField.text, passwordField.text)) {
//                         // Save the selected role before emitting success
//                         saveUserRole()
//                         loginWindow.loginSuccess()
//                     } else {
//                         errorMessage.text = "Invalid username or password"
//                         errorMessage.visible = true
//                         passwordField.clear()
//                         passwordField.focus = true

//                         // Hide error message after 3 seconds
//                         errorTimer.restart()
//                     }
//                 }
//             }

//             // Cancel button
//             Button {
//                 text: "Cancel"
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 font.pixelSize: 14

//                 background: Rectangle {
//                     color: cancelButton.pressed ? "#666666" : (cancelButton.hovered ? "#888888" : "#999999")
//                     radius: 5
//                 }

//                 contentItem: Text {
//                     text: cancelButton.text
//                     font: cancelButton.font
//                     color: "white"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                 }

//                 id: cancelButton
//                 onClicked: {
//                     loginWindow.loginFailed()
//                 }
//             }
//         }
//     }

//     // Timer to hide error message
//     Timer {
//         id: errorTimer
//         interval: 3000
//         onTriggered: errorMessage.visible = false
//     }

//     // Login validation function
//     function validateLogin(username, password) {
//         // Role-specific validation
//         if (selectedRole === "Operator") {
//             if (username === "operator" && password === "operator123") {
//                 return true
//             }
//         } else if (selectedRole === "Engineer") {
//             if (username === "engineer" && password === "engineer123") {
//                 return true
//             }
//         }

//         // Common admin account works for both roles
//         if (username === "admin" && password === "admin123") {
//             return true
//         }

//         return false
//     }

//     // Function to save user role to settings
//     function saveUserRole() {
//         // Save the role to QGC settings
//         QGroundControl.settingsManager.appSettings.userLoginRole.rawValue = selectedRole
//         console.log("User role saved: " + selectedRole)
//     }

//     Component.onCompleted: {
//         // Focus on username field when window opens
//         usernameField.focus = true
//     }
// }


// //final code 2
// import QtQuick 2.12
// import QtQuick.Window 2.12
// import QtQuick.Controls 2.12
// import QtQuick.Layouts 1.12

// import QGroundControl 1.0
// import QGroundControl.SettingsManager 1.0

// Window {
//     id: loginWindow
//     width: 400
//     height: 450
//     title: "Indrones Login"
//     flags: Qt.Window | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
//     modality: Qt.ApplicationModal
//     color: "#eee718"

//     // Signals
//     signal loginSuccess()
//     signal loginFailed()

//     Rectangle {
//         anchors.fill: parent
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: "#f0f0f0" }
//             GradientStop { position: 1.0; color: "#e0e0e0" }
//         }

//         ColumnLayout {
//             anchors.centerIn: parent
//             spacing: 20
//             width: 300

//             // Logo
//             Image {
//                 source: "/custom/img/CustomAppIcon.png"
//                 Layout.preferredWidth: 100
//                 Layout.preferredHeight: 100
//                 Layout.alignment: Qt.AlignHCenter
//                 fillMode: Image.PreserveAspectFit
//             }

//             // Title
//             Text {
//                 text: "INDRONES Login"
//                 font.pixelSize: 24
//                 font.bold: true
//                 color: "#333333"
//                 Layout.alignment: Qt.AlignHCenter
//             }

//             // Username field
//             TextField {
//                 id: usernameField
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 placeholderText: "Username"
//                 font.pixelSize: 14
//                 leftPadding: 10

//                 background: Rectangle {
//                     radius: 5
//                     border.color: usernameField.focus ? "#e8e340" : "#cccccc"
//                     border.width: 1
//                 }
//             }

//             // Password field
//             TextField {
//                 id: passwordField
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 placeholderText: "Password"
//                 echoMode: TextInput.Password
//                 font.pixelSize: 14
//                 leftPadding: 10

//                 background: Rectangle {
//                     radius: 5
//                     border.color: passwordField.focus ? "#e8e340" : "#cccccc"
//                     border.width: 1
//                 }

//                 Keys.onReturnPressed: loginButton.clicked()
//             }

//             // Error message
//             Text {
//                 id: errorMessage
//                 color: "#e03131"
//                 font.pixelSize: 12
//                 visible: false
//                 Layout.alignment: Qt.AlignHCenter
//                 Layout.topMargin: -10
//             }

//             // Login button
//             Button {
//                 id: loginButton
//                 text: "Login"
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 font.pixelSize: 16
//                 font.bold: true

//                 background: Rectangle {
//                     color: loginButton.pressed ? "#e8e340" : (loginButton.hovered ? "#e8e340" : "#e8e340")
//                     radius: 5
//                 }

//                 contentItem: Text {
//                     text: loginButton.text
//                     font: loginButton.font
//                     color: "white"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                 }

//                 onClicked: {
//                     // Validate credentials and get role
//                     var loginResult = validateAndGetRole(usernameField.text, passwordField.text)

//                             if (loginResult.valid) {
//             // Call C++ method to save role (safer approach)
//             if (typeof CustomPlugin !== 'undefined' && CustomPlugin) {
//                 CustomPlugin.saveUserRole(loginResult.role)
//             }
//             loginWindow.loginSuccess()
//         }
//                     else {
//                         errorMessage.text = "Invalid username or password"
//                         errorMessage.visible = true
//                         passwordField.clear()
//                         passwordField.focus = true

//                         // Hide error message after 3 seconds
//                         errorTimer.restart()
//                     }
//                 }
//             }

//             // Cancel button
//             Button {
//                 text: "Cancel"
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 40
//                 font.pixelSize: 14

//                 background: Rectangle {
//                     color: cancelButton.pressed ? "#666666" : (cancelButton.hovered ? "#888888" : "#999999")
//                     radius: 5
//                 }

//                 contentItem: Text {
//                     text: cancelButton.text
//                     font: cancelButton.font
//                     color: "white"
//                     horizontalAlignment: Text.AlignHCenter
//                     verticalAlignment: Text.AlignVCenter
//                 }

//                 id: cancelButton
//                 onClicked: {
//                     loginWindow.loginFailed()
//                 }
//             }

//             // Info text
//             Text {
//                 text: "Contact administrator for credentials"
//                 font.pixelSize: 10
//                 color: "#666666"
//                 Layout.alignment: Qt.AlignHCenter
//             }
//         }
//     }

//     // Timer to hide error message
//     Timer {
//         id: errorTimer
//         interval: 3000
//         onTriggered: errorMessage.visible = false
//     }

//     // Login validation function with automatic role assignment
//     function validateAndGetRole(username, password) {
//         // Define user credentials with their roles
//         var users = {
//             // Operators
//             "operator1": { password: "op123", role: "Operator" },
//             "operator2": { password: "op456", role: "Operator" },
//             "john_doe": { password: "john123", role: "Operator" },

//             // Engineers
//             "engineer1": { password: "eng123", role: "Engineer" },
//             "engineer2": { password: "eng456", role: "Engineer" },
//             "tech_admin": { password: "tech789", role: "Engineer" },

//             // Admin (can be either role, we'll make them Engineer for full access)
//             "admin": { password: "admin123", role: "Engineer" }
//         }

//         // Check if user exists and password matches
//         if (users.hasOwnProperty(username)) {
//             if (users[username].password === password) {
//                 return {
//                     valid: true,
//                     role: users[username].role
//                 }
//             }
//         }

//         return {
//             valid: false,
//             role: null
//         }
//     }

//     // Save username for display purposes
//     function saveUsername(username) {
//         // You can store this in settings or a global property
//         // For now, we'll just log it
//         console.log("User logged in: " + username)
//     }

//     Component.onCompleted: {
//         // Focus on username field when window opens
//         usernameField.focus = true
//     }
// }

/*import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QGroundControl 1.0
import QGroundControl.SettingsManager 1.0

Rectangle {
    id: loginOverlay
    anchors.fill: parent
    color: "rgba(0, 0, 0, 0.8)"  // Semi-transparent black background
    z: 1000  // High z-order to appear on top of main window

    // Signals
    signal loginSuccess()
    signal loginFailed()

    // The login form - centered on screen
    Rectangle {
        id: loginForm
        width: 400
        height: 450
        anchors.centerIn: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f0f0f0" }
            GradientStop { position: 1.0; color: "#e0e0e0" }
        }

        radius: 10
        border.color: "#e8e340"
        border.width: 2

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20
            width: 300

            // Logo
            Image {
                source: "/custom/img/CustomAppIcon.png"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 100
                Layout.alignment: Qt.AlignHCenter
                fillMode: Image.PreserveAspectFit
            }

            // Title
            Text {
                text: "INDRONES Login"
                font.pixelSize: 24
                font.bold: true
                color: "#333333"
                Layout.alignment: Qt.AlignHCenter
            }

            // Username field
            TextField {
                id: usernameField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                placeholderText: "Username"
                font.pixelSize: 14
                leftPadding: 10

                background: Rectangle {
                    radius: 5
                    border.color: usernameField.focus ? "#e8e340" : "#cccccc"
                    border.width: 1
                }
            }

            // Password field
            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                placeholderText: "Password"
                echoMode: TextInput.Password
                font.pixelSize: 14
                leftPadding: 10

                background: Rectangle {
                    radius: 5
                    border.color: passwordField.focus ? "#e8e340" : "#cccccc"
                    border.width: 1
                }

                Keys.onReturnPressed: loginButton.clicked()
            }

            // Error message
            Text {
                id: errorMessage
                color: "#e03131"
                font.pixelSize: 12
                visible: false
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -10
            }

            // Login button
            Button {
                id: loginButton
                text: "Login"
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pixelSize: 16
                font.bold: true

                background: Rectangle {
                    color: loginButton.pressed ? "#d4d63a" : (loginButton.hovered ? "#e8e340" : "#e8e340")
                    radius: 5
                }

                contentItem: Text {
                    text: loginButton.text
                    font: loginButton.font
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    // Validate credentials and get role
                    var loginResult = validateAndGetRole(usernameField.text, passwordField.text)

                    if (loginResult.valid) {
                        // Call C++ method to save role (safer approach)
                        if (typeof CustomPlugin !== 'undefined' && CustomPlugin) {
                            CustomPlugin.saveUserRole(loginResult.role)
                        }
                        loginOverlay.loginSuccess()
                    }
                    else {
                        errorMessage.text = "Invalid username or password"
                        errorMessage.visible = true
                        passwordField.clear()
                        passwordField.focus = true

                        // Hide error message after 3 seconds
                        errorTimer.restart()
                    }
                }
            }

            // Cancel button
            Button {
                text: "Cancel"
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pixelSize: 14

                background: Rectangle {
                    color: cancelButton.pressed ? "#666666" : (cancelButton.hovered ? "#888888" : "#999999")
                    radius: 5
                }

                contentItem: Text {
                    text: cancelButton.text
                    font: cancelButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                id: cancelButton
                onClicked: {
                    loginOverlay.loginFailed()
                }
            }

            // Info text
            Text {
                text: "Contact administrator for credentials"
                font.pixelSize: 10
                color: "#666666"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // Timer to hide error message
    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: errorMessage.visible = false
    }

    // Login validation function with automatic role assignment
    function validateAndGetRole(username, password) {
        // Define user credentials with their roles
        var users = {
            // Operators
            "operator1": { password: "op123", role: "Operator" },
            "operator2": { password: "op456", role: "Operator" },
            "john_doe": { password: "john123", role: "Operator" },

            // Engineers
            "engineer1": { password: "eng123", role: "Engineer" },
            "engineer2": { password: "eng456", role: "Engineer" },
            "tech_admin": { password: "tech789", role: "Engineer" },

            // Admin (can be either role, we'll make them Engineer for full access)
            "admin": { password: "admin123", role: "Engineer" }
        }

        // Check if user exists and password matches
        if (users.hasOwnProperty(username)) {
            if (users[username].password === password) {
                return {
                    valid: true,
                    role: users[username].role
                }
            }
        }

        return {
            valid: false,
            role: null
        }
    }

    // Save username for display purposes
    function saveUsername(username) {
        // You can store this in settings or a global property
        // For now, we'll just log it
        console.log("User logged in: " + username)
    }

    Component.onCompleted: {
        // Focus on username field when overlay is shown
        usernameField.focus = true
    }
}*/
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QGroundControl 1.0
import QGroundControl.SettingsManager 1.0

Rectangle {
    id: loginOverlay
    anchors.fill: parent
    color: "grey"  // Semi-transparent black background
    z: 1000  // High z-order to appear on top of main window

    // Signals
    signal loginSuccess()
    signal loginFailed()

    // Debug rectangle to make sure overlay is visible
    // Rectangle {
    //     width: 50
    //     height: 50
    //     color: "red"
    //     anchors.top: parent.top
    //     anchors.right: parent.right
    //     z: 2000

    //     Text {
    //         anchors.centerIn: parent
    //         text: "DEBUG"
    //         color: "white"
    //         font.pixelSize: 8
    //     }
    // }

    // The login form - centered on screen
    Rectangle {
        id: loginForm
        width: 400
        height: 450
        anchors.centerIn: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f0f0f0" }
            GradientStop { position: 1.0; color: "#e0e0e0" }
        }

        radius: 10
        border.color: "#e8e340"
        border.width: 2

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20
            width: 300

            // Logo
            // Rectangle {
            //     Layout.preferredWidth: 100
            //     Layout.preferredHeight: 100
            //     Layout.alignment: Qt.AlignHCenter
            //     color: "#e8e340"
            //     radius: 50

            //     Text {
            //         anchors.centerIn: parent
            //         text: "LOGO"
            //         color: "black"
            //         font.pixelSize: 16
            //         font.bold: true
            //     }
            // }

            Image {
                          source: "/custom/img/CustomAppIcon.png"
                          Layout.preferredWidth: 100
                          Layout.preferredHeight: 100
                          Layout.alignment: Qt.AlignHCenter
                          fillMode: Image.PreserveAspectFit

                          // Fallback rectangle in case image fails to load
                          Rectangle {
                              anchors.fill: parent
                              color: "#e8e340"
                              radius: 50
                              visible: parent.status === Image.Error

                              Text {
                                  anchors.centerIn: parent
                                  text: "LOGO"
                                  color: "black"
                                  font.pixelSize: 16
                                  font.bold: true
                              }
                          }
                      }

            // Title
            Text {
                text: "INDRONES Login"
                font.pixelSize: 24
                font.bold: true
                color: "#333333"
                Layout.alignment: Qt.AlignHCenter
            }

            // Username field
            TextField {
                id: usernameField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                placeholderText: "Username"
                font.pixelSize: 14
                leftPadding: 10
                /*text: "admin"*/  // Pre-fill for testing

                background: Rectangle {
                    radius: 5
                    border.color: usernameField.focus ? "#e8e340" : "#cccccc"
                    border.width: 1
                    color: "white"
                }
            }

            // Password field
            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                placeholderText: "Password"
                echoMode: TextInput.Password
                font.pixelSize: 14
                leftPadding: 10
                /*text: "admin123"*/  // Pre-fill for testing

                background: Rectangle {
                    radius: 5
                    border.color: passwordField.focus ? "#e8e340" : "#cccccc"
                    border.width: 1
                    color: "white"
                }

                Keys.onReturnPressed: loginButton.clicked()
            }

            // Error message
            Text {
                id: errorMessage
                color: "#e03131"
                font.pixelSize: 12
                visible: false
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -10
            }

            // Login button
            Button {
                id: loginButton
                text: "Login"
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pixelSize: 16
                font.bold: true

                background: Rectangle {
                    color: loginButton.pressed ? "#d4d63a" : (loginButton.hovered ? "#e8e340" : "#e8e340")
                    radius: 5
                }

                contentItem: Text {
                    text: loginButton.text
                    font: loginButton.font
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    console.log("Login button clicked with:", usernameField.text, passwordField.text);

                    // Validate credentials and get role
                    var loginResult = validateAndGetRole(usernameField.text, passwordField.text)

                    if (loginResult.valid) {
                        console.log("Login valid, role:", loginResult.role);

                        // Call C++ method to save role (safer approach)
                        if (typeof CustomPlugin !== 'undefined' && CustomPlugin) {
                            CustomPlugin.saveUserRole(loginResult.role)
                        }
                        loginOverlay.loginSuccess()
                    }
                    else {
                        console.log("Login failed");
                        errorMessage.text = "Invalid username or password"
                        errorMessage.visible = true
                        passwordField.clear()
                        passwordField.focus = true

                        // Hide error message after 3 seconds
                        errorTimer.restart()
                    }
                }
            }

            // Cancel button
            Button {
                text: "Cancel"
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pixelSize: 14

                background: Rectangle {
                    color: cancelButton.pressed ? "#666666" : (cancelButton.hovered ? "#888888" : "#999999")
                    radius: 5
                }

                contentItem: Text {
                    text: cancelButton.text
                    font: cancelButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                id: cancelButton
                onClicked: {
                    console.log("Cancel button clicked");
                    loginOverlay.loginFailed()
                }
            }

            // Info text
            Text {
                text: "Contact administrator for credentials"
                font.pixelSize: 10
                color: "#666666"
                Layout.alignment: Qt.AlignHCenter
            }

            // Debug info
            // Text {
            //     text: "Debug: Overlay loaded successfully"
            //     font.pixelSize: 8
            //     color: "red"
            //     Layout.alignment: Qt.AlignHCenter
            // }
        }
    }

    // Timer to hide error message
    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: errorMessage.visible = false
    }

    // Login validation function with automatic role assignment
    function validateAndGetRole(username, password) {
        console.log("Validating:", username, password);

        // Define user credentials with their roles
        var users = {
            // Operators
            "operator1": { password: "op123", role: "Operator" },
            "operator2": { password: "op456", role: "Operator" },
            "john_doe": { password: "john123", role: "Operator" },

            // Engineers
            "engineer1": { password: "eng123", role: "Engineer" },
            "engineer2": { password: "eng456", role: "Engineer" },
            "tech_admin": { password: "tech789", role: "Engineer" },

            // Admin (can be either role, we'll make them Engineer for full access)
            "admin": { password: "admin123", role: "Engineer" }
        }

        // Check if user exists and password matches
        if (users.hasOwnProperty(username)) {
            if (users[username].password === password) {
                return {
                    valid: true,
                    role: users[username].role
                }
            }
        }

        return {
            valid: false,
            role: null
        }
    }

    Component.onCompleted: {
        console.log("LoginPage overlay completed loading");
        usernameField.focus = true
    }
}
