import QtQuick 2.2
import Material 0.1
import Material.ListItems 0.1 as ListItem

Page {
    id: page
    title: "Page Title"

    tabs: [
        // Each tab can have text and an icon
        {
            text: "Overview",
            icon: "action/home"
        },

        // You can also leave out the icon
        {
            text:"Projects",
        },

        // Or just simply use a string
        "Inbox"
    ]

    actionBar {
        customContent: TextField {
            placeholderText: "Custom action bar content..."

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
       }
    }

    // TabView is simply a customized ListView
    // You can use any model/delegate for the tab contents,
    // but a VisualItemModel works well
    TabView {
        id: tabView
        anchors.fill: parent
        currentIndex: page.selectedTab
        model: tabs
    }

    VisualItemModel {
        id: tabs

        // Tab 1 "Overview"
        Rectangle {
            width: tabView.width
            height: tabView.height
            color: Palette.colors.red["200"]

            Button {
                anchors.centerIn: parent
                darkBackground: true
                text: "Go to tab 3"
                onClicked: page.selectedTab = 2
            }
        }

        // Tab 2 "Projects"
        Rectangle {
            width: tabView.width
            height: tabView.height
            color: Palette.colors.purple["200"]
        }

        // Tab 3 "Inbox"
        Rectangle {
            width: tabView.width
            height: tabView.height
            color: Palette.colors.orange["200"]
        }
    }
}
