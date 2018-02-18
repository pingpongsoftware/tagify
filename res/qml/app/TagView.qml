import QtQuick 2.8
import com.pps.tagify 1.0

import spotify 1.0
import palette 1.0
import format 1.0
import "../ui/controls"
import "../ui/design"

Rectangle {
    color: palette.color_background;

    IconButton {
        id: backButton;

        icon: "\uE5C4";
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.margins: Format.marginSmall;
        onClicked: stackView.pop();
    }

    ListView {
        anchors.top: backButton.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        model: SqlListModel {
            table: "tags";
            roles: ["tagName"];
        }

        delegate: Item {
            id: tagItem;

            height: 60;
            anchors.left: parent.left;
            anchors.right: parent.right;

            property bool active: index >= 0;
            property int index: Spotify.activeTags.indexOf(tagName);

            Logo {
                id: logo;

                width: height;
                height: tagLabel.height * 1.25;
                anchors.left: parent.left;
                circleVisible: false;
                tagColor: tagItem.active ? Palette.spotify : Palette.color_textSecondary;
                anchors.leftMargin: Format.marginStandard;
                anchors.verticalCenter: parent.verticalCenter;

                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        if (tagItem.active) {
                            Spotify.activeTags.splice(tagItem.index, 1);
                        } else {
                            Spotify.activeTags.push(tagName);
                        }
                        Spotify.activeTagsChanged();
                    }
                }
            }

            Label {
                id: tagLabel;

                anchors.left: logo.right;
                anchors.verticalCenter: parent.verticalCenter;
                size: Format.textSmall;
                text: tagName.replace("''", "'");
            }
        }
    }
}
