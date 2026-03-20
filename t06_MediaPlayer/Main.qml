import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import Qt.labs.platform as Platform
import QtMultimedia

ApplicationWindow {
    id: root
    width: 860
    height: 580
    minimumWidth: 620
    minimumHeight: 440
    visible: true
    title: "Media Player"

    Material.theme: Material.Dark
    Material.accent: Material.DeepPurple
    color: "#121212"

    MediaPlayer {
        id: mediaPlayer
        audioOutput: AudioOutput {
            id: audioOut
            volume: Math.pow(volumeSlider.value, 2)
            muted: muteBtn.checked
        }
        videoOutput: videoSurface

        onPositionChanged: {
            if (!seekBar.pressed)
                seekBar.value = duration > 0 ? position / duration : 0;
        }
        onPlaybackStateChanged: {
            if (playbackState === MediaPlayer.StoppedState)
                seekBar.value = 0;
        }
        onErrorOccurred: (error, errorString) => {
            statusLabel.text = "⚠  " + errorString;
        }
        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.LoadingMedia)
                statusLabel.text = "Loading…";
            else if (mediaStatus === MediaPlayer.LoadedMedia)
                statusLabel.text = "";
            else if (mediaStatus === MediaPlayer.InvalidMedia)
                statusLabel.text = "⚠  Invalid media source";
        }
    }

    Platform.FileDialog {
        id: fileDialog
        title: "Open Media File"
        nameFilters: ["Media files (*.mp4 *.mkv *.avi *.mov *.webm *.mp3 *.aac *.wav *.flac *.ogg)", "All files (*)"]
        onAccepted: {
            urlField.text = file.toString();
            loadAndPlay(file.toString());
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Video area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000"

            VideoOutput {
                id: videoSurface
                anchors.fill: parent
            }

            // ── Audio-only overlay ────────────────────────────────
            Rectangle {
                anchors.fill: parent
                color: "#0f0f1a"
                visible: mediaPlayer.playbackState == MediaPlayer.PlayingState && !mediaPlayer.hasVideo && mediaPlayer.source != ""

                Column {
                    anchors.centerIn: parent
                    spacing: 20

                    // Pulsing circle with music note
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 110
                        height: 110
                        radius: 55
                        color: Material.color(Material.DeepPurple, Material.Shade700)

                        SequentialAnimation on scale {
                            running: mediaPlayer.playbackState === MediaPlayer.PlayingState
                            loops: Animation.Infinite
                            NumberAnimation {
                                to: 1.12
                                duration: 700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                to: 1.00
                                duration: 700
                                easing.type: Easing.InOutSine
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "♪"
                            font.pixelSize: 52
                            color: "white"
                        }
                    }

                    // Filename / URL
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: mediaPlayer.source.toString().split("/").pop().split("?")[0]
                        color: "white"
                        font.pixelSize: 13
                        opacity: 0.6
                        elide: Text.ElideMiddle
                        width: 340
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Audio label
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "AUDIO"
                        color: Material.color(Material.DeepPurple, Material.Shade200)
                        font.pixelSize: 11
                        font.letterSpacing: 4
                        opacity: 0.5
                    }
                }
            }

            // ── Idle placeholder ──────────────────────────────────
            Column {
                anchors.centerIn: parent
                spacing: 10
                visible: mediaPlayer.playbackState === MediaPlayer.StoppedState && mediaPlayer.source == ""
                opacity: 0.25

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "▶"
                    font.pixelSize: 64
                    color: "white"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "No media loaded"
                    color: "white"
                    font.pixelSize: 14
                }
            }

            Text {
                id: statusLabel
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: 8
                }
                color: "#ff6b6b"
                font.pixelSize: 12
                text: ""
            }
        }

        // Control panel
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: controlColumn.implicitHeight + 20
            color: "#1e1e1e"

            Rectangle {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 2
                color: Material.color(Material.DeepPurple)
            }

            ColumnLayout {
                id: controlColumn
                anchors {
                    fill: parent
                    margins: 12
                    topMargin: 14
                }
                spacing: 10

                // URL row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    TextField {
                        id: urlField
                        Layout.fillWidth: true
                        placeholderText: "Paste a URL (http/https/rtsp) or local file path and press Enter…"
                        font.pixelSize: 13
                        Material.accent: Material.DeepPurple
                        onAccepted: loadAndPlay(text.trim())
                    }

                    Button {
                        icon.name: "insert-image-symbolic"
                        Material.background: Material.color(Material.DeepPurple)
                        Material.foreground: "white"
                        implicitWidth: 70
                        onClicked: {
                            if (urlField.text.trim() === "")
                                fileDialog.open();
                            else
                                loadAndPlay(urlField.text.trim());
                        }
                    }
                }

                // Seek bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: formatTime(mediaPlayer.position)
                        color: "#aaa"
                        font.pixelSize: 11
                    }

                    Slider {
                        id: seekBar
                        Layout.fillWidth: true
                        from: 0
                        to: 1
                        value: 0
                        Material.accent: Material.DeepPurple
                        onMoved: mediaPlayer.position = value * mediaPlayer.duration
                    }

                    Text {
                        text: formatTime(mediaPlayer.duration)
                        color: "#aaa"
                        font.pixelSize: 11
                    }
                }

                // Buttons row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    // Stop
                    RoundButton {
                        icon.name: "media-playback-stop-symbolic"
                        font.pixelSize: 16
                        Material.background: Material.color(Material.Grey, Material.Shade800)
                        implicitWidth: 44
                        implicitHeight: 44
                        onClicked: {
                            mediaPlayer.stop();
                            seekBar.value = 0;
                        }
                    }

                    // Play / Pause
                    RoundButton {
                        icon.name: mediaPlayer.playbackState === MediaPlayer.PlayingState ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
                        font.pixelSize: 20
                        Material.background: Material.color(Material.DeepPurple)
                        Material.foreground: "white"
                        implicitWidth: 54
                        implicitHeight: 54
                        onClicked: {
                            if (mediaPlayer.playbackState === MediaPlayer.PlayingState)
                                mediaPlayer.pause();
                            else
                                mediaPlayer.play();
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    // Mute
                    RoundButton {
                        id: muteBtn
                        checkable: true
                        checked: false
                        icon.name: checked ? "audio-volume-muted" : "audio-volume-high"
                        font.pixelSize: 16
                        Material.background: Material.color(Material.Grey, Material.Shade800)
                        implicitWidth: 40
                        implicitHeight: 40
                    }

                    // Volume
                    Slider {
                        id: volumeSlider
                        from: 0
                        to: 1
                        value: 0.8
                        implicitWidth: 100
                        Material.accent: Material.DeepPurple
                    }
                }
            }
        }
    }

    function loadAndPlay(url) {
        if (url === "")
            return;
        statusLabel.text = "";
        if (!url.startsWith("http") && !url.startsWith("rtsp") && !url.startsWith("file") && !url.startsWith("qrc")) {
            url = "file:///" + url.replace(/\\/g, "/");
        }
        mediaPlayer.source = url;
        mediaPlayer.play();
    }

    function formatTime(ms) {
        if (ms <= 0)
            return "0:00";
        var s = Math.floor(ms / 1000);
        var m = Math.floor(s / 60);
        var h = Math.floor(m / 60);
        m = m % 60;
        s = s % 60;
        if (h > 0)
            return h + ":" + pad(m) + ":" + pad(s);
        return m + ":" + pad(s);
    }

    function pad(n) {
        return n < 10 ? "0" + n : n;
    }
}
