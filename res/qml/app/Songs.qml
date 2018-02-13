import QtQuick 2.9
import QtQuick.Controls 2.2 as C
import com.pps.tagify 1.0

import spotify 1.0
import palette 1.0
import format 1.0
import "../ui/controls"

ListView {
//    headerPositioning: ListView.PullBackHeader;
    headerPositioning: ListView.OverlayHeader;

    property string nameFilter: "";
    property string currentId: "";
    onCurrentIdChanged: console.log(currentId);

    header: C.TextField {
        id: filterField;
        anchors.right: parent.right;
        anchors.left: parent.left;
        onTextChanged: nameFilter = text;
        onFocusChanged: if (!focus) { forceActiveFocus(); }
        Keys.onReturnPressed: {
            console.log("RETURN PRESSED");
            DBManager.addTag(currentId, text);
        }

        z: 2;
    }

    model: SqlListModel {
        table: "songs";
        roles: ["songName", "songId", "tags", "artistName"];
        filterString: Spotify.tagifyFilter;
    }

    delegate: MouseArea {
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 60;

        onClicked: currentId = songId;

        Label {
            id: songLabel;

            text: songName;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: Format.marginStandard;
            size: Format.textSmall;
        }

        Label {
            id: artistLabel;

            text: artistName;
            anchors.top: songLabel.bottom;
            anchors.left: songLabel.left;
            size: Format.textTiny;
            color: Palette.color_textSecondary;
        }

        Label {
            text: tags;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.right: songLabel.left;
            anchors.rightMargin: Format.marginLarge;
//            color: Palette.color_textSecondary;
//            size: Format.textTiny;
        }
    }
}
