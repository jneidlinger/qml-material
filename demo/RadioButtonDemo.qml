import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2 as QuickControls
import Material 0.1

ColumnLayout {
    spacing: 0

    GridLayout {
        id: grid
        anchors.centerIn: parent
        rowSpacing: Units.dp(20)
        columnSpacing: Units.dp(20)
        columns: 2

        QuickControls.ExclusiveGroup { id: optionGroup }

        Label {
            Layout.alignment : Qt.AlignHCenter
            text: "Normal"
        }

        Label {
            Layout.alignment : Qt.AlignHCenter
            text: "Disabled"
        }

        RadioButton {
            checked: true
            text: "Option 1"
            canToggle: true
            exclusiveGroup: optionGroup
        }

        RadioButton {
            checked: true
            enabled: false
            text: "Disabled"
        }

        RadioButton {
            text: "Option 2"
            canToggle: true
            exclusiveGroup: optionGroup
        }

        RadioButton {
            enabled: false
            text: "Disabled"
        }
    }
}
