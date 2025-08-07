// /****************************************************************************
//  *
//  * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
//  *
//  * QGroundControl is licensed according to the terms in the file
//  * COPYING.md in the root of the source code directory.
//  *
//  *   @brief Custom QGCCorePlugin Implementation
//  *   @author Gus Grubba <gus@auterion.com>
//  */

// #include <QtQml>
// #include <QQmlEngine>
// #include <QDateTime>
// #include "QGCSettings.h"
// #include "MAVLinkLogManager.h"

// #include "CustomPlugin.h"

// #include "MultiVehicleManager.h"
// #include "QGCApplication.h"
// #include "SettingsManager.h"
// #include "AppMessages.h"
// #include "QmlComponentInfo.h"
// #include "QGCPalette.h"

// #include <QQmlContext>
// #include <QQuickWindow>
// #include <QQuickView>
// #include <QTimer>

// #include "AppSettings.h"  // Ensure this is included


// QGC_LOGGING_CATEGORY(CustomLog, "CustomLog")

// CustomFlyViewOptions::CustomFlyViewOptions(CustomOptions* options, QObject* parent)
//     : QGCFlyViewOptions(options, parent)
// {

// }

// // This custom build does not support conecting multiple vehicles to it. This in turn simplifies various parts of the QGC ui.
// bool CustomFlyViewOptions::showMultiVehicleList(void) const
// {
//     return false;
// }

// // This custom build has it's own custom instrument panel. Don't show regular one.
// bool CustomFlyViewOptions::showInstrumentPanel(void) const
// {
//     return false;
// }

// CustomOptions::CustomOptions(CustomPlugin*, QObject* parent)
//     : QGCOptions(parent)
// {
// }

// QGCFlyViewOptions* CustomOptions::flyViewOptions(void)
// {
//     if (!_flyViewOptions) {
//         _flyViewOptions = new CustomFlyViewOptions(this, this);
//     }
//     return _flyViewOptions;
// }

// // Firmware upgrade page is only shown in Advanced Mode.
// // bool CustomOptions::showFirmwareUpgrade() const
// // {
// //     return qgcApp()->toolbox()->corePlugin()->showAdvancedUI();
// // }

// bool CustomOptions::showFirmwareUpgrade() const {
//     QString role = qgcApp()->toolbox()->settingsManager()->appSettings()->userLoginRole()->rawValue().toString();
//     qCDebug(CustomLog) << "Current login role:" << role;
//     return role == "Engineer";  // Only Engineer can see the firmware upgrade tab
// }

// // Normal QGC needs to work with an ESP8266 WiFi thing which is remarkably crappy. This in turns causes PX4 Pro calibration to fail
// // quite often. There is a warning in regular QGC about this. Overriding the and returning true means that your custom vehicle has
// // a reliable WiFi connection so don't show that warning.
// bool CustomOptions::wifiReliableForCalibration(void) const
// {
//     return true;
// }

// CustomPlugin::CustomPlugin(QGCApplication *app, QGCToolbox* toolbox)
//     : QGCCorePlugin(app, toolbox)
// {
//     _options = new CustomOptions(this, this);
//     _showAdvancedUI = false;
// }

// CustomPlugin::~CustomPlugin()
// {
// }

// void CustomPlugin::setToolbox(QGCToolbox* toolbox)
// {
//     QGCCorePlugin::setToolbox(toolbox);

//     // Allows us to be notified when the user goes in/out out advanced mode
//     connect(qgcApp()->toolbox()->corePlugin(), &QGCCorePlugin::showAdvancedUIChanged, this, &CustomPlugin::_advancedChanged);
// }

// void CustomPlugin::_advancedChanged(bool changed)
// {
//     // Firmware Upgrade page is only show in Advanced mode
//     emit _options->showFirmwareUpgradeChanged(changed);
// }

// //-----------------------------------------------------------------------------
// void CustomPlugin::_addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile)
// {
//     Q_CHECK_PTR(qmlFile);
//     // 'this' instance will take ownership on the QmlComponentInfo instance
//     _customSettingsList.append(QVariant::fromValue(
//         new QmlComponentInfo(title,
//                 QUrl::fromUserInput(qmlFile),
//                 iconFile == nullptr ? QUrl() : QUrl::fromUserInput(iconFile),
//                 this)));
// }

// //-----------------------------------------------------------------------------
// QVariantList&
// CustomPlugin::settingsPages()
// {
//     if(_customSettingsList.isEmpty()) {
//         _addSettingsEntry(tr("General"),     "qrc:/qml/GeneralSettings.qml",     "qrc:/res/gear-white.svg");
//         _addSettingsEntry(tr("Comm Links"),  "qrc:/qml/LinkSettings.qml",        "qrc:/res/waves.svg");
//         _addSettingsEntry(tr("Offline Maps"),"qrc:/qml/OfflineMap.qml",          "qrc:/res/waves.svg");
//         _addSettingsEntry(tr("MAVLink"),     "qrc:/qml/MavlinkSettings.qml",     "qrc:/res/waves.svg");
//         _addSettingsEntry(tr("Console"),     "qrc:/qml/QGroundControl/Controls/AppMessages.qml");
// #if defined(QT_DEBUG)
//         //-- These are always present on Debug builds
//         _addSettingsEntry(tr("Mock Link"),   "qrc:/qml/MockLink.qml");
// #endif
//     }
//     return _customSettingsList;
// }

// QGCOptions* CustomPlugin::options()
// {
//     return _options;
// }

// QString CustomPlugin::brandImageIndoor(void) const
// {
//     return QStringLiteral("/custom/img/CustomAppIcon.png");
// }

// QString CustomPlugin::brandImageOutdoor(void) const
// {
//     return QStringLiteral("/custom/img/CustomAppIcon.png");
// }

// bool CustomPlugin::overrideSettingsGroupVisibility(QString name)
// {
//     // We have set up our own specific brand imaging. Hide the brand image settings such that the end user
//     // can't change it.
//     if (name == BrandImageSettings::name) {
//         return false;
//     }
//     return true;
// }

// // This allows you to override/hide QGC Application settings
// bool CustomPlugin::adjustSettingMetaData(const QString& settingsGroup, FactMetaData& metaData)
// {
//     bool parentResult = QGCCorePlugin::adjustSettingMetaData(settingsGroup, metaData);

