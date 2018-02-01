import QtQuick 2.0
import palette 1.0
import spotify 1.0
import settings 1.0
import format 1.0
import "../ui/controls"

Item {
    Rectangle {
        anchors.fill: parent;
        color: Palette.color_background;
        opacity: 0.5;
    }

    MouseArea { anchors.fill: parent; }

    Rectangle {
        width: Format.getColumnSpan(4);
        height: width;
        anchors.centerIn: parent;
        color: Palette.color_background;

        ListView {
            anchors.fill: parent;
            model: Spotify.devices;
            anchors.margins: Format.marginStandard;

            header: Label {
                height: Format.basicUnit * 3;
                text: "Which device are you using this app on?"
                anchors.horizontalCenter: parent.horizontalCenter;
                verticalAlignment: Text.AlignVCenter;
                font.pointSize: Format.textCaption;
            }

            delegate: MouseArea {
                anchors.left: parent.left;
                anchors.right: parent.right;
                height: Format.basicUnit * 4;
                onClicked: {
                    Settings.userSettings.preferredDevice = modelData.id;
                    Settings.userSettingsChanged();
                    console.log(JSON.stringify(Settings.userSettings));
                }

                Label {
                    text: modelData.name;
                    anchors.verticalCenter: parent.verticalCenter;
                    color: modelData.is_active ? Palette.color_textPrimary : Palette.color_textSecondary;
                }
            }
        }
    }
}
