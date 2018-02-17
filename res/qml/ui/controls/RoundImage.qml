import QtQuick 2.9
import QtGraphicalEffects 1.0

Item {
    property alias image: _image;

    Image {
        id: _image;
        anchors.fill: parent;
        visible: false;
    }

    Rectangle {
        id: mask;
        anchors.fill: parent;
        radius: Math.max(width, height) / 2;
        visible: false;
    }

    OpacityMask {
        anchors.fill: image;
        source: image;
        maskSource: mask;
    }
}
