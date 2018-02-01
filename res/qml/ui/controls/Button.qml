import QtQuick 2.8
import format 1.0
import palette 1.0

MouseArea {
    id: button;

    width: Format.buttonWidthStandard;
    height: Format.buttonHeightStandard;

    property alias text: textBox.text;
    property alias label: textBox;
    property alias font: textBox.font;

    property Component background: Rectangle {
        color: button.pressed ? Palette.color_button : Palette.color_buttonActive;
        radius: height/2;
    }

    Loader {
        anchors.fill: parent;
        sourceComponent: background;
    }

    Label {
        id: textBox;
        anchors.centerIn: parent;
        color: Palette.color_textButton;
        font.pixelSize: Format.textStandard;
        font.capitalization: Font.AllUppercase;
        font.letterSpacing: 1.2;
    }
}
