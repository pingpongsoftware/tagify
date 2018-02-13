import QtQuick 2.8
import com.pps.tagify 1.0

import format 1.0
import spotify 1.0
import palette 1.0
import "../ui/controls"

ListView {
    model: SqlListModel {
        table: "artists";
        roles: ["artistId", "artistName"];
    }

    delegate: Item {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 60;

        Label {
            text: artistName;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: Format.marginStandard;
            size: Format.textSmall;
        }
    }
}
