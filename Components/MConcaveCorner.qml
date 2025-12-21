import QtQuick

import qs.Config

Canvas {
    required property string location // top-left, top-right, bottom-left, bottom-right

    // When true the arc is pinned to x, otherwise pinned to y
    property bool inverted: false

    property color color: MColors.base00

    implicitWidth: MBorder.radius
    implicitHeight: MBorder.radius

    onPaint: {
        var ctx = getContext("2d");

        ctx.fillStyle = color;
        ctx.beginPath();

        switch (location) {
        case "top-left":
            drawTopLeft(ctx);
            break;
        case "top-right":
            drawTopRight(ctx);
            break;
        case "bottom-left":
            drawBottomLeft(ctx);
            break;
        case "bottom-right":
            drawBottomRight(ctx);
            break;
        }

        ctx.closePath();
        ctx.fill();
    }

    function drawTopLeft(ctx) {
        if (inverted) {
            ctx.moveTo(0, height);
            ctx.lineTo(width, height);
            ctx.quadraticCurveTo(0, height, 0, 0);
        } else {
            ctx.moveTo(width, 0);
            ctx.lineTo(width, height);
            ctx.quadraticCurveTo(width, 0, 0, 0);
        }
    }

    function drawTopRight(ctx) {
        if (inverted) {
            ctx.moveTo(width, height);
            ctx.lineTo(0, height);
            ctx.quadraticCurveTo(width, height, width, 0);
        } else {
            ctx.moveTo(0, 0);
            ctx.lineTo(0, height);
            ctx.quadraticCurveTo(0, 0, width, 0);
        }
    }

    function drawBottomLeft(ctx) {
        if (inverted) {
            ctx.moveTo(width, height);
            ctx.lineTo(0, height);
            ctx.quadraticCurveTo(width, height, width, 0);
        } else {
            ctx.moveTo(0, 0);
            ctx.lineTo(width, 0);
            ctx.quadraticCurveTo(0, 0, 0, height);
        }
    }

    function drawBottomRight(ctx) {
        if (inverted) {
            ctx.moveTo(0, height);
            ctx.lineTo(width, height);
            ctx.quadraticCurveTo(0, height, 0, 0);
        } else {
            ctx.moveTo(width, 0);
            ctx.lineTo(0, 0);
            ctx.quadraticCurveTo(width, 0, width, height);
        }
    }
}
