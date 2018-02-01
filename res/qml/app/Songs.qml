import QtQuick 2.9
import spotify 1.0
import palette 1.0
import format 1.0
import "../ui/controls"

ListView {
    model: Spotify.songs;

    delegate: Item {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 60;

        Label {
            text: modelData.name;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: Format.marginStandard;
            size: Format.textSmall;
        }
    }
}