//     if (settingsGroup == AppSettings::settingsGroup) {
//         // This tells QGC than when you are creating Plans while not connected to a vehicle
//         // the specific firmware/vehicle the plan is for.
//         if (metaData.name() == AppSettings::offlineEditingFirmwareClassName) {
//             metaData.setRawDefaultValue(QGCMAVLink::FirmwareClassPX4);
//             return false;
//         } else if (metaData.name() == AppSettings::offlineEditingVehicleClassName) {
//             metaData.setRawDefaultValue(QGCMAVLink::VehicleClassMultiRotor);
//             return false;
//         }
//     }

//     return parentResult;
// }

// // This modifies QGC colors palette to match possible custom corporate branding
// void CustomPlugin::paletteOverride(QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo)
// {
//     if (colorName == QStringLiteral("window")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#212529");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ffffff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#f8f9fa");
//     }
//     else if (colorName == QStringLiteral("windowShade")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#343a40");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#343a40");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#f1f3f5");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#d9d9d9");
//     }
//     else if (colorName == QStringLiteral("windowShadeDark")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#1a1c1f");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#1a1c1f");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#e9ecef");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#bdbdbd");
//     }
//     else if (colorName == QStringLiteral("text")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#9d9d9d");
//     }
//     else if (colorName == QStringLiteral("warningText")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#e03131");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#e03131");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#cc0808");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#cc0808");
//     }
//     else if (colorName == QStringLiteral("button")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#495057");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ffffff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ffffff");
//     }
//     else if (colorName == QStringLiteral("buttonText")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#9d9d9d");
//     }
//     else if (colorName == QStringLiteral("buttonHighlight")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#c0c02c");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#aeebd0");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#e4e4e4");
//     }
//     else if (colorName == QStringLiteral("buttonHighlightText")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#2c2c2c");
//     }
//     else if (colorName == QStringLiteral("primaryButton")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#b5a91e");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#b5a91e");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
//     }
//     else if (colorName == QStringLiteral("primaryButtonText")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#ffffff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#cad0d0");
//     }
//     else if (colorName == QStringLiteral("textField")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#212529");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#f1f3f5");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ffffff");
//     }
//     else if (colorName == QStringLiteral("textFieldText")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#808080");
//     }
//     else if (colorName == QStringLiteral("mapButton")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#000000");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
//     }
//     else if (colorName == QStringLiteral("mapButtonHighlight")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#07916d");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#be781c");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
//     }
//     else if (colorName == QStringLiteral("mapIndicator")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#9dda4f");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#be781c");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
//     }
//     else if (colorName == QStringLiteral("mapIndicatorChild")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#527942");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#766043");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
//     }
//     else if (colorName == QStringLiteral("colorGreen")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#27bf89");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#0ca678");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#009431");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#009431");
//     }
//     else if (colorName == QStringLiteral("colorOrange")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#f7b24a");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#f6921e");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#b95604");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#b95604");
//     }
//     else if (colorName == QStringLiteral("colorRed")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#e1544c");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#e03131");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ed3939");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ed3939");
//     }
//     else if (colorName == QStringLiteral("colorGrey")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#8b90a0");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#8b90a0");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#808080");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#808080");
//     }
//     else if (colorName == QStringLiteral("colorBlue")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#228be6");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#228be6");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#1a72ff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#1a72ff");
//     }
//     else if (colorName == QStringLiteral("alertBackground")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#d4b106");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#d4b106");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#fffb8f");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#b45d48");
//     }
//     else if (colorName == QStringLiteral("alertBorder")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#876800");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#876800");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#808080");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#808080");
//     }
//     else if (colorName == QStringLiteral("alertText")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#000000");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#fff9ed");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#fff9ed");
//     }
//     else if (colorName == QStringLiteral("missionItemEditor")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#212529");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#0b1420");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ffffff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
//     }
//     else if (colorName == QStringLiteral("hoverColor")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#07916d");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#33c494");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#aeebd0");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#464f5a");
//     }
//     else if (colorName == QStringLiteral("mapWidgetBorderLight")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#ffffff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#f1f3f5");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ffffff");
//     }
//     else if (colorName == QStringLiteral("mapWidgetBorderDark")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#000000");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#000000");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#000000");
//     }
//     else if (colorName == QStringLiteral("brandingPurple")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#c2b200");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#c2b200");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#c2b200");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#c2b200");
//     }
//     else if (colorName == QStringLiteral("brandingBlue")) {
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#6045c5");
//         colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#48d6ff");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#6045c5");
//         colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#48d6ff");
//     }
// }

// // We override this so we can get access to QQmlApplicationEngine and use it to register our qml module
// // QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// // {
// //     QQmlApplicationEngine* qmlEngine = QGCCorePlugin::createQmlApplicationEngine(parent);
// //     qmlEngine->addImportPath("qrc:/Custom/Widgets");
// //     return qmlEngine;
// // }

// // QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// // {
// //     QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);
// //     engine->addImportPath("qrc:/Custom/Widgets");

// //     // Create and show splash screen
// //     QQmlComponent splashComponent(engine, QUrl(QStringLiteral("qrc:/custom/SplashScreen.qml")));
// //     QObject* splashObject = splashComponent.create();
// //     QQuickWindow* splashWindow = qobject_cast<QQuickWindow*>(splashObject);
// //     if (splashWindow) {
// //         splashWindow->show();
// //     }

// //     // Delay showing the main window
// //     QTimer::singleShot(3000, [engine, splashObject]() {
// //         // Get root objects and find the main QGC window
// //         for (QObject* obj : engine->rootObjects()) {
// //             QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj);
// //             if (mainWin) {
// //                 mainWin->showNormal();
// //                 mainWin->raise();
// //                 mainWin->requestActivate();

// //                 // Pass main window to splash so it can activate it before closing
// //                 if (splashObject) {
// //                     splashObject->setProperty("mainWindow", QVariant::fromValue(mainWin));
// //                 }
// //                 break;
// //             }
// //         }
// //     });

// //     return engine;
// // }

// // last trial
// // QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// // {
// //     QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);
// //     engine->addImportPath("qrc:/Custom/Widgets");

