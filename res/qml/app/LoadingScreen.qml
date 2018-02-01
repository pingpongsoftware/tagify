import QtQuick 2.8
import format 1.0
import "../ui/design"

Item {
    LogoLoading {
        id: loadingIcon;
        anchors.centerIn: parent;
        width: Format.getColumnSpan(4);
        height: width;
    }

    Text {
        anchors.top: loadingIcon.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        font.pixelSize: Format.textBody;
        text: "Loading..."
    }
}
