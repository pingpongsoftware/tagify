import QtQuick 2.8
import com.pps.tagify 1.0
import QtQuick.Controls 2.2 as C

import format 1.0
import spotify 1.0
import palette 1.0
import "../ui/controls"

ListView {
    id: artistsList;

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

    header: Rectangle {
        anchors.right: parent.right;
        anchors.left: parent.left;
        height: Format.header;

        C.TextField {
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            anchors.margins: Format.marginStandard;
            activeFocusOnPress: true;
            onTextChanged: artistsModel.filterString = "instr(artistName, '" + text + "') > 0";
        }
    }

    model: SqlListModel {
        id: artistsModel;

        table: "artists";
        roles: ["artistId", "artistName", "artistImage"];
        Component.onCompleted: {
            sortTable("artistName", Qt.AscendingOrder, Qt.CaseInsensitive);
            artistsList.positionViewAtIndex(0, ListView.Beginning)
        }
    }

    delegate: Item {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: Format.listItem;

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