// //     // Step 1: Load and show Splash Screen
// //     QQmlComponent splashComponent(engine, QUrl(QStringLiteral("qrc:/custom/SplashScreen.qml")));
// //     QObject* splashObject = splashComponent.create();
// //     QQuickWindow* splashWindow = qobject_cast<QQuickWindow*>(splashObject);
// //     if (splashWindow) {
// //         splashWindow->show();
// //     }

// //     // Step 2: After splash delay, load login page
// //     QTimer::singleShot(3000, [engine, splashObject]() {
// //         // Load LoginPage.qml
// //        QTimer::singleShot(3000, [engine, splashObject]() {
// //     engine->load(QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
// // });


// //         // Show the login window
// //         for (QObject* obj : engine->rootObjects()) {
// //             QQuickWindow* loginWindow = qobject_cast<QQuickWindow*>(obj);
// //             if (loginWindow) {
// //                 loginWindow->showNormal();
// //                 loginWindow->raise();
// //                 loginWindow->requestActivate();

// //                 if (splashObject) {
// //                     splashObject->setProperty("mainWindow", QVariant::fromValue(loginWindow));
// //                 }
// //                 break;
// //             }
// //         }
// //     });

// //     return engine;
// // }

// // last and final trial
// // QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// // {
// //     QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);

// //     // Load login page first
// //     QQmlComponent loginComponent(engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
// //     QObject* loginObject = loginComponent.create();
// //     QQuickWindow* loginWindow = qobject_cast<QQuickWindow*>(loginObject);
// //     if (loginWindow) {
// //         loginWindow->show();

// //         // Connect signal from QML to C++
// //         QObject::connect(loginObject, SIGNAL(loginSuccess()), loginWindow, [=]() {
// //             loginWindow->close(); // Close login window

// //             // Now load and show the main QGC UI
// //             engine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml"))); // or correct entry QML
// //             for (QObject* obj : engine->rootObjects()) {
// //                 QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj);
// //                 if (mainWin) {
// //                     mainWin->show();
// //                     mainWin->raise();
// //                     mainWin->requestActivate();
// //                     break;
// //                 }
// //             }
// //         });
// //     }

// //     return engine;
// // }

// // void CustomPlugin::loadMainWindow()
// // {
// //     if (!_engine) {
// //         qWarning() << "Engine not available!";
// //         return;
// //     }

// //     _engine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));

// //     for (QObject* obj : _engine->rootObjects()) {
// //         if (QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj)) {
// //             mainWin->show();
// //             mainWin->raise();
// //             mainWin->requestActivate();
// //             break;
// //         }
// //     }
// // }


// // QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// // {
// //     _engine = QGCCorePlugin::createQmlApplicationEngine(parent);

// //     // Load login page first
// //     QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
// //     QObject* loginObject = loginComponent.create();
// //     QQuickWindow* loginWindow = qobject_cast<QQuickWindow*>(loginObject);

// //     if (loginWindow) {
// //         loginWindow->show();

// //         // Close login window on success
// //         QObject::connect(loginObject, SIGNAL(loginSuccess()), loginWindow, SLOT(close()));

// //         // Load main window when login is successful
// //         QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(loadMainWindow()));
// //     }

// //     return _engine;
// // }

// /////////

// // QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// // {
// //     _engine = QGCCorePlugin::createQmlApplicationEngine(parent);

// //     // 1. Load SplashScreen
// //     QQmlComponent splashComponent(_engine, QUrl(QStringLiteral("qrc:/custom/SplashScreen.qml")));
// //     QObject* splashObject = splashComponent.create();

// //     QQuickWindow* splashWindow = qobject_cast<QQuickWindow*>(splashObject);
// //     if (splashWindow) {
// //         splashWindow->show();

// //         // Connect splashDone() signal to showLoginPage() slot
// //         QObject::connect(splashObject, SIGNAL(splashDone()), this, SLOT(showLoginPage()));
// //     } else {
// //         qWarning() << "Failed to load SplashScreen.qml";
// //         showLoginPage(); // fallback if splash fails
// //     }

// //     return _engine;
// // }
// // void CustomPlugin::showLoginPage()
// // {
// //     QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
// //     QObject* loginObject = loginComponent.create();

// //     QQuickWindow* loginWindow = qobject_cast<QQuickWindow*>(loginObject);
// //     if (loginWindow) {
// //         loginWindow->show();

// //         QObject::connect(loginObject, SIGNAL(loginSuccess()), loginWindow, SLOT(close()));
// //         QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(loadMainWindow()));
// //     } else {
// //         qWarning() << "Failed to load LoginPage.qml";
// //         loadMainWindow(); // fallback
// //     }
// // }
// // void CustomPlugin::loadMainWindow()
// // {
// //     if (!_engine) {
// //         qWarning() << "Engine not available!";
// //         return;
// //     }

// //     _engine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));

// //     for (QObject* obj : _engine->rootObjects()) {
// //         if (QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj)) {
// //             mainWin->show();
// //             mainWin->raise();
// //             mainWin->requestActivate();
// //             break;
// //         }
// //     }
// // }




// // In CustomPlugin.h, add these members:
// /*private:
// QQmlApplicationEngine* _engine = nullptr;
// QQuickWindow* _loginWindow = nullptr;
// bool _loginSuccess = false;

// private slots:
// void showLoginPage();
// void onLoginSuccess();
// void onLoginFailed()*/;

// // In CustomPlugin.cpp:

// QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// {
//     QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);
//     engine->addImportPath("qrc:/Custom/Widgets");
//     _engine = engine;

//     // First, hide all windows that might have been created
//     for (QObject* obj : engine->rootObjects()) {
//         QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//         if (window) {
//             window->hide();
//         }
//     }

//     // Create and show splash screen
//     QQmlComponent splashComponent(engine, QUrl(QStringLiteral("qrc:/custom/SplashScreen.qml")));
//     QObject* splashObject = splashComponent.create();
//     QQuickWindow* splashWindow = qobject_cast<QQuickWindow*>(splashObject);
//     if (splashWindow) {
//         splashWindow->show();
//     }

//     // After splash screen (3 seconds), show login page
//     QTimer::singleShot(3000, [this, splashWindow]() {
//         if (splashWindow) {
//             splashWindow->close();
//             splashWindow->deleteLater();
//         }
//         showLoginPage();
//     });

//     return engine;
// }

// void CustomPlugin::showLoginPage()
// {
//     QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
//     QObject* loginObject = loginComponent.create();
//     _loginWindow = qobject_cast<QQuickWindow*>(loginObject);

