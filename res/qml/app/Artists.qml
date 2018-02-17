import QtQuick 2.8
import com.pps.tagify 1.0

import format 1.0
import spotify 1.0
import palette 1.0
import "../ui/controls"

ListView {
    model: SqlListModel {
        table: "artists";
        roles: ["artistId", "artistName", "artistImage"];
    }

    delegate: Item {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 60;

        RoundImage {
            id: icon;

            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.margins: Format.marginSmall;
            anchors.leftMargin: Format.marginStandard;
            width: height;
            image.source: artistImage;
            image.asynchronous: true;
        }

        Label {
            text: artistName;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: icon.right;
            anchors.leftMargin: Format.marginStandard;
            size: Format.textSmall;
        }
    }
}
