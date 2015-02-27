/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Jordan Neidlinger
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
import QtQuick 2.2
import Material 0.1

Canvas {
    id: canvas
    width: units.dp(32)
    height : units.dp(32)

    antialiasing: true
    onPaint: drawSpinner();

    /*!
       Set to \c true to cycle the colors automatically
     */
    property bool cycleColors : false

    /*!
       Sets the color of the progress indicator. This value is ignored
       if cycleColors is set to true
     */
    property color color : Theme.primaryColor
    onColorChanged: requestPaint();

    /*!
       Set to \c true to behave as determinate percentage indicator
     */
    property bool determinate: false
    onDeterminateChanged:
    {
        if(!determinate)
        {
            internal.arcEndPoint = 0
            internal.arcStartPoint = 0
            internal.rotate = 0
        }

        requestPaint();
    }

    /*!
       Sets the percentage value to display. Valid values are between 0 and 100. This value
       is ignored if determinate is set to false
     */
    property int percent: 0
    onPercentChanged: requestPaint();

    QtObject {
        id: internal

        property color cycleColor: "red"
        onCycleColorChanged: canvas.requestPaint();

        property real arcEndPoint: 0
        onArcEndPointChanged: canvas.requestPaint();

        property real arcStartPoint: 0
        onArcStartPointChanged: canvas.requestPaint();

        property real rotate: 0
        onRotateChanged: canvas.requestPaint();
    }

    NumberAnimation {
        id: animateCanvasRotation
        target: internal
        properties: "rotate"
        from: 0
        to: 2 * Math.PI
        loops: Animation.Infinite
        running: !determinate
        easing.type: Easing.Linear
        duration: 2000
    }

    SequentialAnimation {
        running: !determinate
        loops: Animation.Infinite
        NumberAnimation {
            id: animateOpacity
            target: internal
            properties: "arcEndPoint"
            from: 0
            to: 2 * Math.PI - 0.001
            easing.type: Easing.InOutQuad
            duration: 1200
        }
        NumberAnimation {
            id: animateStartPoint
            target: internal
            properties: "arcStartPoint"
            from: 0
            to: 2 * Math.PI - 0.001
            easing.type: Easing.InOutQuad
            duration: 1200
        }
    }

    SequentialAnimation {
        running: cycleColors
        loops: Animation.Infinite

        ColorAnimation {
            from: "red"
            to: "blue"
            target: internal
            properties: "cycleColor"
            easing.type: Easing.InOutQuad
            duration: 2400
        }

        ColorAnimation {
            from: "blue"
            to: "green"
            target: internal
            properties: "cycleColor"
            easing.type: Easing.InOutQuad
            duration: 1560
        }

        ColorAnimation {
            from: "green"
            to: "#FFCC00"
            target: internal
            properties: "cycleColor"
            easing.type: Easing.InOutQuad
            duration:  840
        }

        ColorAnimation {
            from: "#FFCC00"
            to: "red"
            target: internal
            properties: "cycleColor"
            easing.type: Easing.InOutQuad
            duration:  1200
        }
    }

    function drawSpinner() {
        var ctx = canvas.getContext("2d");
        ctx.reset();
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        ctx.strokeStyle = canvas.cycleColors ? internal.cycleColor : canvas.color
        ctx.lineWidth = units.dp(3);
        ctx.lineCap = "butt";

        ctx.translate(canvas.width/2, canvas.height/2);

        ctx.rotate(!canvas.determinate ? internal.rotate : (canvas.percent / 100) * (3 * Math.PI / 2));

        ctx.arc(0, 0, Math.min(canvas.width, canvas.height) / 2 - ctx.lineWidth,
            !canvas.determinate ? internal.arcStartPoint : 0,
            !canvas.determinate ? internal.arcEndPoint : (canvas.percent / 100) * (2 * Math.PI),
            false);

        ctx.stroke();
    }
}
