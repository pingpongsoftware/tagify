import QtQuick 2.9
import QtQuick.Layouts 1.3
import format 1.0
import palette 1.0

import "../ui/controls"
import "../ui/design"

Rectangle {
    id: footer;

    signal newState(string newState);
    onStateChanged: console.log(state)

    height: Format.footer;
    color: Palette.color_background2;

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
