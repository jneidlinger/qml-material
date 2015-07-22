import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1

ColumnLayout {
    spacing: 0

    GridLayout {
        id: grid
        anchors.centerIn: parent
        columns: 3

        // Empty filler
        Item { width: 1; height: 1 }

        Label {
            Layout.alignment : Qt.AlignHCenter
            text: "Normal"
        }

        Label {
            Layout.alignment : Qt.AlignHCenter
            text: "Disabled"
        }

        Label {
            text: "On"
        }

        CheckBox {
            checked: true
            text: "On"
        }

        CheckBox {
            checked: true
            enabled: false
            text: "Disabled"
        }

        Label {
            text: "Off"
        }

        CheckBox {
            text: "Off"
        }

        CheckBox {
            text: "Disabled"
            enabled: false
        }
    }
}