//     if (_loginWindow) {
//         _loginWindow->show();

//         // Connect signals from login page
//         QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(onLoginSuccess()));
//         QObject::connect(loginObject, SIGNAL(loginFailed()), this, SLOT(onLoginFailed()));
//     } else {
//         qWarning() << "Failed to load LoginPage.qml";
//         // Exit application if login page fails to load
//         qApp->quit();
//     }
// }

// void CustomPlugin::onLoginSuccess()
// {
//     _loginSuccess = true;

//     // Close login window
//     if (_loginWindow) {
//         _loginWindow->close();
//         _loginWindow->deleteLater();
//         _loginWindow = nullptr;
//     }

//     // Show the main QGC window
//     for (QObject* obj : _engine->rootObjects()) {
//         QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj);
//         if (mainWin && mainWin != _loginWindow) {
//             mainWin->showNormal();
//             mainWin->raise();
//             mainWin->requestActivate();
//             break;
//         }
//     }
// }

// void CustomPlugin::onLoginFailed()
// {
//     // Close login window and exit application
//     if (_loginWindow) {
//         _loginWindow->close();
//         _loginWindow->deleteLater();
//         _loginWindow = nullptr;
//     }

//     // Exit the application
//     qApp->quit();
// }


///new code

/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 *   @brief Custom QGCCorePlugin Implementation
 *   @author Gus Grubba <gus@auterion.com>
 */

#include <QtQml>
#include <QQmlEngine>
#include <QDateTime>
#include "QGCSettings.h"
#include "MAVLinkLogManager.h"

#include "CustomPlugin.h"

#include "MultiVehicleManager.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "AppMessages.h"
#include "QmlComponentInfo.h"
#include "QGCPalette.h"

#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickView>
#include <QTimer>

#include "AppSettings.h"

QGC_LOGGING_CATEGORY(CustomLog, "CustomLog")

CustomFlyViewOptions::CustomFlyViewOptions(CustomOptions* options, QObject* parent)
    : QGCFlyViewOptions(options, parent)
{
}

bool CustomFlyViewOptions::showMultiVehicleList(void) const
{
    return false;
}

bool CustomFlyViewOptions::showInstrumentPanel(void) const
{
    return false;
}

CustomOptions::CustomOptions(CustomPlugin*, QObject* parent)
    : QGCOptions(parent)
{
}

QGCFlyViewOptions* CustomOptions::flyViewOptions(void)
{
    if (!_flyViewOptions) {
        _flyViewOptions = new CustomFlyViewOptions(this, this);
    }
    return _flyViewOptions;
}

// bool CustomOptions::showFirmwareUpgrade() const {
//     QString role = qgcApp()->toolbox()->settingsManager()->appSettings()->userLoginRole()->rawValue().toString();
//     qCDebug(CustomLog) << "Current login role:" << role;
//     return role == "Engineer";
// }

bool CustomOptions::showFirmwareUpgrade() const {
    QString role = qgcApp()->toolbox()->settingsManager()->appSettings()->userLoginRole()->rawValue().toString();
    qCDebug(CustomLog) << "Current login role:" << role;
    return role == "Engineer";  // Only Engineer can see the firmware upgrade tab
}

bool CustomOptions::wifiReliableForCalibration(void) const
{
    return true;
}

CustomPlugin::CustomPlugin(QGCApplication *app, QGCToolbox* toolbox)
    : QGCCorePlugin(app, toolbox)
{
    _options = new CustomOptions(this, this);
    _showAdvancedUI = false;
}

CustomPlugin::~CustomPlugin()
{
}

void CustomPlugin::setToolbox(QGCToolbox* toolbox)
{
    QGCCorePlugin::setToolbox(toolbox);
    connect(qgcApp()->toolbox()->corePlugin(), &QGCCorePlugin::showAdvancedUIChanged, this, &CustomPlugin::_advancedChanged);
}

void CustomPlugin::_advancedChanged(bool changed)
{
    emit _options->showFirmwareUpgradeChanged(changed);
}

void CustomPlugin::_addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile)
{
    Q_CHECK_PTR(qmlFile);
    _customSettingsList.append(QVariant::fromValue(
        new QmlComponentInfo(title,
                QUrl::fromUserInput(qmlFile),
                iconFile == nullptr ? QUrl() : QUrl::fromUserInput(iconFile),
                this)));
}

QVariantList& CustomPlugin::settingsPages()
{
    if(_customSettingsList.isEmpty()) {
        _addSettingsEntry(tr("General"),     "qrc:/qml/GeneralSettings.qml",     "qrc:/res/gear-white.svg");
        _addSettingsEntry(tr("Comm Links"),  "qrc:/qml/LinkSettings.qml",        "qrc:/res/waves.svg");
        _addSettingsEntry(tr("Offline Maps"),"qrc:/qml/OfflineMap.qml",          "qrc:/res/waves.svg");
        _addSettingsEntry(tr("MAVLink"),     "qrc:/qml/MavlinkSettings.qml",     "qrc:/res/waves.svg");
        _addSettingsEntry(tr("Console"),     "qrc:/qml/QGroundControl/Controls/AppMessages.qml");
#if defined(QT_DEBUG)
        _addSettingsEntry(tr("Mock Link"),   "qrc:/qml/MockLink.qml");
#endif
    }
    return _customSettingsList;
}

QGCOptions* CustomPlugin::options()
{
    return _options;
}

QString CustomPlugin::brandImageIndoor(void) const
{
    return QStringLiteral("/custom/img/CustomAppIcon.png");
}

QString CustomPlugin::brandImageOutdoor(void) const
{
    return QStringLiteral("/custom/img/CustomAppIcon.png");
}

bool CustomPlugin::overrideSettingsGroupVisibility(QString name)
{
    if (name == BrandImageSettings::name) {
        return false;
    }
    return true;
}

bool CustomPlugin::adjustSettingMetaData(const QString& settingsGroup, FactMetaData& metaData)
{
    bool parentResult = QGCCorePlugin::adjustSettingMetaData(settingsGroup, metaData);

    if (settingsGroup == AppSettings::settingsGroup) {
        if (metaData.name() == AppSettings::offlineEditingFirmwareClassName) {
            metaData.setRawDefaultValue(QGCMAVLink::FirmwareClassPX4);
            return false;
        } else if (metaData.name() == AppSettings::offlineEditingVehicleClassName) {
            metaData.setRawDefaultValue(QGCMAVLink::VehicleClassMultiRotor);
            return false;
        }
    }

    return parentResult;
}

