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

    Behavior on bottomMargin { MyAnimation {} }
    Behavior on topMargin { MyAnimation {} }
    Behavior on topBlurMargin { MyAnimation {} }

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
                    layer.enabled: true;
                    layer.effect: FastBlur {
                        radius: 128;
                    }
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
            mode: "multiply"
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
                console.log(nowPlaying.state, nowPlaying.height, nowPlaying.parent.height);
            }
        }

        ProgressBar {
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: parent.top;
        }

        Column {
            id: nowPlayingColumn;

            anchors.top: parent.top;
            anchors.topMargin: Format.marginSmall;
            anchors.horizontalCenter: parent.horizontalCenter;

            readonly property real topMarginFull: Format.marginStandard;
            readonly property real topMarginBar: Format.marginSmall;

            Behavior on anchors.topMargin { MyAnimation{} }

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

            Behavior on x { MyAnimation{} }
            Behavior on y { MyAnimation{} }
            Behavior on height { MyAnimation{} }
            Behavior on otherButtonsOpacity { MyAnimation{} }

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
            PropertyChanges {
                target: nowPlayingColumn
                anchors.topMargin: topMarginBar;
            }
            PropertyChanges {
                target: playPauseButton;

                x: main.width - Format.basicUnit * 4 - Format.marginStandard;
                y: (Format.header - Format.basicUnit * 4) / 2;
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
            PropertyChanges {
                target: nowPlayingColumn
                anchors.topMargin: topMarginFull;
            }
            PropertyChanges {
                target: playPauseButton;

                x: (main.width - Format.basicUnit * 8) / 2;
                y: nowPlayingColumn.height + nowPlayingColumn.topMarginFull + Format.marginStandard;
                height: Format.basicUnit * 8;
                otherButtonsOpacity: 1;
            }
        }
    ]
}
