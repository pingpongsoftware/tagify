import QtQuick 2.8
import palette 1.0
import format 1.0
import "../ui/controls"
import "../ui/design"

Item {
    Logo {
        id: logo;
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        width: Format.getColumnSpan(4);
        height: width;
        circleVisible: false;
        tagColor: Palette.spotify;
    }

    Text {
        anchors.top: logo.bottom;
        anchors.topMargin: Format.marginStandard;
        anchors.horizontalCenter: parent.horizontalCenter;
        text: "Welcome to Tagify";
        color: Palette.color_textPrimary;
        font.pixelSize: Format.textMedium;
    }

    Button {
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: Format.marginLarge;
        anchors.horizontalCenter: parent.horizontalCenter;
        width: Format.buttonWidthMedium;
        onClicked: SpotifyWrapper.signIn();
        text: "Sign In";
        font.bold: true;
    }
}
