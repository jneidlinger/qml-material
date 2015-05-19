import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1

ColumnLayout {

    ColumnLayout {
        anchors.centerIn: parent

        Calendar {
            Layout.alignment: Qt.AlignCenter
        }

        Calendar {
            Layout.alignment: Qt.AlignCenter
            isLandscape: true
        }
    }
}
