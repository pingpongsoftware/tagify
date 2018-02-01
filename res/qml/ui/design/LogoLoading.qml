import QtQuick 2.8

Item {
    id: loading;

    property int animDuration: 200;
    property int easingType: Easing.Linear;

    Logo {
        id: logo1;
        anchors.fill: parent;

        tagColor: "gray";
        circleVisible: false;
        endPath1: 0;
        endPath2: 0;
        endPath3: 0;
        endPath4: 0;
    }

    Logo {
        id: logo2;
        anchors.fill: parent;

        tagOpacity: 1;
        tagColor: spotifyGreen;
        circleVisible: false;
        endPath1: 0;
        endPath2: 0;
        endPath3: 0;
        endPath4: 0;
    }

    SequentialAnimation {
        running: true;
        loops: Animation.Infinite;

        PropertyAnimation { target: logo1; property: "endPath1"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo1; property: "endPath2"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo1; property: "endPath3"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo1; property: "endPath4"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }

        PropertyAnimation { target: logo2; property: "endPath1"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo2; property: "endPath2"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo2; property: "endPath3"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo2; property: "endPath4"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }

        PropertyAnimation { target: logo2; property: "startPath1"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo2; property: "startPath2"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo2; property: "startPath3"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo2; property: "startPath4"; to: logo2.targetPathLength; duration: animDuration; easing.type: easingType; }

        PropertyAnimation { target: logo1; property: "startPath1"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo1; property: "startPath2"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo1; property: "startPath3"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }
        PropertyAnimation { target: logo1; property: "startPath4"; to: logo1.targetPathLength; duration: animDuration; easing.type: easingType; }

        PropertyAnimation { targets: [logo1, logo2]; properties: "endPath1, endPath2, endPath3, endPath4"; to: 0; duration: 0; }
        PropertyAnimation { targets: [logo1, logo2]; properties: "startPath1, startPath2, startPath3, startPath4"; to: 0; duration: 0; }
    }
}
