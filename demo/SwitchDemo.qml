import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1

ColumnLayout {
    spacing: 0

    GridLayout {
        id: grid
        anchors.centerIn: parent
        rowSpacing: Units.dp(40)
        columnSpacing: Units.dp(40)
        columns: 3

        // Empty filler
        Item { width: 1; height: 1 }

        Label {
            text: "Normal"
        }

        Label {
            text: "Disabled"
        }

        Label {
            text: "On"
        }

        Switch {
            checked: true
        }

        Switch {
            checked: true
            enabled: false
        }

        Label {
            text: "Off"
        }

        Switch {
        }

        Switch {
            enabled: false
        }
    }
}
