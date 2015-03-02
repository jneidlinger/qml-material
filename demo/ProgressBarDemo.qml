import QtQuick 2.0
import QtQuick.Layouts 1.1
import Material 0.1

Item {
    Column {
        anchors.centerIn: parent
        spacing: units.dp(25)

        Label {
            text: "Determinate"
        }

        ProgressBar {
            id: progressBar1
            width: units.dp(50)

            SequentialAnimation on progress {
                running: true
                loops: NumberAnimation.Infinite

                PauseAnimation { duration: 1000 } // This puts a bit of time between the loop

                NumberAnimation {
                    duration: 3000
                    from: 0
                    to: 1
                }
            }
        }

        RowLayout {
            Label {
                text: "Default"
            }
            CircularProgress {}
        }

        RowLayout {
            Label {
                text: "Custom Color"
            }
            CircularProgress {
                color: "#E91E63"
            }
        }

        RowLayout {
            Label {
                text: "Cyclic Colors"
            }
            CircularProgress {
                id: cyclicColorProgress
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite

                    ColorAnimation {
                        from: "red"
                        to: "blue"
                        target: cyclicColorProgress
                        properties: "color"
                        easing.type: Easing.InOutQuad
                        duration: 2400
                    }

                    ColorAnimation {
                        from: "blue"
                        to: "green"
                        target: cyclicColorProgress
                        properties: "color"
                        easing.type: Easing.InOutQuad
                        duration: 1560
                    }

                    ColorAnimation {
                        from: "green"
                        to: "#FFCC00"
                        target: cyclicColorProgress
                        properties: "color"
                        easing.type: Easing.InOutQuad
                        duration:  840
                    }

                    ColorAnimation {
                        from: "#FFCC00"
                        to: "red"
                        target: cyclicColorProgress
                        properties: "color"
                        easing.type: Easing.InOutQuad
                        duration:  1200
                    }
                }
            }
        }


        RowLayout {
            Label {
                text: "Custom Size"
            }
            CircularProgress {
                width: units.dp(64)
                height: units.dp(64)
            }
        }

        RowLayout {
            Label {
                text: "Determinate Value"
            }

            Slider {
                id: percentage
                stepSize: 1
                minimumValue: 0
                maximumValue: 100
                value: 26
            }

            CircularProgress {
                width: units.dp(64)
                height: units.dp(64)
                determinate: true
                percent: percentage.value

                Label {
                    anchors.centerIn: parent
                    text: percentage.value
                }
            }
        }
    }
}
