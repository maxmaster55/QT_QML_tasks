import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    visible: true
    width: 860
    height: 600
    title: "Weather Report"

    Material.theme: Material.Light
    Material.accent: Material.Purple
    Material.primary: Material.Purple

    background: Rectangle {
        color: "#F3F0F7"
    }

    // ── Weather state ────────────────────────────────────────────────────────
    QtObject {
        id: weather
        property string city: ""
        property string country: ""
        property real temp: 0
        property real feelsLike: 0
        property int humidity: 0
        property real windSpeed: 0
        property real pressure: 0
        property real visibility: 0
        property int weatherCode: 0
        property string sunrise: ""
        property string sunset: ""
        property var dailyMax: []
        property var dailyMin: []
        property var dailyCodes: []
        property bool loaded: false
        property string errorMsg: ""
        property bool loading: false
    }

    // ── WMO weather-code helpers ─────────────────────────────────────────────
    function wmoIcon(code) {
        if (code === 0)
            return "☀";
        if (code <= 2)
            return "🌤";
        if (code === 3)
            return "☁";
        if (code <= 49)
            return "🌫";
        if (code <= 59)
            return "🌦";
        if (code <= 69)
            return "🌧";
        if (code <= 79)
            return "🌨";
        if (code <= 82)
            return "🌧";
        if (code <= 86)
            return "❄";
        if (code <= 99)
            return "⛈";
        return "🌡";
    }

    function wmoDesc(code) {
        if (code === 0)
            return "Clear Sky";
        if (code === 1)
            return "Mainly Clear";
        if (code === 2)
            return "Partly Cloudy";
        if (code === 3)
            return "Overcast";
        if (code <= 49)
            return "Foggy";
        if (code <= 59)
            return "Drizzle";
        if (code <= 69)
            return "Rainy";
        if (code <= 79)
            return "Snow";
        if (code <= 82)
            return "Rain Showers";
        if (code <= 86)
            return "Snow Showers";
        if (code <= 99)
            return "Thunderstorm";
        return "Unknown";
    }

    function humidityLabel() {
        return weather.humidity > 70 ? "High" : weather.humidity > 40 ? "Moderate" : "Low";
    }
    function windLabel() {
        return weather.windSpeed > 50 ? "Strong" : weather.windSpeed > 20 ? "Moderate" : "Light";
    }
    function visibilityLabel() {
        return weather.visibility >= 10 ? "Clear" : weather.visibility >= 5 ? "Moderate" : "Poor";
    }
    function pressureLabel() {
        return weather.pressure > 1013 ? "High" : "Low";
    }

    // ── API calls ────────────────────────────────────────────────────────────
    function searchCity(name) {
        if (name.trim() === "")
            return;
        weather.loading = true;
        weather.loaded = false;
        weather.errorMsg = "";

        var req = new XMLHttpRequest();
        req.open("GET", "https://geocoding-api.open-meteo.com/v1/search?name=" + encodeURIComponent(name) + "&count=1&language=en&format=json");
        req.onreadystatechange = function () {
            if (req.readyState !== XMLHttpRequest.DONE)
                return;
            if (req.status !== 200) {
                weather.loading = false;
                weather.errorMsg = "Network error. Please try again.";
                return;
            }
            var json = JSON.parse(req.responseText);
            if (!json.results || json.results.length === 0) {
                weather.loading = false;
                weather.errorMsg = "City \"" + name + "\" not found.";
                return;
            }
            var r = json.results[0];
            weather.city = r.name;
            weather.country = r.country || "";
            fetchWeather(r.latitude, r.longitude, r.timezone || "auto");
        };
        req.send();
    }

    function fetchWeather(lat, lon, tz) {
        var url = "https://api.open-meteo.com/v1/forecast" + "?latitude=" + lat + "&longitude=" + lon + "&timezone=" + encodeURIComponent(tz) + "&current=temperature_2m,apparent_temperature,relative_humidity_2m" + ",wind_speed_10m,surface_pressure,weather_code,visibility" + "&daily=temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset" + "&wind_speed_unit=kmh";

        var req = new XMLHttpRequest();
        req.open("GET", url);
        req.onreadystatechange = function () {
            if (req.readyState !== XMLHttpRequest.DONE)
                return;
            weather.loading = false;
            if (req.status !== 200) {
                weather.errorMsg = "Failed to fetch weather data.";
                return;
            }
            var d = JSON.parse(req.responseText);
            var c = d.current;
            weather.temp = Math.round(c.temperature_2m);
            weather.feelsLike = Math.round(c.apparent_temperature);
            weather.humidity = c.relative_humidity_2m;
            weather.windSpeed = Math.round(c.wind_speed_10m);
            weather.pressure = Math.round(c.surface_pressure);
            weather.visibility = c.visibility !== undefined ? Math.round(c.visibility / 1000) : 0;
            weather.weatherCode = c.weather_code;

            var maxArr = [];
            var minArr = [];
            var codeArr = [];
            for (var i = 1; i <= 5; i++) {
                maxArr.push(Math.round(d.daily.temperature_2m_max[i]));
                minArr.push(Math.round(d.daily.temperature_2m_min[i]));
                codeArr.push(d.daily.weather_code[i]);
            }
            weather.dailyMax = maxArr;
            weather.dailyMin = minArr;
            weather.dailyCodes = codeArr;

            var sr = d.daily.sunrise[0];
            var ss = d.daily.sunset[0];
            weather.sunrise = sr ? sr.substring(sr.length - 5) : "--:--";
            weather.sunset = ss ? ss.substring(ss.length - 5) : "--:--";

            weather.loaded = true;
            weather.errorMsg = "";
        };
        req.send();
    }

    function dayName(offset) {
        var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        var d = new Date();
        d.setDate(d.getDate() + offset);
        return days[d.getDay()];
    }

    // ── UI ───────────────────────────────────────────────────────────────────
    Flickable {
        anchors.fill: parent
        contentHeight: mainColumn.implicitHeight + 40
        clip: true

        ColumnLayout {
            id: mainColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            anchors.topMargin: 44
            spacing: 16

            // ── Header ───────────────────────────────────────────────────────
            Text {
                Layout.fillWidth: true
                text: "Weather"
                font.family: "Roboto"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: "#4A148C"
            }

            Text {
                Layout.fillWidth: true
                text: Qt.formatDate(new Date(), "dddd, MMMM d")
                font.family: "Roboto"
                font.pixelSize: 14
                color: "#9E9E9E"
                bottomPadding: 4
            }

            // ── Search card ──────────────────────────────────────────────────
            Pane {
                Layout.fillWidth: true
                Material.elevation: 2
                Material.background: "white"
                padding: 0
                background: Rectangle {
                    radius: 28
                    color: "white"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 8
                    anchors.topMargin: 2
                    anchors.bottomMargin: 7
                    spacing: 8

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search for a city…"
                        placeholderTextColor: "#B0B0B0"
                        font.family: "Roboto"
                        font.pixelSize: 15
                        Material.accent: Material.Purple
                        background: Rectangle {
                            color: "transparent"
                        }
                        verticalAlignment: Text.AlignVCenter
                        enabled: !weather.loading
                        Keys.onReturnPressed: searchCity(searchField.text)
                    }

                    RoundButton {
                        width: 42
                        height: 42
                        Material.background: Material.Purple
                        Material.foreground: "white"
                        radius: 21
                        font.pixelSize: 18
                        text: weather.loading ? "…" : "→"
                        enabled: !weather.loading
                        onClicked: searchCity(searchField.text)
                    }
                }
            }

            // ── City chips ───────────────────────────────────────────────────
            Flow {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: ["Cairo", "London", "Tokyo", "New York", "Paris", "Dubai"]
                    delegate: Rectangle {
                        height: 32
                        width: chipLabel.implicitWidth + 24
                        radius: 16
                        color: chipMouse.containsMouse ? "#EDE7F6" : "white"
                        border.color: "#CE93D8"
                        border.width: 1
                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }

                        Text {
                            id: chipLabel
                            anchors.centerIn: parent
                            text: modelData
                            font.family: "Roboto"
                            font.pixelSize: 13
                            color: "#6A1B9A"
                        }

                        MouseArea {
                            id: chipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !weather.loading
                            onClicked: {
                                searchField.text = modelData;
                                searchCity(modelData);
                            }
                        }
                    }
                }
            }

            // ── Loading indicator ────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                height: weather.loading ? 48 : 0
                visible: weather.loading

                BusyIndicator {
                    anchors.centerIn: parent
                    running: weather.loading
                    Material.accent: Material.Purple
                }
            }

            // ── Error message ────────────────────────────────────────────────
            Pane {
                Layout.fillWidth: true
                visible: weather.errorMsg !== ""
                Material.elevation: 1
                Material.background: "#FFF3E0"
                padding: 16
                background: Rectangle {
                    radius: 12
                    color: "#FFF3E0"
                }

                Text {
                    anchors.fill: parent
                    text: "⚠  " + weather.errorMsg
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "#E65100"
                    wrapMode: Text.WordWrap
                }
            }

            // ── Main weather card ────────────────────────────────────────────
            Pane {
                Layout.fillWidth: true
                visible: weather.loaded
                opacity: weather.loaded ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutCubic
                    }
                }
                Material.elevation: 4
                padding: 20

                background: Rectangle {
                    radius: 20
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0.0
                            color: "#7B1FA2"
                        }
                        GradientStop {
                            position: 1.0
                            color: "#AB47BC"
                        }
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true

                        ColumnLayout {
                            spacing: 2
                            Text {
                                text: weather.city + (weather.country ? ", " + weather.country : "")
                                font.family: "Roboto"
                                font.pixelSize: 22
                                font.weight: Font.Bold
                                color: "white"
                            }
                            Text {
                                text: wmoDesc(weather.weatherCode)
                                font.family: "Roboto"
                                font.pixelSize: 14
                                color: "#EDE7F6"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: wmoIcon(weather.weatherCode)
                            font.pixelSize: 56
                        }
                    }

                    Text {
                        text: weather.temp + "°C"
                        font.family: "Roboto"
                        font.pixelSize: 56
                        font.weight: Font.Light
                        color: "white"
                    }

                    Text {
                        text: "Feels like " + weather.feelsLike + "°C"
                        font.family: "Roboto"
                        font.pixelSize: 13
                        color: "#EDE7F6"
                    }
                }
            }

            // ── Stats grid ───────────────────────────────────────────────────
            GridLayout {
                Layout.fillWidth: true
                visible: weather.loaded
                opacity: weather.loaded ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                columns: 2
                rowSpacing: 12
                columnSpacing: 12

                // Humidity
                Pane {
                    Layout.fillWidth: true
                    Material.elevation: 2
                    Material.background: "white"
                    padding: 14
                    background: Rectangle {
                        radius: 14
                        color: "white"
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6
                        RowLayout {
                            spacing: 6
                            Text {
                                text: "💧"
                                font.pixelSize: 18
                            }
                            Text {
                                text: "Humidity"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: "#9E9E9E"
                            }
                        }
                        Text {
                            text: weather.humidity + "%"
                            font.family: "Roboto"
                            font.pixelSize: 22
                            font.weight: Font.Medium
                            color: "#4A148C"
                        }
                        Text {
                            text: humidityLabel()
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#BA68C8"
                        }
                    }
                }

                // Wind
                Pane {
                    Layout.fillWidth: true
                    Material.elevation: 2
                    Material.background: "white"
                    padding: 14
                    background: Rectangle {
                        radius: 14
                        color: "white"
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6
                        RowLayout {
                            spacing: 6
                            Text {
                                text: "🌬"
                                font.pixelSize: 18
                            }
                            Text {
                                text: "Wind Speed"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: "#9E9E9E"
                            }
                        }
                        Text {
                            text: weather.windSpeed + " km/h"
                            font.family: "Roboto"
                            font.pixelSize: 22
                            font.weight: Font.Medium
                            color: "#4A148C"
                        }
                        Text {
                            text: windLabel()
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#BA68C8"
                        }
                    }
                }

                // Visibility
                Pane {
                    Layout.fillWidth: true
                    Material.elevation: 2
                    Material.background: "white"
                    padding: 14
                    background: Rectangle {
                        radius: 14
                        color: "white"
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6
                        RowLayout {
                            spacing: 6
                            Text {
                                text: "👁"
                                font.pixelSize: 18
                            }
                            Text {
                                text: "Visibility"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: "#9E9E9E"
                            }
                        }
                        Text {
                            text: weather.visibility + " km"
                            font.family: "Roboto"
                            font.pixelSize: 22
                            font.weight: Font.Medium
                            color: "#4A148C"
                        }
                        Text {
                            text: visibilityLabel()
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#BA68C8"
                        }
                    }
                }

                // Pressure
                Pane {
                    Layout.fillWidth: true
                    Material.elevation: 2
                    Material.background: "white"
                    padding: 14
                    background: Rectangle {
                        radius: 14
                        color: "white"
                    }
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 6
                        RowLayout {
                            spacing: 6
                            Text {
                                text: "🌡"
                                font.pixelSize: 18
                            }
                            Text {
                                text: "Pressure"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: "#9E9E9E"
                            }
                        }
                        Text {
                            text: weather.pressure + " hPa"
                            font.family: "Roboto"
                            font.pixelSize: 22
                            font.weight: Font.Medium
                            color: "#4A148C"
                        }
                        Text {
                            text: pressureLabel()
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#BA68C8"
                        }
                    }
                }
            }

            // ── Sunrise / Condition / Sunset card ────────────────────────────
            Pane {
                Layout.fillWidth: true
                visible: weather.loaded
                opacity: weather.loaded ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 450
                        easing.type: Easing.OutCubic
                    }
                }
                Material.elevation: 2
                Material.background: "white"
                padding: 16
                background: Rectangle {
                    radius: 14
                    color: "white"
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "🌅"
                            font.pixelSize: 24
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Sunrise"
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#9E9E9E"
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: weather.sunrise
                            font.family: "Roboto"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#4A148C"
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "🌤"
                            font.pixelSize: 24
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Condition"
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#9E9E9E"
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: wmoDesc(weather.weatherCode)
                            font.family: "Roboto"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#4A148C"
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "🌇"
                            font.pixelSize: 24
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: "Sunset"
                            font.family: "Roboto"
                            font.pixelSize: 11
                            color: "#9E9E9E"
                        }
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: weather.sunset
                            font.family: "Roboto"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#4A148C"
                        }
                    }
                }
            }

            // ── 5-Day Forecast card ──────────────────────────────────────────
            Pane {
                Layout.fillWidth: true
                visible: weather.loaded && weather.dailyMax.length >= 5
                opacity: weather.loaded ? 1 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.OutCubic
                    }
                }
                Material.elevation: 2
                Material.background: "white"
                padding: 16
                background: Rectangle {
                    radius: 14
                    color: "white"
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    Text {
                        text: "5-DAY FORECAST"
                        font.family: "Roboto"
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        font.letterSpacing: 1.2
                        color: "#9E9E9E"
                    }

                    Repeater {
                        model: 5
                        delegate: RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            property int hi: weather.dailyMax.length > index ? weather.dailyMax[index] : 0
                            property int lo: weather.dailyMin.length > index ? weather.dailyMin[index] : 0

                            Text {
                                text: dayName(index + 1)
                                font.family: "Roboto"
                                font.pixelSize: 13
                                color: "#424242"
                                Layout.preferredWidth: 40
                            }

                            Text {
                                text: weather.dailyCodes.length > index ? wmoIcon(weather.dailyCodes[index]) : "—"
                                font.pixelSize: 20
                            }

                            Item {
                                Layout.fillWidth: true
                                height: 6
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 3
                                    color: "#EDE7F6"
                                }
                                Rectangle {
                                    width: parent.width * Math.max(0.15, Math.min(1.0, weather.dailyMax.length > index ? (weather.dailyMax[index] + 20) / 60 : 0.5))
                                    height: parent.height
                                    radius: 3
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop {
                                            position: 0.0
                                            color: "#AB47BC"
                                        }
                                        GradientStop {
                                            position: 1.0
                                            color: "#7B1FA2"
                                        }
                                    }
                                }
                            }

                            Text {
                                text: lo + "°"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                color: "#9E9E9E"
                                Layout.preferredWidth: 34
                            }

                            Text {
                                text: hi + "°"
                                font.family: "Roboto"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: "#4A148C"
                                Layout.preferredWidth: 34
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: 24
            }
        }
    }
}
