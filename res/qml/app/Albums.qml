import QtQuick 2.8
import com.pps.tagify 1.0

import format 1.0
import spotify 1.0
import palette 1.0
import "../ui/controls"

ListView {
    section.property: "artistName";
    section.criteria: ViewSection.FirstCharacter;
    section.delegate: Item {
        anchors.left: parent.left;
        anchors.leftMargin: Format.marginStandard;
        height: Format.listSectionHeader;

        Label {
            text: section;
            anchors.bottom: parent.bottom;
        }
    }

    model: SqlListModel {
        table: "albums";
        roles: ["albumName", "artUrl", "artistId", "artistName"];
        Component.onCompleted: sortTable(section.property);
    }

    delegate: Item {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 60;

        Image {
            id: icon;

            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.margins: Format.marginSmall;
            anchors.leftMargin: Format.marginStandard;
            width: height;
            source: artUrl;
            asynchronous: true;
        }

        Column {
            anchors.left: icon.right;
            anchors.leftMargin: Format.marginStandard;
            anchors.verticalCenter: parent.verticalCenter;

            Label {
                text: albumName;
                size: Format.textSmall;
            }

            Label {
                text: artistName;
                size: Format.textTiny;
                color: Palette.color_textSecondary;
            }
        }
    }
}
