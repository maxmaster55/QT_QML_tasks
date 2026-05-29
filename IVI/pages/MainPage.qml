import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import IVI

RowLayout {
    spacing: 20

    // Left Column: Climate Control and Vehicle Status stack
    ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 2
        spacing: 20

        ClimateCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
        }

        WeatherCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
        }
    }

    // Right Column: Music Card taking up the full height column
    MusicCard {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 3
    }
}

