import QtQuick 2.8
import palette 1.0
import spotify 1.0;

Item {
    id: progressBar;

    height: 2;

    property alias backgroundColor: backgroundRect.color;

    Rectangle {
        id: backgroundRect;

        anchors.fill: parent;
        color: "transparent";
    }

    Rectangle {
        id: progressRect;

        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        color: Palette.spotify;

        property bool updateProgress: true;

        Binding on width {
            when: !mouse.pressed && progressRect.updateProgress;
            value: parent.width * Spotify.currentSongProgress / Spotify.currentSongDuration;
        }
        Binding on width {
            when: mouse.pressed || !progressRect.updateProgress;
            value: mouse.mouseX;
        }

        Timer {
            id: updateProgressDelay;
            interval: Spotify.requestInterval * 1.2;
            onTriggered: progressRect.updateProgress = true;
        }
    }

    MouseArea {
        id: mouse;
        anchors.fill: parent;
        anchors.topMargin: -parent.height;
        anchors.bottomMargin: -parent.height;
        onReleased: {
            progressRect.updateProgress = false;
            Spotify.setCurrentSongPosition(Math.floor(Spotify.currentSongDuration * mouse.x / progressBar.width), updateProgressDelay.start)
        }
    }
}
