import QtQuick 2.8
import palette 1.0

MouseArea {
    width: iconItem.contentWidth;
    height: iconItem.contentHeight;
    opacity: pressed ? Palette.pressedOpacity : 1;

    property string icon;
    property bool selected: false;
    property alias size: iconItem.size;

    property color releasedColor: Palette.color_iconButton;
    property color pressedColor: Palette.color_iconButtonHighlighted;

    Icon {
        id: iconItem;

        text: icon;
        anchors.centerIn: parent;
        color: selected ? pressedColor : releasedColor;
    }
}
