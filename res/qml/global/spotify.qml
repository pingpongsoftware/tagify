pragma Singleton
import QtQuick 2.8
import settings 1.0

Item {
    id: spotify;

    state: "testingToken";

    signal userDataLoaded;

    property var currentUser;
    property var playlists: [];
    property var albums: [];
    property var artists: ({});
    property var songs: [];
    property var devices;
    property var primaryDevice;
    property var artistIds: [];

    property real currentSongProgress;
    property int currentSongDuration;
    property bool isPlaying: false;
    property int requestInterval: 1000;
    property var nowPlaying;

    function getMinutesString(ms) {
        var min = Math.floor(ms / 60000).toString();
        var sec = (Math.floor(ms / 1000) % 60).toString();
        if (sec.length == 1) {
            sec = "0" + sec;
        }
        return min + ":" + sec;
    }

    function initialize() {
        getCurrentUser();
        getDevices();
        getAllSongs(function() { spotify.state = "initialized"; })
    }

    function getCurrentUser(callback) {
        callback = callback || function(response) {
            currentUser = JSON.parse(response);
        };
        SpotifyWrapper.get("https://api.spotify.com/v1/me", callback);
    }

    function getDevices(callback) {
        callback = callback || function(response) { devices = JSON.parse(response).devices; }
        SpotifyWrapper.get("https://api.spotify.com/v1/me/player/devices", callback);
    }

    function getPlayerContext(callback) {
        callback = callback || function(response) {
            var data = JSON.parse(response);
            isPlaying = data.is_playing;
            currentSongDuration = data.item.duration_ms;
            currentSongProgress = data.progress_ms / data.item.duration_ms;
        }
        SpotifyWrapper.get('https://api.spotify.com/v1/me/player', callback);
    }

    function getArtist(artistId, callback) {
        SpotifyWrapper.get("https://api.spotify.com/v1/artists/" + artistId, callback)
    }

    function getAllSongs(callback) {
        function getSongs(offset, limit, interval) {
            if (limit === 0 || offset <= limit) {
                SpotifyWrapper.get("https://api.spotify.com/v1/me/tracks?limit=" + interval + "&offset=" + offset, function(response) {
                    var data = JSON.parse(response);
                    limit = data.total;
                    extrapolateDataFromSongs(data.items);
                    getSongs(offset + interval, limit, interval);
                });
            } else if (offset >= limit) {
//                getAllArtists();
                callback();
            }
        }

        getSongs(0, 0, 10);
    }

    function getAllArtists() {
        function getArtists(count, index) {
            if (index < artistIds.length) {
                var maxIndex = Math.min(index + count, artistIds.length - 1);
                console.log(maxIndex);
                var ids = JSON.stringify(artistIds.slice(index, index + count));
                ids = ids.substring(1, ids.length - 1).split('"').join("");
                console.log(ids)
                SpotifyWrapper.get("https://api.spotify.com/v1/artists?ids=" + ids, function(response) {
                    console.log(response);
                    getArtist(count, index + count);
                });
            }
        }

        getArtists(50, 0);
    }

    function extrapolateDataFromSongs(songArray) {
        for (var i in songArray) {
            var albumData = songArray[i].track.album;
            var artistData = songArray[i].track.artists;
            songs.push(songArray[i].track);

            var song = {
                "name": songArray[i].track.name,
                "id": songArray[i].track.id,
                "uri": songArray[i].track.uri,
                "track_number": songArray[i].track.track_number,
                "album": JSON.parse(JSON.stringify(albumData)),
                "artists": JSON.parse(JSON.stringify(artistData))
            }

            var albumIndex = indexOf(albumData.id, albums);
            if (albumIndex >= 0) {
                albums[albumIndex].songs.push(song);
            } else {
                albums.push({
                    "name": albumData.name,
                    "artists": albumData.artists,
                    "id": albumData.id,
                    "uri": albumData.uri,
                    "images": albumData.images,
                    "songs": [song]
                });
            }

            for (var ai in artistData) {
                var artistIndex = indexOf(artistData[ai].id, artists);
                if (artistIds.indexOf(artistData[ai].id) < 0) {
                    artistIds.push(artistData[ai].id);
                }
            }
        }
    }

    function indexOf(spotifyId, array) {
        for (var i in array) {
            if (array[i].id === spotifyId) {
                return i;
            }
        }
        return -1;
    }

    function getNowPlaying(callback) {
        callback = callback || function(response) {
            var data = JSON.parse(response);
            currentSongDuration = data.item.duration_ms;
            currentSongProgress = data.progress_ms;
            isPlaying = data.is_playing;
            nowPlaying = data.item;
        }
        SpotifyWrapper.get("https://api.spotify.com/v1/me/player/currently-playing", callback);
    }


    function setCurrentSongPosition(newPosition, callback) {
        callback = callback || function(){}
        SpotifyWrapper.put("https://api.spotify.com/v1/me/player/seek?position_ms=" + newPosition, "", callback);
    }

    function togglePlayback(callback) {
        SpotifyWrapper.put('https://api.spotify.com/v1/me/player/' + (isPlaying ? "pause" : "play"), '', function(code){
            if (code === "204") {
                isPlaying = !isPlaying;
            }
            if (typeof callback == "function") {
                callback(response);
            }
        });
    }

    Timer {
        id: nowPlayingRequestTimer;

        repeat: true;
        running: spotify.state == "initialized";
        interval: spotify.requestInterval;

        onTriggered: {
            getNowPlaying();
        }
    }
}
