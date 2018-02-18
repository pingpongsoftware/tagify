import QtQuick 2.9
import QtQuick.Controls 2.2 as C
import com.pps.tagify 1.0

import spotify 1.0
import palette 1.0
import format 1.0
import "../ui/controls"

ListView {
    clip: true;
    headerPositioning: ListView.PullBackHeader;

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

        Column {
            anchors.left: parent.left;
            anchors.leftMargin: Format.marginStandard;
            anchors.verticalCenter: parent.verticalCenter;

            Label {
                text: songName;
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
