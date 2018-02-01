import QtQuick 2.8
import QtQuick.Shapes 1.0

Item {
    id: logo;
    width: 100;
    height: 100;
    state: "hidden";

    property color tagColor: "black";
    property alias tagOpacity: tag.opacity;
    property alias circleVisible: circle.visible;
    property alias circleColor: circle.color;

    readonly property color spotifyGreen: "#1ED760";

    property real startPath1: 0;
    property real endPath1: targetPathLength;
    property real startPath2: 0;
    property real endPath2: targetPathLength;
    property real startPath3: 0;
    property real endPath3: targetPathLength;
    property real startPath4: 0;
    property real endPath4: targetPathLength;

    readonly property real targetPathLength: tag.width;
    property alias tagWidth: tag.height;

    Rectangle {
        id: circle;

        color: spotifyGreen;
        radius: height/2;
        anchors.fill: parent;
    }

    Shape {
        id: tag;
        anchors.fill: parent;
        anchors.margins: parent.width*0.24;
        rotation: 20;
        opacity: 0.8;

        ShapePath {
            id: path1;

            strokeColor: tagColor;
            strokeWidth: tag.width/8;
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: tag.width*0.3;
            startY: startPath1;

            PathLine { x: path1.startX; y: endPath1; }
        }

        ShapePath {
            id: path2;

            strokeColor: tagColor;
            strokeWidth: tag.width/8;
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: tag.width - tag.width*0.3;
            startY: startPath2;

            PathLine { x: path2.startX; y: endPath2; }
        }

        ShapePath {
            id: path3;

            strokeColor: tagColor;
            strokeWidth: tag.width/8;
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: startPath3;
            startY: tag.height*0.3;
            PathLine { x: endPath3; y: path3.startY; }
        }

        ShapePath {
            id: path4;
            strokeColor: tagColor;
            strokeWidth: tag.width/8;
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: startPath4;
            startY: tag.height - tag.height*0.3;

            PathLine { x: endPath4; y: path4.startY; }
        }
    }
}
