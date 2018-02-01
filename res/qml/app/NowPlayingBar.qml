import QtQuick 2.9
import format 1.0
import palette 1.0
import spotify 1.0
import "../ui/controls"

MouseArea {
    id: main;

    height: 80;

    Rectangle {
        anchors.fill: parent;
        color: Palette.color_background2;
    }

    Column {
        anchors.centerIn: parent;

        Label {
            font.pointSize: Format.textCaption;
            font.bold: true;
            text: Spotify.nowPlaying.name;
            anchors.horizontalCenter: parent.horizontalCenter;
        }

        Label {
            font.pointSize: Format.textSmall;
            text: Spotify.nowPlaying.artists[0].name;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }

    PlayPauseButton {
        width: height;
        height: parent.height * 0.4;
        anchors.right: parent.right;
        anchors.rightMargin: Format.marginMedium;
        anchors.verticalCenter: parent.verticalCenter;
    }

    ProgressBar {
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
    }
}
