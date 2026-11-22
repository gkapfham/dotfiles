// File: quickshell/modules/InfoPopup.qml
//
// The shared shape of every bar popup: a titled box of label/value rows,
// anchored under the module that opened it.
//
// The calendar draws its own grid instead of using this, because a month grid
// is not a list of rows.
//
// grabFocus is set for the platforms where it works. Under X11 it does not --
// quickshell 0.3.0 has no X11 focus grab -- so Bar.qml also closes popups on a
// click anywhere on the bar itself.
import Quickshell
import QtQuick

PopupWindow {
    id: root

    required property var anchorWindow

    // The module's x within the bar. Passed in as a plain number rather than
    // derived here: the obvious `anchorItem.mapToItem(null, 0, 0).x` is a
    // function call, and QML cannot see through function calls when tracking
    // dependencies, so that binding would run once before the bar is laid out
    // and stay at 0 forever.
    required property real anchorX

    required property QtObject colors
    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    property string title: ""
    // Array of { label, value }, where either may carry an optional `color` to
    // override the default for that row. Existing popups pass no color and are
    // drawn exactly as before; the agent list uses it to show state at a glance.
    property var rows: []
    property int labelWidth: 84
    property int popupWidth: 252

    // Space between the border and the content. The popup is sized from the
    // content plus this on both sides, so the rows never sit against the edge.
    property int padding: 18

    anchor.window: anchorWindow
    // Clamped to the screen because a popup opened from a module near the right
    // edge would otherwise run off it: the agent list is 560 logical px wide
    // and the module that opens it sits at about x=1272 of 1440. Existing
    // popups are narrow enough that the clamp never moves them, so this only
    // changes the case that used to be clipped.
    anchor.rect.x: Math.max(0, Math.min(Math.round(root.anchorX),
                                        Math.round(anchorWindow.screen.width - root.implicitWidth)))
    anchor.rect.y: anchorWindow.height

    grabFocus: true
    visible: false

    implicitWidth: popupWidth
    implicitHeight: content.implicitHeight + padding * 2
    color: colors.background

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 2
        border.color: root.colors.primary
    }

    Column {
        id: content

        anchors.centerIn: parent
        spacing: 7

        Text {
            text: root.title
            color: root.colors.foregroundAlt
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            font.bold: root.fontBold
            renderType: Text.CurveRendering
        }

        Repeater {
            model: root.rows

            delegate: Row {
                required property var modelData
                spacing: 8

                Text {
                    // Fixed width with elision so a long label cannot run into
                    // the value beside it.
                    width: root.labelWidth
                    text: modelData.label
                    elide: Text.ElideRight
                    color: modelData.color || root.colors.foregroundAlt
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.bold: root.fontBold
                    renderType: Text.CurveRendering
                }

                Text {
                    // Fixed width with elision, so a long value (a CPU model
                    // name, say) is cut rather than widening the row past the
                    // popup and pushing the labels off the left edge.
                    width: root.popupWidth - root.labelWidth - 8 - 20
                    text: modelData.value
                    elide: Text.ElideRight
                    color: modelData.color || root.colors.foreground
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.bold: root.fontBold
                    renderType: Text.CurveRendering
                }
            }
        }
    }
}
