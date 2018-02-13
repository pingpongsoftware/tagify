import QtQuick 2.9
import QtQuick.Shapes 1.0
import palette 1.0
import format 1.0

MouseArea {
    id: main;

    opacity: pressed ? Palette.pressedOpacity : releasedOpacity;

    property real releasedOpacity: 1;

    readonly property real strokeWidth: width / 8;

    Rectangle {
        id: border;
        anchors.fill: parent;
        border.width: 1;
        radius: width / 2;
        color: "transparent";
        border.color: Palette.color_textPrimary;
    }

    Shape {
        id: shape;

        anchors.fill: parent;
        anchors.margins: parent.width * 0.35;

        ShapePath {
            id: path;

            strokeWidth: shape.width / 10;
            strokeColor: Palette.color_textPrimary;
            fillColor: Palette.color_textPrimary;
            fillRule: ShapePath.WindingFill;
            joinStyle: ShapePath.RoundJoin;
            startX: 0; startY: 0;
            PathLine { x: shape.width; y: shape.height / 2; }
            PathLine { x: 0; y: shape.height }
            PathLine { x: 0; y: 0 }
        }
    }

    Rectangle {
        anchors.left: shape.right;
        height: shape.height;
        width: path.strokeWidth;
        anchors.verticalCenter: shape.verticalCenter;
        color: Palette.color_textPrimary;
    }
}