void CustomPlugin::paletteOverride(QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo)
{
    if (colorName == QStringLiteral("window")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#212529");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ffffff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#f8f9fa");
    }
    else if (colorName == QStringLiteral("windowShade")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#343a40");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#343a40");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#f1f3f5");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#d9d9d9");
    }
    else if (colorName == QStringLiteral("windowShadeDark")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#1a1c1f");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#1a1c1f");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#e9ecef");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#bdbdbd");
    }
    else if (colorName == QStringLiteral("text")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#9d9d9d");
    }
    else if (colorName == QStringLiteral("warningText")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#e03131");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#e03131");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#cc0808");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#cc0808");
    }
    else if (colorName == QStringLiteral("button")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#495057");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ffffff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ffffff");
    }
    else if (colorName == QStringLiteral("buttonText")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#9d9d9d");
    }
    else if (colorName == QStringLiteral("buttonHighlight")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#c0c02c");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#aeebd0");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#e4e4e4");
    }
    else if (colorName == QStringLiteral("buttonHighlightText")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#2c2c2c");
    }
    else if (colorName == QStringLiteral("primaryButton")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#b5a91e");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#b5a91e");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
    }
    else if (colorName == QStringLiteral("primaryButtonText")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#ffffff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#cad0d0");
    }
    else if (colorName == QStringLiteral("textField")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#212529");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#495057");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#f1f3f5");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ffffff");
    }
    else if (colorName == QStringLiteral("textFieldText")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#777c89");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#808080");
    }
    else if (colorName == QStringLiteral("mapButton")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#000000");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
    }
    else if (colorName == QStringLiteral("mapButtonHighlight")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#07916d");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#be781c");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
    }
    else if (colorName == QStringLiteral("mapIndicator")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#9dda4f");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#be781c");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
    }
    else if (colorName == QStringLiteral("mapIndicatorChild")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#527942");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#585858");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#766043");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
    }
    else if (colorName == QStringLiteral("colorGreen")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#27bf89");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#0ca678");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#009431");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#009431");
    }
    else if (colorName == QStringLiteral("colorOrange")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#f7b24a");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#f6921e");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#b95604");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#b95604");
    }
    else if (colorName == QStringLiteral("colorRed")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#e1544c");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#e03131");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ed3939");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ed3939");
    }
    else if (colorName == QStringLiteral("colorGrey")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#8b90a0");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#8b90a0");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#808080");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#808080");
    }
    else if (colorName == QStringLiteral("colorBlue")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#228be6");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#228be6");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#1a72ff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#1a72ff");
    }
    else if (colorName == QStringLiteral("alertBackground")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#d4b106");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#d4b106");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#fffb8f");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#b45d48");
    }
    else if (colorName == QStringLiteral("alertBorder")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#876800");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#876800");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#808080");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#808080");
    }
    else if (colorName == QStringLiteral("alertText")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#000000");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#fff9ed");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#fff9ed");
    }
    else if (colorName == QStringLiteral("missionItemEditor")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#212529");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#0b1420");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#ffffff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#585858");
    }
    else if (colorName == QStringLiteral("hoverColor")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#07916d");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#33c494");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#aeebd0");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#464f5a");
    }
    else if (colorName == QStringLiteral("mapWidgetBorderLight")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#ffffff");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#ffffff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#f1f3f5");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#ffffff");
    }
    else if (colorName == QStringLiteral("mapWidgetBorderDark")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#000000");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#000000");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#212529");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#000000");
    }
    else if (colorName == QStringLiteral("brandingPurple")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#c2b200");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#c2b200");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#c2b200");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#c2b200");
    }
    else if (colorName == QStringLiteral("brandingBlue")) {
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupEnabled]   = QColor("#6045c5");
        colorInfo[QGCPalette::Dark][QGCPalette::ColorGroupDisabled]  = QColor("#48d6ff");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupEnabled]  = QColor("#6045c5");
        colorInfo[QGCPalette::Light][QGCPalette::ColorGroupDisabled] = QColor("#48d6ff");
    }
}

// QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// {
//     QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);
//     engine->addImportPath("qrc:/");

//     _engine = engine;

//     engine->rootContext()->setContextProperty("CustomPlugin", this);

//     // First, hide all windows that might have been created
//     for (QObject* obj : engine->rootObjects()) {
//         QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//         if (window) {
//             window->hide();
//         }
//     }

//     // Create and show splash screen
//     QQmlComponent splashComponent(engine, QUrl(QStringLiteral("qrc:/custom/SplashScreen.qml")));
//     QObject* splashObject = splashComponent.create();
//     QQuickWindow* splashWindow = qobject_cast<QQuickWindow*>(splashObject);
//     if (splashWindow) {
//         splashWindow->show();
//     }

//     // After splash screen (3 seconds), show login page
//     QTimer::singleShot(3000, [this, splashWindow]() {
//         if (splashWindow) {
//             splashWindow->close();
//             splashWindow->deleteLater();
//         }
//         showLoginPage();
//     });

//     return engine;
// }

// // void CustomPlugin::showLoginPage()
// // {
// //     QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
// //     QObject* loginObject = loginComponent.create();
// //     _loginWindow = qobject_cast<QQuickWindow*>(loginObject);
    
// //     if (_loginWindow) {
// //         _loginWindow->show();
        
// //         // Connect signals from login page
// //         QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(onLoginSuccess()));
// //         QObject::connect(loginObject, SIGNAL(loginFailed()), this, SLOT(onLoginFailed()));
// //     } else {
// //         qWarning() << "Failed to load LoginPage.qml";
// //         // Exit application if login page fails to load
// //         qApp->quit();
// //     }
// // }
// void CustomPlugin::showLoginPage()
// {
//     qCDebug(CustomLog) << "showLoginPage() called";
    
//     if (!_engine) {
//         qCritical() << "Engine is null in showLoginPage!";
//         return;
//     }
    
//     QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));
    
//     if (loginComponent.isError()) {
//         qCritical() << "Login component has errors:" << loginComponent.errors();
//         return;
//     }
    
