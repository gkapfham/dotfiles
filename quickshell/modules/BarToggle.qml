// File: quickshell/modules/BarToggle.qml
//
// Hides the bar.
//
// The bar cannot be its own way back -- the moment it unmaps, so does this icon
// -- so it returns when the pointer touches the top edge of the screen. That
// reveal strip lives in shell.qml, once per screen, and is mapped only while the
// bar is hidden.
//
// Not a polybar module: polybar had no way to hide itself.
import QtQuick

Text {
    id: root

    // A click asks the bar to hide. The bar forwards this to the process-wide
    // state in shell.qml, because hiding is one decision for every screen.
    signal toggled()

    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // A chevron pointing up: the bar retracts upward.
    readonly property string toggleIcon: "\u{f077}"

    text: root.toggleIcon

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold
}
