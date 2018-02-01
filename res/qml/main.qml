import QtQuick 2.7
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.3
import QtWebView 1.1
import spotify 1.0
import format 1.0
import palette 1.0
import settings 1.0
import "app"

Controls.ApplicationWindow {
    id: mainWindow;

    visible: true
    title: qsTr("Tagify");
    background: Rectangle {
        color: "#151515"
    }

    property string authUrl;

    property var init: {
        Format.window = mainWindow;
    }

    Component.onCompleted: {
        if (Qt.platform.os == "windows" || Qt.platform.os == "mac") {
            height = Screen.height *0.95;
            width = height * 0.6;
            y = 20;
        }
    }

    Loader {
        id: mainLoader;
        anchors.fill: parent;

        sourceComponent: {
            switch (Spotify.state) {
            case "testingToken": return splashScreen;
            case "loggedOut": return initialView;
            case "loggingIn": return webView;
            case "loggedIn": return loadingScreen;
            case "initialized": return mainView;
            }
        }
    }

    Component {
        id: splashScreen;

        SplashScreen {}
    }

    Component {
        id: initialView;

        InitialView {}
    }

    Component {
        id: webView;

        WebView {
            anchors.fill: parent;
            url: authUrl;
            visible: Spotify.state === "loggingIn";
        }
    }

    Component {
        id: loadingScreen;

        LoadingScreen {}
    }

    Component {
        id: mainView;

        MainView {}
    }

    Component {
        id: nowPlaying;

        NowPlaying {}
    }

    Timer {
        id: splashScreenTimer;
        running: true;
        interval: 1000;
        onTriggered: {
            SpotifyWrapper.oauth.token = Settings.initSettings.token || "";

            if (SpotifyWrapper.oauth.token === "") {
                Spotify.state = "loggedOut";
                return;
            }

            SpotifyWrapper.get("https://api.spotify.com/v1/me", function(response) {
                var data = JSON.parse(response);
                if (data.error) {
                    console.log(response)
                    Spotify.state = "loggedOut";
                } else {
                    Spotify.state = "loggedIn";
                    Spotify.initialize();
                }
            })
        }
    }

    Connections {
        target: SpotifyWrapper;
        onOpenUrl: {
            authUrl = url;
            Spotify.state = "loggingIn";
        }
        onGranted: {
            console.log("ACCESS GRANTED")
            Settings.initSettings.token = SpotifyWrapper.oauth.token;
            Settings.initSettings.expiration = SpotifyWrapper.oauth.expiration;
            Settings.initSettingsChanged();
            Spotify.state = "loggedIn";
            Spotify.initialize();
        }
    }
}
