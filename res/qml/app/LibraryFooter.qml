import QtQuick 2.9
import QtQuick.Layouts 1.3
import format 1.0
import palette 1.0
import spotify 1.0

import "../ui/controls"
import "../ui/design"

Rectangle {
    id: footer;

    signal newState(string newState);
    signal tagifyClicked();

    property alias rowLayout: rowLayout;

    height: Format.footer;
    color: Palette.color_background2;

    RowLayout {
        id: rowLayout;

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
                selected: footer.state == "songs";
                onClicked: newState("songs");
            }
        }

        Item {
            Layout.fillWidth: true;
            Layout.fillHeight: true;

            IconButton {
                icon: "\uE7FD"; //Material.io person
                anchors.centerIn: parent;
                size: parent.height * 0.5;
                selected: footer.state == "artists";
                onClicked: newState("artists");
            }
        }

        Item {
            Layout.fillWidth: true;
            Layout.fillHeight: true;

            MouseArea {
                anchors.fill: parent;
                onClicked: Spotify.tagsActive = !Spotify.tagsActive;

                Logo {
                    width: height;
                    height: parent.height;
                    circleVisible: false;
                    tagColor: Spotify.tagsActive ? Palette.spotify : Palette.color_inactive;
                    tagOpacity: 1;
                    anchors.centerIn: parent;
                }

            }
        }

        Item {
            Layout.fillWidth: true;
            Layout.fillHeight: true;

            IconButton {
                icon: "\uE019"; //Material.io album
                anchors.centerIn: parent;
                size: parent.height * 0.5;
                selected: footer.state == "albums";
                onClicked: newState("albums");
            }
        }

        Item {
            Layout.fillWidth: true;
            Layout.fillHeight: true;

            IconButton {
                icon: "\uE05F"; //Material.io playlist play
                anchors.centerIn: parent;
                size: parent.height * 0.5;
                selected: footer.state == "playlists";
                onClicked: newState("playlists");
            }
        }
    }
}
