import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as C

import spotify 1.0
import palette 1.0
import format 1.0
import settings 1.0
import "../ui/design"
import "../ui/controls"

Rectangle {
    id: main;

    state: "albums";
    color: Palette.color_background3;

    C.StackView {
        id: stackView;

        anchors.fill: parent;
        initialItem: library;
        pushEnter: Transition {
            YAnimator {
                from: stackView.height; to: 0;
                duration: Format.animationMedium;
                easing.type: Easing.OutCubic;
            }
        }
        pushExit: Transition {
            OpacityAnimator {
                from: 1; to: 0;
                duration: Format.animationMedium;
                easing.type: Easing.OutCubic;
            }
        }
        popEnter: Transition {
            OpacityAnimator {
                from: 0; to: 1;
                duration: Format.animationMedium;
                easing.type: Easing.OutCubic;
            }
        }
        popExit: Transition {
            YAnimator {
                from: 0; to: stackView.height;
                duration: Format.animationMedium;
                easing.type: Easing.OutCubic;
            }
        }
    }

    Component {
        id: library;

        Item {
            Loader {
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;
                anchors.bottom: nowPlayingBar.top;
                sourceComponent: {
                    switch(main.state) {
                    case "songs": return songs;
                    case "artists": return artists;
                    case "albums": return albums;
                    case "playlists": return playlists;
                    }
                }
            }

            NowPlayingBar {
                id: nowPlayingBar;

                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: footer.top;
                onClicked: stackView.push(nowPlaying);
            }

            Rectangle {
                id: footer;

                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                height: Format.footer;
                color: Palette.color_background;

                RowLayout {
                    height: parent.height;
                    width: Format.getColumnSpan(4);
                    anchors.horizontalCenter: parent.horizontalCenter;

                    Item {
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        IconButton {
                            icon: "\uE405"; //Material.io music note
                            anchors.centerIn: parent;
                            size: parent.height * 0.5;
                            selected: main.state == "songs";
                            onClicked: main.state = "songs";
                        }
                    }

                    Item {
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        IconButton {
                            icon: "\uE7FD"; //Material.io person
                            anchors.centerIn: parent;
                            size: parent.height * 0.5;
                            selected: main.state == "artists";
                            onClicked: main.state = "artists";
                        }
                    }

                    Item {
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        Logo {
                            width: height;
                            height: parent.height;
                            circleVisible: false;
                            tagColor: Palette.spotify;
                            tagOpacity: 1;
                            anchors.centerIn: parent;
                        }
                    }

                    Item {
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        IconButton {
                            icon: "\uE019"; //Material.io album
                            anchors.centerIn: parent;
                            size: parent.height * 0.5;
                            selected: main.state == "albums";
                            onClicked: main.state = "albums";
                        }
                    }

                    Item {
                        Layout.fillWidth: true;
                        Layout.fillHeight: true;

                        IconButton {
                            icon: "\uE05F"; //Material.io playlist play
                            anchors.centerIn: parent;
                            size: parent.height * 0.5;
                            selected: main.state == "playlists";
                            onClicked: main.state = "playlists";
                        }
                    }
                }
            }
        }
    }

    Component {
        id: songs;
        Songs {}
    }

    Component {
        id: artists;
        Artists {}
    }

    Component {
        id: albums;
        Albums{}
    }

    Component {
        id: playlists;
        Label { text: "PLAYLISTS" }
    }

    Component {
        id: nowPlaying;

        NowPlaying {
            onBackButtonClicked: stackView.pop();
        }
    }
}
