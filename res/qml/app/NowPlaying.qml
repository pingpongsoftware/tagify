import QtQuick 2.9
import QtGraphicalEffects 1.0

import spotify 1.0
import format 1.0
import palette 1.0
import settings 1.0
import "../ui/controls"

Item {
    signal backButtonClicked;

    Image {
        id: albumArt;

        anchors.fill: parent;
        asynchronous: true;
        source: Spotify.nowPlaying.album.images[0].url;
        fillMode: Image.PreserveAspectCrop
    }

    FastBlur {
        id: blur;

        visible: false;
        source: albumArt;
        anchors.fill: parent;
        radius: 128;
        layer.enabled: true;
        layer.effect: FastBlur {
            radius: 128;
            layer.enabled: true;
            layer.effect: FastBlur {
                radius: 128;
                layer.enabled: true;
                layer.effect: FastBlur {
                    radius: 128;
                    layer.enabled: true;
                    layer.effect: FastBlur {
                        radius: 128;
                    }
                }
            }
        }
    }

    OpacityMask {
        anchors.fill: parent;
        source: blur;
        maskSource: gradientRect;
        layer.enabled: true;
        layer.effect: Blend {
            foregroundSource: darkener;
            mode: "multiply";
        }
    }

    Rectangle {
        id: gradientRect;
        visible: false;
        width: parent.width;
        height: parent.height;

        property real pos: 1 - (nowPlayingContainer.height / parent.height);

        gradient: Gradient {
            GradientStop { color: "white"; position: gradientRect.pos; }
            GradientStop { color: "transparent"; position: gradientRect.pos; }
        }

        MouseArea {
            anchors.fill: parent;
            drag.target: parent;
            drag.axis: Drag.YAxis;
            onClicked: parent.y -= 10;
        }
    }

    Rectangle {
        id: darkener;
        anchors.fill: parent;
        color: "#707070";
        visible: false;
    }

    Item {
        id: nowPlayingContainer;

        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.top: nowPlayingColumn.top;
        anchors.topMargin: -Format.marginMedium;

        property int seconds: Spotify.currentSongProgress / 1000;

        ProgressBar {
            id: progressBar;

            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: parent.top;
            backgroundColor: Palette.color_textPrimary;
        }

        Label {
            anchors.left: parent.left;
            anchors.top: progressBar.bottom;
            anchors.margins: Format.marginTiny;
            font.pixelSize: Format.textSmall;
            text: Spotify.getMinutesString(Spotify.currentSongProgress);
        }

        Label {
            anchors.right: parent.right;
            anchors.top: progressBar.bottom;
            anchors.margins: Format.marginTiny;
            font.pixelSize: Format.textSmall;
            text: Spotify.getMinutesString(Spotify.currentSongDuration);
        }
    }

    Column {
        id: nowPlayingColumn;

        spacing: Format.marginMedium;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: Format.marginMedium;

        Column {
            anchors.horizontalCenter: parent.horizontalCenter;

            Label {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: Spotify.nowPlaying.name;
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter;
                text: Spotify.nowPlaying.artists[0].name;
                font.pointSize: Format.textCaption;
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter;
            spacing: Format.marginMedium;

            PrevButton {
                width: height;
                height: Format.basicUnit * 6;
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: SpotifyWrapper.post('https://api.spotify.com/v1/me/player/previous', '', function(){});
            }

            PlayPauseButton {
                width: height;
                height: Format.basicUnit * 8;
                anchors.verticalCenter: parent.verticalCenter;
            }

            NextButton {
                width: height;
                height: Format.basicUnit * 6;
                anchors.verticalCenter: parent.verticalCenter;
                onClicked: SpotifyWrapper.post('https://api.spotify.com/v1/me/player/next', '', function(){});
            }
        }
    }

    IconButton {
        icon: "\uE5C4";
        size: Format.basicUnit * 3;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: Format.marginStandard;
        onClicked: backButtonClicked();
        layer.enabled: true;
        layer.effect: DropShadow {
            radius: 5;
            color: "black";
        }
    }
}
