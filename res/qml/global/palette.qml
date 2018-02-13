pragma Singleton
import QtQuick 2.8

Item {
    id: palette;

    state: "spotify-light";

    readonly property color spotify: "#1ED760";

    property color color_background;
    property color color_background2;
    property color color_background3;
    property color color_button;
    property color color_buttonActive;
    property color color_textPrimary;
    property color color_textSecondary;
    property color color_textButton;
    property color color_logoCirclePrimary;
    property color color_logoTagPrimary;
    property color color_logoCircleSecondary;
    property color color_logoTagSecondary;
    property color color_logoTagNoCircle;
    property color color_iconButton;
    property color color_iconButtonHighlighted;
    property color color_nowPlayingOverlay;

    property real pressedOpacity;
    property real nowPlayingOverlayOpacity;

    property string nowPlayingOverlayMode;

    states: [
        State {
            name: "spotify-dark";

            PropertyChanges {
                target: palette;

                color_background: "#151515";
                color_background2: "#202020";
                color_button: spotify;
                color_buttonActive: Qt.lighter(color_button, 1.1);
                color_textPrimary: "#f1f1f1";
                color_textSecondary: "#d4d4d4";
                color_textButton: color_background;
                color_logoCirclePrimary: spotify;
                color_logoTagPrimary: color_background;
                color_logoCircleSecondary: color_textPrimary;
                color_logoTagSecondary: color_background;
                color_logoTagNoCircle: spotify;
                color_iconButton: color_textPrimary;
                color_iconButtonHighlighted: Qt.lighter(palette.spotify, 1.5);
                color_nowPlayingOverlay: "#707070";

                pressedOpacity: 0.5;
                nowPlayingOverlayOpacity: 1.0;
                nowPlayingOverlayMode: "multiply";
            }
        },
        State {
            name: "spotify-light";

            PropertyChanges {
                target: palette;

                color_background: "#efefef";
                color_background2: "#cfcfcf";
                color_button: spotify;
                color_buttonActive: Qt.lighter(color_button, 1.1);
                color_textPrimary: "#353535";
                color_textSecondary: "#484848";
                color_textButton: color_background;
                color_logoCirclePrimary: spotify;
                color_logoTagPrimary: color_background;
                color_logoCircleSecondary: color_textPrimary;
                color_logoTagSecondary: color_background;
                color_logoTagNoCircle: spotify;
                color_iconButton: color_textPrimary;
                color_iconButtonHighlighted: Qt.darker(palette.spotify, 1.5);
                color_nowPlayingOverlay: "white";

                pressedOpacity: 0.5;
                nowPlayingOverlayOpacity: 0;
                nowPlayingOverlayMode: "average";
            }
        }
    ]
}
