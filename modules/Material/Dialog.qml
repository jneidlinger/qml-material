/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014-2015 Michael Spencer <sonrisesoftware@gmail.com>
 * Copyright (C) 2015 Bogdan Cuza <bogdan.cuza@hotmail.com>
 * Copyright (C) 2015 Mikhail Ivchenko <ematirov@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1
import Material.Extras 0.1

PopupBase {
    id: dialog

    overlayLayer: "dialogOverlayLayer"
    overlayColor: Qt.rgba(0, 0, 0, 0.3)

    opacity: showing ? 1 : 0
    visible: opacity > 0

    width: Math.max(minimumWidth,
                    content.contentWidth + 2 * contentMargins)

    height: Math.min(units.dp(350),
                     headerView.height + units.dp(32) +
                     content.contentHeight +
                     content.topMargin +
                     content.bottomMargin +
                     buttonContainer.height)

    property int contentMargins: units.dp(16)

    property int minimumWidth: units.dp(270)

    property alias title: titleLabel.text
    property alias text: textLabel.text

    /*!
       \qmlproperty Button negativeButton

       The negative button, displayed as the leftmost button on the right of the dialog buttons.
       This is usually used to dismiss the dialog.
     */
    property alias negativeButton: negativeButton

    /*!
       \qmlproperty Button primaryButton

       The primary button, displayed as the rightmost button in the dialog buttons row. This is
       usually used to accept the dialog's action.
     */
    property alias positiveButton: positiveButton

    property string negativeButtonText: "Cancel"
    property string positiveButtonText: "Ok"
    property alias positiveButtonEnabled: positiveButton.enabled

    property bool hasActions: true

    default property alias dialogContent: column.data

    signal accepted()
    signal rejected()

    anchors {
        centerIn: parent
        verticalCenterOffset: showing ? 0 : -(dialog.height/3)

        Behavior on verticalCenterOffset {
            NumberAnimation { duration: 200 }
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            closeKeyPressed(event)
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            closeKeyPressed(event)
        }
    }

    function closeKeyPressed(event) {
        if (dialog.showing) {
            if (dialog.dismissOnTap) {
                dialog.close()
            }
            event.accepted = true
        }
    }

    function show() {
        open()
    }

    View {
        id: dialogContainer

        anchors.fill: parent
        elevation: 5
        radius: units.dp(2)

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: false

            onClicked: {
                mouse.accepted = false
            }
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: units.dp(8)
            }

            clip: true
            height: headerView.height + units.dp(32)

            View {
                backgroundColor: "white"
                elevation: content.atYBeginning ? 0 : 1
                fullWidth: true

                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }

                height: headerView.height + units.dp(16)
            }
        }


        Column {
            id: headerView

            spacing: units.dp(16)

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top

                leftMargin: units.dp(16)
                rightMargin: units.dp(16)
                topMargin: units.dp(16)
            }

            Label {
                id: titleLabel

                width: parent.width
                wrapMode: Text.Wrap
                style: "title"
                visible: text != ""
            }

            Label {
                id: textLabel

                width: parent.width
                wrapMode: Text.Wrap
                style: "dialog"
                visible: text != ""
            }
        }

        Rectangle {
            anchors.fill: content
        }

        Flickable {
            id: content

            contentWidth: column.implicitWidth
            contentHeight: column.height
            clip: true

            anchors {
                left: parent.left
                right: parent.right
                top: headerView.bottom
                topMargin: units.dp(8)
                bottomMargin: units.dp(-8)
                bottom: buttonContainer.top
            }

            interactive: contentHeight + units.dp(8) > height
            bottomMargin: hasActions ? 0 : units.dp(8)

            Rectangle {
                Column {
                    id: column
                    anchors {
                        left: parent.left
                        margins: contentMargins
                    }

                    width: content.width - 2 * contentMargins
                    spacing: units.dp(16)
                }
            }
        }

        Scrollbar {
            flickableItem: content
        }

        Item {
            id: buttonContainer

            anchors {
                bottomMargin: units.dp(8)
                bottom: parent.bottom
                right: parent.right
                left: parent.left
            }

            height: hasActions ? buttonView.height + units.dp(8) : 0
            clip: true

            View {
                id: buttonView

                height: hasActions ? positiveButton.implicitHeight + units.dp(8) : 0
                visible: hasActions

                backgroundColor: "white"
                elevation: content.atYEnd ? 0 : 1
                fullWidth: true
                elevationInverted: true

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left
                }

                Button {
                    id: negativeButton

                    text: negativeButtonText
                    textColor: Theme.accentColor
                    context: "dialog"

                    anchors {
                        top: parent.top
                        right: positiveButton.left
                        topMargin: units.dp(8)
                        rightMargin: units.dp(8)
                    }

                    onClicked: {
                        close();
                        rejected();
                    }
                }

                Button {
                    id: positiveButton

                    text: positiveButtonText
                    textColor: Theme.accentColor
                    context: "dialog"

                    anchors {
                        top: parent.top
                        topMargin: units.dp(8)
                        rightMargin: units.dp(16)
                        right: parent.right
                    }

                    onClicked: {
                        close()
                        accepted();
                    }
                }
            }
        }
    }

}
