/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 *   @brief Custom QGCCorePlugin Declaration
 *   @author Gus Grubba <gus@auterion.com>
 */

#pragma once

#include "QGCCorePlugin.h"
#include "QGCOptions.h"
#include "QGCLoggingCategory.h"
#include "SettingsManager.h"
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QTranslator>

// Forward declarations
class CustomOptions;
class CustomPlugin;
class CustomSettings;

Q_DECLARE_LOGGING_CATEGORY(CustomLog)

class CustomFlyViewOptions : public QGCFlyViewOptions
{
public:
    CustomFlyViewOptions(CustomOptions* options, QObject* parent = nullptr);

    // Overrides from CustomFlyViewOptions
    bool                    showInstrumentPanel         (void) const final;
    bool                    showMultiVehicleList        (void) const final;
};

class CustomOptions : public QGCOptions
{
public:
    CustomOptions(CustomPlugin*, QObject* parent = nullptr);

    // Overrides from QGCOptions
    bool                    wifiReliableForCalibration  (void) const final;
    bool                    showFirmwareUpgrade         (void) const final;
    QGCFlyViewOptions*      flyViewOptions(void) final;

private:
    CustomFlyViewOptions* _flyViewOptions = nullptr;
};

class CustomPlugin : public QGCCorePlugin
{
    Q_OBJECT
public:
    CustomPlugin(QGCApplication* app, QGCToolbox *toolbox);
    ~CustomPlugin();

    // Overrides from QGCCorePlugin
    QVariantList&           settingsPages                   (void) final;
    QGCOptions*             options                         (void) final;
    QString                 brandImageIndoor                (void) const final;
    QString                 brandImageOutdoor               (void) const final;
    bool                    overrideSettingsGroupVisibility (QString name) final;
    bool                    adjustSettingMetaData           (const QString& settingsGroup, FactMetaData& metaData) final;
    void                    paletteOverride                 (QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo) final;
    QQmlApplicationEngine*  createQmlApplicationEngine      (QObject* parent) final;

    // Overrides from QGCTool
    void                    setToolbox                      (QGCToolbox* toolbox);

public slots:
    void logout();
    void saveUserRole(const QString& role);

signals:
    void logoutRequested();

private slots:
    void _advancedChanged(bool advanced);
    void showLoginPage();
    void onLoginSuccess();
    void onLoginFailed();

private:
    // Helper methods
    void _addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile = nullptr);
    void showSplashScreen();
    void showSplashOverlay();
    void showLoginOverlay();
    void showLoginAsSeparateWindow();

    // Member variables
    CustomOptions*          _options = nullptr;
    QVariantList           _customSettingsList;
    QQmlApplicationEngine* _engine = nullptr;
    bool                   _loginSuccess = false;

    // Window and overlay objects
    QQuickWindow* _mainWindow = nullptr;
    QQuickWindow* _loginWindow = nullptr;
    QObject* _splashObject = nullptr;
    QObject* _loginObject = nullptr;
};
