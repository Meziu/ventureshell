pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../../libraries/yaml.min.js" as Yaml

Singleton {
    id: root

    readonly property url baseUrl: "https://lrclib.net"
    readonly property url apiUrl: baseUrl + "/api"
    readonly property url getLyricsUrl: apiUrl + "/get"

    property bool canSend: true
    property var lyrics
    readonly property bool isInstrumental: lyrics?.metadata.instrumental ?? true
    readonly property bool hasLines: (!isInstrumental && lyrics?.lines) ?? false

    Timer {
        id: retryLimiter

        onTriggered: root.canSend = true
    }

    function buildUrl(base, params): url {
        const parts = []
        for (const key in params) {
            const value = params[key]
            if (value === undefined || value === null) continue
            parts.push(encodeURIComponent(key) + "=" + encodeURIComponent(String(value)))
        }
        return parts.length ? base + "?" + parts.join("&") : base
    }

    function getTrackURL(trackName: string, artistName: string, albumName: string, duration: int): url {
        return buildUrl(getLyricsUrl, {track_name: trackName, artist_name: artistName, album_name: albumName !== "" ? albumName : undefined, duration: duration > 0 ? duration : undefined})
    }

    // Pass "" for albumName and 0 or negative for duration to not specify them
    // trackName and artistName MUST be present.
    function queryTrack(trackName: string, artistName: string, albumName: string, duration: int) {
        if (!root.canSend) {
            console.warn("Cannot get lyrics. Currently rate limited.")
        }

        try {
            let r = new XMLHttpRequest();
            r.onreadystatechange = function() {
                if (r.readyState === XMLHttpRequest.DONE) {
                    let response = {
                        status: r.status,
                        timeout: r.getResponseHeader("retry-after"),
                        headers: r.getAllResponseHeaders(),
                        contentType: r.responseType,
                        content: r.response
                    };

                    // Rate limiting
                    if (response.status === 429) {
                        root.canSend = false

                        let timeout = parseInt(response.timeout)
                        retryLimiter.interval = timeout * 1000
                        retryLimiter.start()
                        return
                    }

                    // Not found
                    if (response.status === 404) {
                        console.warn("Requested track was not found")
                        return
                    }

                    let contentObject = JSON.parse(response.content)
                    root.lyrics = Yaml.parse(contentObject.lyricsfile);
                }
            }

            root.lyrics = null

            r.open("GET", getTrackURL(trackName, artistName, albumName, duration));
            // As per user agreement
            r.setRequestHeader("User-Agent", "ventureshell v0.1.0 (https://github.com/Meziu/ventureshell)");
            r.send();
        } catch (e) {
            console.error(e);
        }
    }

    // Get line at time in seconds
    function getLineAt(time: real): string {
        let defaultLine = "[instrumental]"
        if (isInstrumental) {
            return defaultLine
        }

        if (!hasLines) {
            return ""
        }

        let timems = Math.floor(time * 1000)

        for (let i = 0; i < root.lyrics.lines.length; i++) {
            let line = root.lyrics.lines[i]
            let next_line = root.lyrics.lines[i+1]

            if (timems >= line.start_ms) {
                if (next_line && timems >= next_line.start_ms) {
                    continue
                }

                return line.text !== "" ? line.text : defaultLine
            }
        }

        return defaultLine
    }
}
