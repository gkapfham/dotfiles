// File: quickshell/modules/NotificationList.qml
//
// The full dunst history: scrollable, grouped by the program that sent it.
//
// WINDOW CLASS MATTERS HERE. This is a PopupWindow anchored to the bar, exactly
// like CalendarPopup.qml and the other InfoPopup-based panels, and that choice is
// deliberate:
//
//   PopupWindow  -> an X11 popup/override-redirect window. It floats above
//                   ordinary windows and i3 does not manage it, so mapping it
//                   changes no layout.
//   PanelWindow  -> a dock. Mapping one makes i3 recompute the work area, which
//                   re-tiled and re-focused the user's windows: the first version
//                   of this file did that and made the focused browser appear to
//                   vanish. Do not use a dock for this.
//
// Because it is a popup, dismissal comes from the bar, not from the window: the
// bar's own click handler (Bar.closePopups) closes it when the bar is clicked,
// and clicking the bell again toggles it shut. The explicit close button below
// exists because X11 gives no keyboard focus here, so `q`/`Esc` cannot be relied
// on -- that was the second mistake in the first version.
//
// COST: `dunstctl history` runs only when the window is opened (and on reload),
// never on a timer, so a closed list costs nothing. The bell keeps its own poll.
import Quickshell
import Quickshell.Io
import QtQuick

