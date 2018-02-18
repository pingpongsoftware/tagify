pragma Singleton
import QtQuick 2.8
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Item {
    id: format;

    property ApplicationWindow window;

    property int screenWidth: window ? window.width : 0;
    property int screenHeight: window ? window.height : 0;

    property real columnWidth: ((screenWidth - gutter * 2) - (gutter * (columnCount - 1))) / columnCount;
    property int columnCount: {
        if (screenWidth < 600) {
            return 4;
        } else if (screenWidth < 840) {
            return 8;
        } else {
            return 12;
        }
    }

    property real basicUnit: 8;
    property real gutter: basicUnit;
    property real marginTiny: basicUnit / 2;
    property real marginSmall: basicUnit;
    property real marginStandard: basicUnit * 2;
    property real marginMedium: basicUnit * 3;
    property real marginLarge: basicUnit * 4;

    property real buttonWidthSmall: getColumnSpan(1);
    property real buttonWidthStandard: getColumnSpan(2);
    property real buttonWidthMedium: getColumnSpan(3);
    property real buttonWidthLarge: getColumnSpan(4);

    property real buttonHeightSmall: 20;
    property real buttonHeightStandard: 40;
    property real buttonHeightMedium: 60;
    property real buttonHeightLarge: 80;

    property real textTiny: 8;
    property real textSmall: 10;
    property real textCaption: 12;
    property real textButton: 14;
    property real textBody: 14;
    property real textSubheading: 16;
    property real textTitle: 20;
    property real textHeadline: 24;
    property real textDisplay1: 34;
    property real textDisplay2: 45;
    property real textDisplay3: 56;
    property real textDisplay4: 112;

    property real header: 60;
    property real footer: 50;
    property real listSectionHeader: 60;
    property real listItem: 60;

    property int animationMedium: 500;

    function getColumnSpan(columns) {
        return columnWidth * columns + gutter * (columns - 1);
    }

    Item {
        id: privates;

        property real columnWidth;
    }
}
