import QtQuick 2.8
import format 1.0
import spotify 1.0
import palette 1.0
import "../ui/controls"

ListView {
    model: Spotify.artists;

    delegate: Item {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 60;

        Image {
            id: icon;

            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.margins: Format.marginStandard;
            width: height;
            source: modelData.images[0] ? modelData.images[0].url : "";
            asynchronous: true;
        }

        Label {
            text: modelData.name;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: icon.right;
            anchors.leftMargin: Format.marginStandard;
            size: Format.textSmall;
        }
    }
}
