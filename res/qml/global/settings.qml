pragma Singleton
import QtQuick 2.9
import spotify 1.0

Item {
    property var userSettings: !userFirstTime ? JSON.parse(FileIO.read(fileNames.userSettings)) : {};
    property var appSettings: !appFirstTime ? JSON.parse(FileIO.read(fileNames.appSettings)) : {};
    property var initSettings: !initFirstTime ? JSON.parse(FileIO.read(fileNames.initSettings)) : {};

    property bool initFirstTime: !FileIO.exists(fileNames.initSettings);
    property bool appFirstTime: !FileIO.exists(fileNames.appSettings);
    property bool userFirstTime: !FileIO.exists(fileNames.userSettings);

    onInitSettingsChanged: FileIO.write(fileNames.initSettings, JSON.stringify(initSettings));
    onUserSettingsChanged: FileIO.write(fileNames.userSettings, JSON.stringify(userSettings));
    onAppSettingsChanged: FileIO.write(fileNames.appSettings, JSON.stringify(appSettings));

    Connections {
        target: Spotify;
        onCurrentUserChanged: fileNames.userSettings = Spotify.currentUser.id + "txt";
    }

    QtObject {
        id: fileNames;
        property string userSettings: "none.txt";
        readonly property string initSettings: "init.txt";
        readonly property string appSettings: "AppSettings.txt";
    }
}