PopupWindow {
    id: root

    required property var anchorWindow
    // The bell's x within the bar, as a plain number: QML cannot see through the
    // mapToItem() call that would otherwise compute it, so the binding would run
    // once and stay put. Same reasoning as InfoPopup.qml.
    required property real anchorX
    required property QtObject colors

    property int fontSize: 13
    property string fontFamily: "Maple Mono NF"
    property bool fontBold: true

    // Emitted after anything that changes dunst's history, so the bell refreshes
    // its own count instead of waiting for its next poll.
    signal changed()

    // Flat rows: { kind: "header" | "item", ... } so the ListView can draw source
    // group titles and entries from one model.
    property var rows: []
    property int currentRow: 0
    property real uptimeSeconds: 0
    property string parseError: ""

    readonly property int rowHeight: 22
    readonly property int headerHeight: 20
    readonly property int listHeight: 280
    readonly property int detailHeight: 150

    readonly property var current: {
        if (currentRow < 0 || currentRow >= rows.length) return null;
        return rows[currentRow].kind === "item" ? rows[currentRow] : null;
    }

    readonly property string countText: {
        var items = 0;
        var sources = 0;
        for (var i = 0; i < rows.length; i++) {
            if (rows[i].kind === "item") items++;
            else sources++;
        }
        if (items === 0) return "";
        return items + (items === 1 ? " message" : " messages") + " in "
               + sources + (sources === 1 ? " source" : " sources");
    }

    function ageText(timestamp) {
        if (!timestamp || uptimeSeconds <= 0) return "";
        var seconds = Math.max(0, Math.round(uptimeSeconds - timestamp / 1000000));
        if (seconds < 60) return seconds + "s";
        if (seconds < 3600) return Math.round(seconds / 60) + "m";
        if (seconds < 86400) return Math.round(seconds / 3600) + "h";
        return Math.round(seconds / 86400) + "d";
    }

    // dunst's JSON is a DBus variant dump: every field is {type, data}. Read each
    // one defensively so a single odd field cannot blank the whole list.
    function field(entry, name) {
        var value = entry ? entry[name] : null;
        if (value === null || value === undefined) return "";
        if (typeof value === "object" && value.data !== undefined) return value.data;
        return value;
    }

    // Group by appname. dunst reports newest first, so the order in which a source
    // first appears is its newest entry -- which is also the group order.
    function buildRows(text) {
        var entries = [];
        try {
            var doc = JSON.parse(text);
            var list = (doc && doc.data && doc.data[0]) ? doc.data[0] : [];
            for (var i = 0; i < list.length; i++) {
                var entry = list[i];
                entries.push({
                    id: String(root.field(entry, "id")),
                    app: String(root.field(entry, "appname")) || "unknown",
                    summary: String(root.field(entry, "summary")),
                    body: String(root.field(entry, "body")),
                    urgency: String(root.field(entry, "urgency")),
                    timestamp: Number(root.field(entry, "timestamp")) || 0
                });
            }
            root.parseError = "";
        } catch (error) {
            root.parseError = "could not parse dunstctl history";
            return [];
        }

        var order = [];
        var groups = {};
        for (var j = 0; j < entries.length; j++) {
            var app = entries[j].app;
            if (!groups[app]) {
                groups[app] = [];
                order.push(app);
            }
            groups[app].push(entries[j]);
        }

        var out = [];
        for (var k = 0; k < order.length; k++) {
            var name = order[k];
            var items = groups[name];
            out.push({ kind: "header", app: name, count: items.length });
            for (var m = 0; m < items.length; m++) {
                out.push({
                    kind: "item",
                    app: name,
                    id: items[m].id,
                    summary: items[m].summary,
                    body: items[m].body,
                    urgency: items[m].urgency,
                    age: root.ageText(items[m].timestamp)
                });
            }
        }
        return out;
    }

    function reload() {
        // exec() with an explicit argv, not `running = true`: a Process with no
        // `command` has nothing to run, which is what made the first version show
        // an empty list.
        historyProc.exec(["dunstctl", "history"]);
        uptimeProc.exec(["cat", "/proc/uptime"]);
    }

    function afterMutation() {
        root.changed();
        refresh.restart();
    }

    function restoreCurrent() {
        if (!current) return;
        dunstAction.exec(["dunstctl", "history-pop", current.id]);
        afterMutation();
    }

    function closeDisplayed() {
        if (!current) return;
        dunstAction.exec(["dunstctl", "close", current.id]);
        afterMutation();
    }

    function removeCurrent() {
        if (!current) return;
        dunstAction.exec(["dunstctl", "history-rm", current.id]);
        afterMutation();
    }

    function copyCurrent() {
        if (!current) return;
        var text = current.summary + (current.body !== "" ? "\n\n" + current.body : "");
        // Passed as an argument rather than on stdin, so no quoting of arbitrary
        // notification text is involved.
        clipProc.exec(["bash", "-c", "printf '%s' \"$1\" | xclip -selection clipboard", "bash", text]);
    }

    function clearAll() {
        dunstAction.exec(["dunstctl", "history-clear"]);
        afterMutation();
    }

    // Anchored under the bell, clamped to the screen so a bell near the right edge
    // cannot push the panel off it. Identical formula to the other popups.
    anchor.window: anchorWindow
    anchor.rect.x: Math.max(0, Math.min(Math.round(root.anchorX),
                                        Math.round(anchorWindow.screen.width - root.implicitWidth)))
    anchor.rect.y: anchorWindow.height

    grabFocus: true
    visible: false

    implicitWidth: 700
    implicitHeight: 520
    color: colors.background

    // Open on the first notification, not on a group title, and reload each time
    // it is opened so the list is never stale.
    onVisibleChanged: {
        if (visible) {
            currentRow = 0;
            // Reopening must start at the top of the body. `currentRow = 0` only
            // fires onCurrentRowChanged when the row actually changes, so a
            // re-open on the same row kept the previous scroll offset -- which
            // looked like a pane that had jumped into the middle of the text.
            detailFlick.contentY = 0;
            reload();
        }
    }

    Process {
        id: historyProc

        stdout: StdioCollector {
            onStreamFinished: {
                root.rows = root.buildRows(text);
                if (root.rows.length > 0 && root.rows[0].kind === "header") root.currentRow = 1;
            }
        }
    }

    Process {
        id: uptimeProc

        stdout: StdioCollector {
            onStreamFinished: {
                var parts = text.trim().split(/\s+/);
                var seconds = parseFloat(parts[0]);
                if (!isNaN(seconds)) root.uptimeSeconds = seconds;
            }
        }
    }

    Process {
        id: dunstAction
        command: ["dunstctl", "count", "history"]
    }

    Process {
        id: clipProc
    }

    // One reload per burst of actions, not one per action.
    Timer {
        id: refresh

        interval: 250
        onTriggered: root.reload()
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 2
        border.color: root.colors.primary
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // ---- header: title, counts, and the way out ----
        Item {
            width: parent.width
            height: 20

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "Notifications"
                color: root.colors.foregroundAlt
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                font.bold: root.fontBold
                renderType: Text.CurveRendering
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 108
                anchors.verticalCenter: parent.verticalCenter
                text: root.countText
                color: root.colors.foregroundAlt
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                font.bold: root.fontBold
                renderType: Text.CurveRendering
            }

            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 74
                height: 20
                radius: 3
                color: closeArea.containsMouse ? root.colors.primary : "transparent"
                border.width: 1
                border.color: root.colors.primary

                Text {
                    anchors.centerIn: parent
                    text: "\u2715  close"
                    color: root.colors.foreground
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.bold: root.fontBold
                    renderType: Text.CurveRendering
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.visible = false
                }
            }
        }

        // ---- the scrollable list ----
        Rectangle {
            width: parent.width
            height: root.listHeight
            color: "transparent"
            border.width: 1
            border.color: root.colors.primary

            Text {
                anchors.centerIn: parent
                visible: root.rows.length === 0
                text: root.parseError !== "" ? "history unreadable" : "history is empty"
                color: root.colors.foregroundAlt
                font.family: root.fontFamily
                font.pixelSize: root.fontSize
                font.bold: root.fontBold
                renderType: Text.CurveRendering
            }

            ListView {
                id: list

                anchors.fill: parent
                anchors.margins: 4
                clip: true
                model: root.rows
                currentIndex: root.currentRow
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick

                delegate: Item {
                    required property var modelData
                    required property int index

                    width: list.width
                    height: modelData.kind === "header" ? root.headerHeight : root.rowHeight

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        visible: modelData.kind === "header"
                        text: modelData.kind === "header"
                              ? "\u25be " + modelData.app + "  (" + modelData.count + ")"
                              : ""
                        color: root.colors.secondary
                        font.family: root.fontFamily
                        font.pixelSize: root.fontSize
                        font.bold: root.fontBold
                        renderType: Text.CurveRendering
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: modelData.kind === "item"
                        color: index === root.currentRow ? root.colors.primary : "transparent"

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 6
                            spacing: 10

                            Text {
                                width: 42
                                text: modelData.kind === "item" ? modelData.age : ""
                                color: root.colors.foregroundAlt
                                font.family: root.fontFamily
                                font.pixelSize: root.fontSize
                                font.bold: root.fontBold
                                renderType: Text.CurveRendering
                            }

                            Text {
                                width: parent.width - 42 - 10
                                text: modelData.kind === "item" ? modelData.summary : ""
                                elide: Text.ElideRight
                                color: modelData.kind === "item" && modelData.urgency === "CRITICAL"
                                       ? root.colors.red : root.colors.foreground
                                font.family: root.fontFamily
                                font.pixelSize: root.fontSize
                                font.bold: root.fontBold
                                renderType: Text.CurveRendering
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: modelData.kind === "item"
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.currentRow = index
                        }
                    }
                }
            }
        }

        // ---- the whole notification: wrapped, and scrollable so nothing is cut ----
        //
        // Dunst itself truncates what it draws, so this pane is the only place the
        // full text can be read. Two things had to be fixed for that to work:
        //
        //   1. the Text's width was bound to its parent, which inside a Flickable is
        //      the content item -- width 0 -- so wrapping never happened and a long
        //      body simply overflowed unseen. It is now bound to the viewport.
        //   2. Flickable does not scroll on the wheel by itself (that is ScrollView
        //      behaviour), so a WheelHandler does it explicitly. Without it the pane
        //      could only be moved by dragging, which reads as "not scrollable".
        Rectangle {
            width: parent.width
            height: root.detailHeight
            color: "transparent"
            border.width: 1
            border.color: root.colors.primary

            Flickable {
                id: detailFlick

                anchors.fill: parent
                anchors.margins: 8
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: width
                contentHeight: bodyText.implicitHeight

                // Start each notification at its first line, not where the previous
                // one was scrolled to.
                Connections {
                    target: root
                    function onCurrentRowChanged() {
                        detailFlick.contentY = 0;
                    }
                }

                WheelHandler {
                    onWheel: function (event) {
                        var limit = Math.max(0, detailFlick.contentHeight - detailFlick.height);
                        detailFlick.contentY = Math.max(0, Math.min(limit,
                                                          detailFlick.contentY - event.angleDelta.y / 2));
                    }
                }

                Text {
                    id: bodyText

                    width: detailFlick.width
                    text: root.current
                          ? root.current.summary + (root.current.body !== "" ? "\n\n" + root.current.body : "")
                          : "select a notification to read it"
                    wrapMode: Text.Wrap
                    color: root.current ? root.colors.foreground : root.colors.foregroundAlt
                    font.family: root.fontFamily
                    font.pixelSize: root.fontSize
                    font.bold: root.fontBold
                    renderType: Text.CurveRendering
                }
            }

            // Only when there is more to read: a quiet marker, not a scrollbar.
            Text {
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                visible: detailFlick.contentHeight > detailFlick.height
                text: "\u25be scroll"
                color: root.colors.foregroundAlt
                font.family: root.fontFamily
                font.pixelSize: root.fontSize - 2
                font.bold: root.fontBold
                renderType: Text.CurveRendering
            }
        }

        // ---- actions, all clickable (no keyboard dependency) ----
        Row {
            width: parent.width
            spacing: 10

            Repeater {
                model: [
                    { label: "restore", action: "restore" },
                    { label: "dismiss", action: "close" },
                    { label: "remove", action: "remove" },
                    { label: "copy", action: "copy" },
                    { label: "clear all", action: "clear" }
                ]

                delegate: Rectangle {
                    required property var modelData

                    width: actionLabel.implicitWidth + 16
                    height: 22
                    radius: 3
                    color: actionArea.containsMouse ? root.colors.primary : "transparent"
                    border.width: 1
                    border.color: root.colors.primary

                    Text {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: modelData.label
                        color: root.colors.foreground
                        font.family: root.fontFamily
                        font.pixelSize: root.fontSize
                        font.bold: root.fontBold
                        renderType: Text.CurveRendering
                    }

                    MouseArea {
                        id: actionArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            switch (modelData.action) {
                            case "restore": root.restoreCurrent(); break;
                            case "close": root.closeDisplayed(); break;
                            case "remove": root.removeCurrent(); break;
                            case "copy": root.copyCurrent(); break;
                            case "clear": root.clearAll(); break;
                            }
                        }
                    }
                }
            }
        }
    }
}