//     QObject* loginObject = loginComponent.create();
//     if (!loginObject) {
//         qCritical() << "Failed to create login object";
//         return;
//     }
    
//     _loginWindow = qobject_cast<QQuickWindow*>(loginObject);
    
//     if (_loginWindow) {
//         qCDebug(CustomLog) << "Login window created successfully";
//         _loginWindow->show();
        
//         // Connect signals from login page
//         QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(onLoginSuccess()));
//         QObject::connect(loginObject, SIGNAL(loginFailed()), this, SLOT(onLoginFailed()));
//     } else {
//         qWarning() << "Failed to load LoginPage.qml";
//         qApp->quit();
//     }
// }

// // void CustomPlugin::onLoginSuccess()
// // {
// //     _loginSuccess = true;
    
// //     // Close login window
// //     if (_loginWindow) {
// //         _loginWindow->close();
// //         _loginWindow->deleteLater();
// //         _loginWindow = nullptr;
// //     }
    
// //     // Show the main QGC window
// //     for (QObject* obj : _engine->rootObjects()) {
// //         QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj);
// //         if (mainWin && mainWin != _loginWindow) {
// //             mainWin->showNormal();
// //             mainWin->raise();
// //             mainWin->requestActivate();
// //             break;
// //         }
// //     }
// // }

// void CustomPlugin::onLoginSuccess()
// {
//     qCDebug(CustomLog) << "onLoginSuccess() called";

//     if (!_engine) {
//         qCritical() << "Engine is null in onLoginSuccess!";
//         return;
//     }

//     _loginSuccess = true;

//     // Close login window
//     if (_loginWindow) {
//         _loginWindow->close();
//         _loginWindow->deleteLater();
//         _loginWindow = nullptr;
//     }

//     // Give QML engine time to process
//     QTimer::singleShot(100, [this]() {
//         // Show the main QGC window
//         bool foundWindow = false;

//         // Get all root objects
//         const auto rootObjects = _engine->rootObjects();
//         qCDebug(CustomLog) << "Number of root objects:" << rootObjects.count();

//         for (QObject* obj : rootObjects) {
//             if (!obj) continue;

//             // Log object information for debugging
//             qCDebug(CustomLog) << "Root object:" << obj << "Class:" << obj->metaObject()->className();

//             QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//             if (window) {
//                 // Check if it's the main window (not login or splash)
//                 QString objectName = window->objectName();
//                 qCDebug(CustomLog) << "Found window:" << window << "ObjectName:" << objectName;

//                 // Show the window if it's not the login window
//                 if (window != _loginWindow) {
//                     qCDebug(CustomLog) << "Showing main window";
//                     window->show();
//                     window->raise();
//                     window->requestActivate();
//                     foundWindow = true;
//                     break;
//                 }
//             }
//         }

//         if (!foundWindow) {
//             qCritical() << "Could not find main window to show - attempting to load MainRootWindow";

//             // Try to load the main window explicitly
//             _engine->load(QUrl(QStringLiteral("qrc:/qml/MainRootWindow.qml")));

//             // Try again after loading
//             QTimer::singleShot(500, [this]() {
//                 for (QObject* obj : _engine->rootObjects()) {
//                     QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//                     if (window && window != _loginWindow) {
//                         window->show();
//                         window->raise();
//                         window->requestActivate();
//                         break;
//                     }
//                 }
//             });
//         }
//     });
// }

// void CustomPlugin::onLoginFailed()
// {
//     // Close login window and exit application
//     if (_loginWindow) {
//         _loginWindow->close();
//         _loginWindow->deleteLater();
//         _loginWindow = nullptr;
//     }
    
//     // Exit the application
//     qApp->quit();
// }
// // ADD THIS NEW METHOD after onLoginFailed():
// void CustomPlugin::logout()
// {
//     qCDebug(CustomLog) << "User logged out";
    
//     // Reset user role to default
//     qgcApp()->toolbox()->settingsManager()->appSettings()->userLoginRole()->setRawValue("Operator");
    
//     // Hide main window
//     for (QObject* obj : _engine->rootObjects()) {
//         QQuickWindow* mainWin = qobject_cast<QQuickWindow*>(obj);
//         if (mainWin) {
//             mainWin->hide();
//             break;
//         }
//     }
    
//     // Show login page again
//     showLoginPage();
// }
// void CustomPlugin::saveUserRole(const QString& role)
// {
//     qCDebug(CustomLog) << "Saving user role:" << role;
    
//     if (qgcApp() && qgcApp()->toolbox() && qgcApp()->toolbox()->settingsManager()) {
//         auto settings = qgcApp()->toolbox()->settingsManager()->appSettings();
//         if (settings && settings->userLoginRole()) {
//             settings->userLoginRole()->setRawValue(role);
//         } else {
//             qCritical() << "Unable to access userLoginRole setting";
//         }
//     } else {
//         qCritical() << "Settings manager not available";
//     }
// }


// QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
// {
//     // Create engine using parent's method to ensure proper QGC initialization
//     QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);
//     engine->addImportPath("qrc:/");

//     _engine = engine;
//     engine->rootContext()->setContextProperty("CustomPlugin", this);

//     // Immediately hide all windows that were just created
//     for (QObject* obj : _engine->rootObjects()) {
//         QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//         if (window) {
//             window->hide();
//             qCDebug(CustomLog) << "Immediately hiding window:" << window->objectName();
//         }
//     }

//     // Show splash screen after a very brief delay to ensure hiding is complete
//     QTimer::singleShot(50, [this]() {
//         showSplashScreen();
//     });

//     return engine;
// }

// void CustomPlugin::showSplashScreen()
// {
//     qCDebug(CustomLog) << "Loading splash screen";

//     QQmlComponent splashComponent(_engine, QUrl(QStringLiteral("qrc:/custom/SplashScreen.qml")));

//     if (splashComponent.isError()) {
//         qCritical() << "Splash screen component errors:" << splashComponent.errors();
//         // Fallback: go directly to login if splash fails
//         showLoginPage();
//         return;
//     }

//     QObject* splashObject = splashComponent.create();
//     QQuickWindow* splashWindow = qobject_cast<QQuickWindow*>(splashObject);

//     if (splashWindow) {
//         splashWindow->show();
//         qCDebug(CustomLog) << "Splash screen displayed successfully";

