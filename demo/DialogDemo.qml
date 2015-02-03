import QtQuick 2.0
import QtQuick.Controls 1.2 as QuickControls
import Material 0.1

Item {
    property string currentText

    Component {
        id: simpleDialogComponent
        Dialog {
            title: "Simple Dialog"
            hasConfirmationOptions: false
            contents: Column {
                QuickControls.ExclusiveGroup {
                    id: optionGroup
                }
                RadioButton {
                    text: "Small"
                    checked: true
                    exclusiveGroup: optionGroup
                }
                RadioButton {
                    text: "Normal"
                    exclusiveGroup: optionGroup
                }
                RadioButton {
                    text: "Large"
                    exclusiveGroup: optionGroup
                }
                RadioButton {
                    text: "Huge"
                    exclusiveGroup: optionGroup
                }
            }
        }
    }

    Component {
        id: confirmationDialogComponent
        Dialog {
            title: "Confirmation Dialog"
            hasConfirmationOptions: true
            contents: Column {
                width: parent.width
                TextField {
                    id: optionText
                    width: parent.width
                    placeholderText: "New Option to Confirm"
                }
            }

            onAccepted: {
                currentText = optionText.text
            }
        }
    }

    Loader {
        id: dialogLoader
    }

    Column {
        anchors.centerIn: parent
        spacing: units.dp(20)

        Button {
            text: "Show Simple Dialog"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                dialogLoader.sourceComponent = simpleDialogComponent
                dialogLoader.item.open()
            }
        }

        Button {
            text: "Show Confirmation Dialog"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                dialogLoader.sourceComponent = confirmationDialogComponent
                dialogLoader.item.open()
            }
        }

        Label {
            text: currentText
        }
    }
}
