// File: quickshell/modules/ZellijSessions.qml
//
// A tab glyph for zellij: clicking it lists the zellij sessions on this machine
// and how many pi coding agents are running inside each one.
//
// Not a polybar module -- polybar had no notion of a multiplexer session.
//
// Unlike the agent icon there is nothing to count or dim here, so this module
// owns no Process and no timer at all: it is a glyph, and everything the popup
// needs it reads when it opens.
import QtQuick

Text {
    id: root

    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // nf-fa-list. nf-md-tab (U+F0537) is what this started as, and in
    // this font it renders as a bare triangle, which says nothing about
    // sessions. Checked by rendering it, not by trusting the name.
    readonly property string sessionsIcon: "\u{f03a}"

    text: root.sessionsIcon

    verticalAlignment: Text.AlignVCenter
    // CurveRendering is grayscale antialiasing, which is what polybar's
    // Xft rendering produced. Qt's default adds colour fringes that make
    // the text look a size thinner than polybar's.
    renderType: Text.CurveRendering
    font.family: root.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.fontBold
}
