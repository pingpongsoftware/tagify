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

    property var activeTags: [];
    property string tagifyFilter: {
        var baseString = "instr(tags, '" + "&" + "') > 0";;
        var finalString = "";
        for (var i in activeTags) {
            finalString += baseString.replace("&", activeTags[i]) + ' AND ';
        }
        return finalString.slice(0, -5);
    }

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
//        spotify.state = "initialized";
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

    function getAlbums(albumIds, callback) {
        SpotifyWrapper.get("https://api.spotify.com/v1/albums?ids=" + albumIds.join(','), callback);
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
                callback();
            }
        }

        getSongs(0, 0, 10);
    }

    function getAudioFeatures(songIds, callback) {
        callback = callback || function() {};
        SpotifyWrapper.get("https://api.spotify.com/v1/audio-features?ids=" + songIds.join(','), callback);
    }

    function extrapolateDataFromSongs(songArray) {
        var songIds = [];
        var albumIds = [];

        for (var i in songArray) {
            var track = songArray[i].track;
            var album = track.album;
            var artist = track.artists[0];
            songIds.push(track.id);
            albumIds.push(album.id);

            DBManager.addSong(track.id, track.name, album.id, album.name, artist.id, artist.name, "");
            DBManager.addAlbum(album.id, album.name, album.images[0].url, album.artists[0].id, album.artists[0].name);
            DBManager.addArtist(artist.id, artist.name)
        }

        getAudioFeatures(songIds, function(response) {
            var data = JSON.parse(response);
            for (var i in data.audio_features) {
                generateTag(data.audio_features[i]);
            }
        });

        getAlbums(albumIds, function(response) {
            var data = JSON.parse((response));
            for (var i in data.albums) {
                generateAlbumTags(data.albums[i]);
            }
        });
    }

    property int count: 0;
    property int totalTempo;

    function generateTag(audioFeatures) {
        if (audioFeatures.acousticness > 0.5) {
            DBManager.addTag(audioFeatures.id, "Acoustic");
        }

        if (audioFeatures.danceability > 0.5) {
            DBManager.addTag(audioFeatures.id, "Dance");
        }

        if (audioFeatures.energy > 0.5) {
            DBManager.addTag(audioFeatures.id, "Pump up");
        }

        if (audioFeatures.instrumentalness > 0.5) {
            DBManager.addTag(audioFeatures.id, "Instrumental");
        }

        if (audioFeatures.liveness > 0.5) {
            DBManager.addTag(audioFeatures.id, "Live");
        }

        if (audioFeatures.loudness > -5) {
            DBManager.addTag(audioFeatures.id, "Loud");
        } else if (audioFeatures.loudness < -20) {
            DBManager.addTag("Quiet");
        }

        if (audioFeatures.tempo > 120) {
            DBManager.addTag("Upbeat");
        } else if (audioFeatures.temp < 110) {
            DBManager.addTag("Slow");
        }

        if (audioFeatures.valence > 0.5) {
            DBManager.addTag("Happy");
        } else if (audioFeatures.valence < 0.5) {
            DBManager.addTag("Moody");
        }
    }

    function generateAlbumTags(album) {
        var year = parseInt(album.release_date.substring(0, 4));
        if (year < 2000 && year >= 1950) {
            var yearStr = "";
            if (year >= 1990) yearStr = "90''s";
            else if (year >= 1980) yearStr = "80''s";
            else if (year >= 1970) yearStr = "70''s";
            else if (year >= 1960) yearStr = "60''s";
            else if (year >= 1950) yearStr = "50''s";
            DBManager.addAlbumTag(album.id, yearStr);
        }
        console.log(album.genres);
        for (var i in album.genres) {
            console.log(album.genres[i]);
            DBManager.addAlbumTag(album.id, album.genres[i]);
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
