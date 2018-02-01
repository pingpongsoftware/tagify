import QtQuick 2.9
import palette 1.0;
import format 1.0;

Text {
    color: Palette.color_textPrimary;
    font.pointSize: Math.max(size, 1);
    font.weight: Font.Light;

    property real size: Format.textBody;
}
