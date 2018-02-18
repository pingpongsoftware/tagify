import QtQuick 2.9
import QtGraphicalEffects 1.0

import spotify 1.0
import format 1.0
import palette 1.0
import settings 1.0
import "../ui/controls"

Item {
    id: main;

    property real bottomMargin;
    property real topMargin;
    property real topBlurMargin;

    property real closedHeight: Format.header;

    Image {
        id: albumArt;

        visible: false;
        anchors.fill: parent;
        source: Spotify.nowPlaying.album.images[0].url;
        fillMode: Image.PreserveAspectCrop;
    }

    Item {
        id: artMask;

        visible: false;
        anchors.fill: parent;

        Rectangle {
            anchors.fill: parent;
            anchors.topMargin: topMargin;
            anchors.bottomMargin: bottomMargin;
        }
    }

    OpacityMask {
        anchors.fill: parent;
        source: albumArt;
        maskSource: artMask;
    }

    Image {
        id: blurAlbumArt;

        visible: false;
        anchors.fill: parent;
        asynchronous: true;
        source: Spotify.nowPlaying.album.images[0].url;
        fillMode: Image.PreserveAspectCrop;
    }

    FastBlur {
        id: blurEffect;

        radius: 128;
        visible: false;
        source: blurAlbumArt;
        anchors.fill: parent;
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

    Item {
        id: blurMask;

        visible: false;
        anchors.fill: parent;

        Rectangle {
            anchors.fill: parent;
            anchors.topMargin: main.topBlurMargin;
            anchors.bottomMargin: main.bottomMargin;
        }
    }

    Rectangle {
        id: blender;

        anchors.fill: parent;
        color: Palette.color_nowPlayingOverlay;
        visible: false;
    }

    OpacityMask {
        anchors.fill: parent;
        source: blurEffect;
        maskSource: blurMask;
        layer.enabled: true;
        layer.effect: Blend {
            foregroundSource: blender;
            mode: Palette.nowPlayingOverlayMode;
            opacity: Palette.nowPlayingOverlayOpacity;
        }
    }

    Item {
        id: nowPlayingContainer;
        anchors.fill: parent;
        anchors.topMargin: main.topBlurMargin;
        anchors.bottomMargin: main.bottomMargin;

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                nowPlaying.state = nowPlaying.state == "full" ? "bar" : "full";
            }
        }

        ProgressBar {
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: parent.top;
        }

        Column {
            id: nowPlayingColumn;

            anchors.topMargin: Format.marginStandard;

            Label {
                text: Spotify.nowPlaying.name;
                anchors.horizontalCenter: parent.horizontalCenter;
                font.pointSize: Format.textCaption
            }

            Label {
                text: Spotify.nowPlaying.artists[0].name;
                anchors.horizontalCenter: parent.horizontalCenter;
                font.pointSize: Format.textSmall;
                color: Palette.color_textSecondary;
            }
        }

        PrevButton {
            anchors.right: playPauseButton.left;
            anchors.margins: Format.marginStandard;
            anchors.verticalCenter: playPauseButton.verticalCenter;
            releasedOpacity: playPauseButton.otherButtonsOpacity;
            height: playPauseButton.height * 0.66;
            width: height;
            enabled: opacity == 1;
            onClicked: SpotifyWrapper.post('https://api.spotify.com/v1/me/player/previous', '', function(){});
        }

        PlayPauseButton {
            id: playPauseButton;

            width: height;
            anchors.rightMargin: Format.marginStandard;
            anchors.topMargin: Format.marginStandard;

            property real otherButtonsOpacity;
        }

        NextButton {
            anchors.left: playPauseButton.right;
            anchors.margins: Format.marginStandard;
            anchors.verticalCenter: playPauseButton.verticalCenter;
            releasedOpacity: playPauseButton.otherButtonsOpacity;
            height: playPauseButton.height * 0.66;
            width: height;
            enabled: opacity == 1;
            onClicked: SpotifyWrapper.post('https://api.spotify.com/v1/me/player/next', '', function(){});
        }
    }

    states: [
        State {
            name: "bar";
            PropertyChanges {
                target: main;
                bottomMargin: Format.footer;
                topMargin: main.height - Format.footer - closedHeight;
                topBlurMargin: main.height - Format.footer - closedHeight;
            }
            AnchorChanges {
                target: nowPlayingColumn;
                anchors.horizontalCenter: nowPlayingColumn.parent.horizontalCenter;
                anchors.verticalCenter: nowPlayingColumn.parent.verticalCenter;
            }
            AnchorChanges {
                target: playPauseButton;
                anchors.verticalCenter: playPauseButton.parent.verticalCenter;
                anchors.right: playPauseButton.parent.right;
            }
            PropertyChanges {
                target: playPauseButton;
                height: Format.basicUnit * 4;
                otherButtonsOpacity: 0;
            }
        },
        State {
            name: "full";
            PropertyChanges {
                target: main;
                bottomMargin: 0;
                topMargin: 0;
                topBlurMargin: main.height - Format.header * 3;
            }
            AnchorChanges {
                target: nowPlayingColumn;
                anchors.top: nowPlayingColumn.parent.top;
                anchors.horizontalCenter: nowPlayingColumn.parent.horizontalCenter;
            }
            AnchorChanges {
                target: playPauseButton;
                anchors.top: nowPlayingColumn.bottom;
                anchors.horizontalCenter: playPauseButton.parent.horizontalCenter;
            }
            PropertyChanges {
                target: playPauseButton;
                height: Format.basicUnit * 8;
                otherButtonsOpacity: 1;
            }
        }
    ]

    transitions: [
        Transition {
            from: "*";
            to: "*";

            MyAnchorAnimation {}

            MyAnimation {
                target: main;
                properties: "topMargin, bottomMargin, topBlurMargin";
            }

            MyAnimation {
                target: playPauseButton;
                properties: "height, otherButtonsOpacity";
            }
        }
    ]
}