//         // After splash screen (3 seconds), show login page
//         QTimer::singleShot(3000, [this, splashWindow]() {
//             if (splashWindow) {
//                 splashWindow->close();
//                 splashWindow->deleteLater();
//             }
//             showLoginPage();
//         });
//     } else {
//         qCritical() << "Failed to create splash screen window";
//         // Fallback: go directly to login
//         showLoginPage();
//     }
// }

// void CustomPlugin::showLoginPage()
// {
//     qCDebug(CustomLog) << "showLoginPage() called";

//     if (!_engine) {
//         qCritical() << "Engine is null in showLoginPage!";
//         qApp->quit();
//         return;
//     }

//     QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));

//     if (loginComponent.isError()) {
//         qCritical() << "Login component has errors:" << loginComponent.errors();
//         qApp->quit();
//         return;
//     }

//     QObject* loginObject = loginComponent.create();
//     if (!loginObject) {
//         qCritical() << "Failed to create login object";
//         qApp->quit();
//         return;
//     }

//     _loginWindow = qobject_cast<QQuickWindow*>(loginObject);

//     if (_loginWindow) {
//         qCDebug(CustomLog) << "Login window created successfully";
//         _loginWindow->show();
//         _loginWindow->raise();
//         _loginWindow->requestActivate();

//         // Connect signals using SIGNAL/SLOT syntax for compatibility
//         QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(onLoginSuccess()));
//         QObject::connect(loginObject, SIGNAL(loginFailed()), this, SLOT(onLoginFailed()));

//     } else {
//         qCritical() << "Failed to cast login object to QQuickWindow";
//         qApp->quit();
//     }
// }

// void CustomPlugin::onLoginSuccess()
// {
//     qCDebug(CustomLog) << "Login successful - showing main application";

//     if (!_engine) {
//         qCritical() << "Engine is null in onLoginSuccess!";
//         return;
//     }

//     _loginSuccess = true;

//     // Close and cleanup login window
//     if (_loginWindow) {
//         _loginWindow->close();
//         _loginWindow->deleteLater();
//         _loginWindow = nullptr;
//     }

//     // Show the already-loaded main QGC windows
//     QTimer::singleShot(100, [this]() {
//         bool windowShown = false;

//         for (QObject* obj : _engine->rootObjects()) {
//             QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//             if (window) {
//                 QString objectName = window->objectName();
//                 qCDebug(CustomLog) << "Found existing window:" << objectName;

//                 // Show window fully maximized
//                 window->showMaximized();
//                 window->raise();
//                 window->requestActivate();
//                 windowShown = true;
//                 qCDebug(CustomLog) << "Main window shown maximized";
//                 break;
//             }
//         }

//         if (!windowShown) {
//             qCritical() << "No windows found to show - this shouldn't happen";
//         }
//     });
// }

// void CustomPlugin::onLoginFailed()
// {
//     qCDebug(CustomLog) << "Login failed - exiting application";

//     // Close login window
//     if (_loginWindow) {
//         _loginWindow->close();
//         _loginWindow->deleteLater();
//         _loginWindow = nullptr;
//     }

//     // Exit the application
//     qApp->quit();
// }

// void CustomPlugin::logout()
// {
//     qCDebug(CustomLog) << "User logged out";

//     // Reset login success flag
//     _loginSuccess = false;

//     // Reset user role to default
//     if (qgcApp() && qgcApp()->toolbox() && qgcApp()->toolbox()->settingsManager()) {
//         auto settings = qgcApp()->toolbox()->settingsManager()->appSettings();
//         if (settings && settings->userLoginRole()) {
//             settings->userLoginRole()->setRawValue("Operator");
//         }
//     }

//     // Hide all current windows
//     for (QObject* obj : _engine->rootObjects()) {
//         QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
//         if (window) {
//             window->hide();
//         }
//     }

//     // Clear root objects to ensure clean state
//     _engine->clearComponentCache();

//     // Show login page again after a brief delay
//     QTimer::singleShot(200, [this]() {
//         showLoginPage();
//     });
// }

// void CustomPlugin::saveUserRole(const QString& role)
// {
//     qCDebug(CustomLog) << "Saving user role:" << role;

//     if (!qgcApp() || !qgcApp()->toolbox() || !qgcApp()->toolbox()->settingsManager()) {
//         qCritical() << "Settings manager not available";
//         return;
//     }

//     auto settings = qgcApp()->toolbox()->settingsManager()->appSettings();
//     if (!settings || !settings->userLoginRole()) {
//         qCritical() << "Unable to access userLoginRole setting";
//         return;
//     }

//     settings->userLoginRole()->setRawValue(role);
//     qCDebug(CustomLog) << "User role saved successfully:" << role;
// }

QQmlApplicationEngine* CustomPlugin::createQmlApplicationEngine(QObject* parent)
{
    // Create the full QGC engine normally - this ensures all modules are loaded
    QQmlApplicationEngine* engine = QGCCorePlugin::createQmlApplicationEngine(parent);
    engine->addImportPath("qrc:/");
    engine->addImportPath("qrc:/custom");

    _engine = engine;
    engine->rootContext()->setContextProperty("CustomPlugin", this);

    // Find and store reference to main window, then show login overlay IMMEDIATELY
    QTimer::singleShot(50, [this]() {
        qCDebug(CustomLog) << "Looking for main window...";
        qCDebug(CustomLog) << "Root objects count:" << _engine->rootObjects().size();

        for (QObject* obj : _engine->rootObjects()) {
            qCDebug(CustomLog) << "Root object:" << obj << "Type:" << obj->metaObject()->className();

            QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);
            if (window) {
                _mainWindow = window;
                window->showMaximized();  // Show maximized from the start
                qCDebug(CustomLog) << "Main window found and maximized:" << window;
                qCDebug(CustomLog) << "Main window contentItem:" << window->contentItem();

                // Show login overlay immediately (skip splash for now)
                showSplashOverlay();  // This will skip to login
                break;
            }
        }

        if (!_mainWindow) {
            qCritical() << "No main window found! Trying alternative approach...";
            // Fallback: try to create login as separate window
            showLoginAsSeparateWindow();
        }
    });

    return engine;
}

