import QtQuick 2.8
import format 1.0
import palette 1.0

Text {
    color: Palette.color_textPrimary;
    font.family: materialFont.name;
    horizontalAlignment: Text.AlignHCenter;
    verticalAlignment: Text.AlignVCenter;
    font.pixelSize: size;

    property real size;

    FontLoader {
        id: materialFont;
        source: "../../../icons/MaterialIcons-Regular.ttf";
    }
}
