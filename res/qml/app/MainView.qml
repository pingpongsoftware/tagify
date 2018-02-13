import QtQuick 2.8
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2 as C

import spotify 1.0
import palette 1.0
import format 1.0
import settings 1.0
import "../ui/design"
import "../ui/controls"

Rectangle {
    id: main;

    state: "songs";
    color: Palette.color_background;

    C.StackView {
        id: stackView;

        anchors.fill: parent;
        initialItem: mainComponent
    }

    Component {
        id: mainComponent;

        Item {
            Loader {
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;
                anchors.bottom: footer.top;
                anchors.bottomMargin: nowPlaying.closedHeight;
                sourceComponent: {
                    switch(main.state) {
                    case "songs": return songs;
                    case "artists": return artists;
                    case "albums": return albums;
                    case "playlists": return playlists;
                    }
                }
            }

            LibraryFooter {
                id: footer;

                state: main.state;
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                onNewState: main.state = newState;
                onTagifyClicked: stackView.push(tagView);
            }

            NowPlaying {
                id: nowPlaying;

                state: "bar"
                anchors.fill: parent;
            }
        }
    }

    Component {
        id: songs;
        Songs {}
    }

    Component {
        id: artists;
        Artists {}
    }

    Component {
        id: albums;
        Albums{}
    }

    Component {
        id: playlists;
        Label { text: "PLAYLISTS" }
    }

    Component {
        id: tagView;
        TagView {}
    }
}