void CustomPlugin::showSplashOverlay()
{
    qCDebug(CustomLog) << "Loading splash screen overlay";

    if (!_mainWindow) {
        qCritical() << "Main window not available for splash overlay";
        showLoginOverlay();  // Fallback to login if no main window
        return;
    }

    // Load splash as an overlay component
    QQmlComponent splashComponent(_engine, QUrl(QStringLiteral("qrc:/custom/SplashOverlay.qml")));

    if (splashComponent.isError()) {
        qCritical() << "Splash overlay component errors:" << splashComponent.errors();
        // Fallback: go directly to login if splash fails
        showLoginOverlay();
        return;
    }

    qCDebug(CustomLog) << "Splash component loaded successfully";

    _splashObject = splashComponent.create();
    if (_splashObject) {
        // Set the splash overlay as a child of main window's content item
        QQuickItem* contentItem = _mainWindow->contentItem();
        if (contentItem) {
            _splashObject->setParent(contentItem);
            _splashObject->setProperty("parent", QVariant::fromValue(contentItem));

            qCDebug(CustomLog) << "Splash overlay displayed successfully";

            // After 3 seconds, hide splash and show login overlay
            QTimer::singleShot(3000, [this]() {
                qCDebug(CustomLog) << "Hiding splash and showing login";
                if (_splashObject) {
                    _splashObject->deleteLater();
                    _splashObject = nullptr;
                }
                showLoginOverlay();
            });
        } else {
            qCritical() << "Main window contentItem is null for splash!";
            showLoginOverlay();
        }
    } else {
        qCritical() << "Failed to create splash overlay object";
        showLoginOverlay();
    }
}

void CustomPlugin::showSplashScreen()
{
    // This method is now replaced by showSplashOverlay
    showSplashOverlay();
}

void CustomPlugin::showLoginPage()
{
    // This method now delegates to overlay
    showLoginOverlay();
}

void CustomPlugin::showLoginOverlay()
{
    qCDebug(CustomLog) << "Loading login overlay";

    if (!_mainWindow) {
        qCritical() << "Main window not available for login overlay - using fallback";
        showLoginAsSeparateWindow();
        return;
    }

    qCDebug(CustomLog) << "Main window available:" << _mainWindow;
    qCDebug(CustomLog) << "Main window contentItem:" << _mainWindow->contentItem();

    // Load login as an overlay component
    QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPage.qml")));

    if (loginComponent.isError()) {
        qCritical() << "Login overlay component errors:" << loginComponent.errors();
        qCritical() << "Falling back to separate window";
        showLoginAsSeparateWindow();
        return;
    }

    qCDebug(CustomLog) << "Login component loaded successfully";

    _loginObject = loginComponent.create();
    if (_loginObject) {
        qCDebug(CustomLog) << "Login object created:" << _loginObject;

        // Set the login overlay as a child of main window's content item
        QQuickItem* contentItem = _mainWindow->contentItem();
        if (contentItem) {
            _loginObject->setParent(contentItem);
            _loginObject->setProperty("parent", QVariant::fromValue(contentItem));

            qCDebug(CustomLog) << "Login overlay set as child of contentItem";
            qCDebug(CustomLog) << "Login overlay displayed successfully";

            // Connect login signals
            QObject::connect(_loginObject, SIGNAL(loginSuccess()), this, SLOT(onLoginSuccess()));
            QObject::connect(_loginObject, SIGNAL(loginFailed()), this, SLOT(onLoginFailed()));
        } else {
            qCritical() << "Main window contentItem is null!";
            showLoginAsSeparateWindow();
        }
    } else {
        qCritical() << "Failed to create login overlay object";
        showLoginAsSeparateWindow();
    }
}

// Fallback method to show login as separate window (your old approach)
void CustomPlugin::showLoginAsSeparateWindow()
{
    qCDebug(CustomLog) << "Creating login as separate window (fallback)";

    // Load your old LoginPage.qml as a Window (you'll need the old version for this)
    QQmlComponent loginComponent(_engine, QUrl(QStringLiteral("qrc:/custom/LoginPageWindow.qml")));

    if (loginComponent.isError()) {
        qCritical() << "Login window component errors:" << loginComponent.errors();
        return;
    }

    QObject* loginObject = loginComponent.create();
    _loginWindow = qobject_cast<QQuickWindow*>(loginObject);

    if (_loginWindow) {
        _loginWindow->show();
        _loginWindow->raise();
        _loginWindow->requestActivate();

        // Connect signals
        QObject::connect(loginObject, SIGNAL(loginSuccess()), this, SLOT(onLoginSuccess()));
        QObject::connect(loginObject, SIGNAL(loginFailed()), this, SLOT(onLoginFailed()));

        qCDebug(CustomLog) << "Login window displayed as fallback";
    }
}

void CustomPlugin::onLoginSuccess()
{
    qCDebug(CustomLog) << "Login successful - enabling main application";

    _loginSuccess = true;

    // Remove login overlay
    if (_loginObject) {
        _loginObject->deleteLater();
        _loginObject = nullptr;
    }

    qCDebug(CustomLog) << "Main application is now accessible";
}

void CustomPlugin::onLoginFailed()
{
    qCDebug(CustomLog) << "Login failed - exiting application";

    // Close application on login failure
    qApp->quit();
}

void CustomPlugin::logout()
{
    qCDebug(CustomLog) << "User logged out";

    // Reset login success flag
    _loginSuccess = false;

    // Reset user role to default
    if (qgcApp() && qgcApp()->toolbox() && qgcApp()->toolbox()->settingsManager()) {
        auto settings = qgcApp()->toolbox()->settingsManager()->appSettings();
        if (settings && settings->userLoginRole()) {
            settings->userLoginRole()->setRawValue("Operator");
        }
    }

    // Show login overlay again
    showLoginOverlay();
}

void CustomPlugin::saveUserRole(const QString& role)
{
    qCDebug(CustomLog) << "Saving user role:" << role;

    if (!qgcApp() || !qgcApp()->toolbox() || !qgcApp()->toolbox()->settingsManager()) {
        qCritical() << "Settings manager not available";
        return;
    }

    auto settings = qgcApp()->toolbox()->settingsManager()->appSettings();
    if (!settings || !settings->userLoginRole()) {
        qCritical() << "Unable to access userLoginRole setting";
        return;
    }

    settings->userLoginRole()->setRawValue(role);
    qCDebug(CustomLog) << "User role saved successfully:" << role;
}
