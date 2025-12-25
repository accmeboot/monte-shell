pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
import QtQuick.Layouts

import qs.Components
import qs.Config

PanelWindow {
    id: root

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    implicitWidth: container.implicitWidth + shadow.extraSpace
    implicitHeight: container.implicitHeight + shadow.extraSpace

    exclusionMode: ExclusionMode.Normal

    visible: false

    property var apps
    property string command: ""

    Process {
        id: fetchApps
        command: ["deutils", "list"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.apps = root.sortApps(data);
                } catch (error) {
                    console.error("Error parsing apps: ", error);
                }
            }
        }
    }

    Process {
        id: searchApps
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.apps = root.sortApps(data);
                } catch (error) {
                    console.error("Error parsing apps: ", error);
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle() {
            root.visible = !root.visible;
        }
    }

    anchors {
        top: true
    }

    Component.onCompleted: {
        fetchApps.running = true;
    }

    MShadowEffect {
        id: shadow
        source: container
        anchors.fill: container
    }

    onVisibleChanged: {
        if (visible) {
            // currently there is warning, it happens because of race condition, look up Loader in the docs to fix it, if it breaks something
            searchInput.forceActiveFocus();

            appsListView.currentIndex = 0;
            root.command = "";
            searchInput.text = "";
        }
    }

    Item {
        id: container
        property int concavesWidth: concaveTopLeft.implicitWidth + concaveTopRight.implicitWidth

        implicitWidth: content.implicitWidth + concavesWidth
        implicitHeight: content.implicitHeight

        anchors.horizontalCenter: parent.horizontalCenter

        Keys.onUpPressed: {
            if (appsListView.currentIndex < appsListView.count - 1) {
                appsListView.currentIndex++;
                appsListView.positionViewAtIndex(appsListView.currentIndex, ListView.Contain);
            }
        }

        Keys.onDownPressed: {
            if (appsListView.currentIndex > 0) {
                appsListView.currentIndex--;
                appsListView.positionViewAtIndex(appsListView.currentIndex, ListView.Contain);
            }
        }

        Keys.onReturnPressed: {
            if (root.command !== "") {
                root.runCommand(root.command);
            } else {
                root.openApp(root.apps[appsListView.currentIndex]);
            }
        }

        Keys.onEscapePressed: {
            root.visible = false;
        }

        MConcaveCorner {
            id: concaveTopLeft
            location: "top-left"
            anchors.top: parent.top
            anchors.left: parent.left
        }

        MConcaveCorner {
            id: concaveTopRight
            location: "top-right"
            anchors.top: parent.top
            anchors.right: parent.right
        }

        MContainer {
            id: content
            topLeftRadius: 0
            topRightRadius: 0

            anchors.horizontalCenter: parent.horizontalCenter

            ColumnLayout {
                ScrollView {
                    id: scrollView

                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                    implicitWidth: 300
                    implicitHeight: 280

                    clip: true

                    ListView {
                        id: appsListView
                        model: root.apps
                        spacing: MSpacing.s

                        verticalLayoutDirection: ListView.BottomToTop

                        currentIndex: 0

                        WheelHandler {
                            id: wheel
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            onWheel: event => {
                                var up = event.angleDelta.y > 0;

                                if (up) {
                                    appsListView.incrementCurrentIndex();
                                } else {
                                    appsListView.decrementCurrentIndex();
                                }
                            }
                        }

                        delegate: MContainer {
                            id: app

                            required property var modelData
                            required property int index

                            property bool isSelected: appsListView.currentIndex === index

                            color: isSelected ? MColors.base0D : MColors.base00

                            maxWidth: scrollView.implicitWidth

                            Item {
                                implicitWidth: appRow.implicitWidth
                                implicitHeight: appRow.implicitHeight

                                MouseArea {
                                    anchors.fill: parent

                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: {
                                        root.openApp(app.modelData);
                                    }
                                }

                                RowLayout {
                                    id: appRow
                                    spacing: MSpacing.xs

                                    MIcon {
                                        id: appIcon
                                        size: MIcons.l
                                        source: app.modelData.icon
                                    }

                                    MText {
                                        text: {
                                            if (app.modelData.comment) {
                                                return `<b>${app.modelData.name}</b> (<i>${app.modelData.comment}</i>)`;
                                            }

                                            return `<b>${app.modelData.name}</b>`;
                                        }
                                        elide: Text.ElideRight
                                        //NOTE: QT Layout system sucks ass
                                        Layout.preferredWidth: scrollView.implicitWidth - appIcon.width - app.paddingHorizontal * 2 - appRow.spacing
                                        textFormat: Text.StyledText
                                        color: app.isSelected ? MColors.base00 : MColors.base05
                                    }
                                }
                            }
                        }
                    }
                }

                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    color: MColors.base05

                    topPadding: MSpacing.xs
                    bottomPadding: MSpacing.xs

                    leftPadding: MSpacing.s + searchIcon.size
                    rightPadding: MSpacing.xs

                    placeholderText: "Type : to run a command"
                    placeholderTextColor: MColors.base04

                    background: Rectangle {
                        color: MColors.base01
                        radius: MBorder.radius

                        MIcon {
                            id: searchIcon
                            anchors.leftMargin: MSpacing.xs
                            anchors.left: parent.left
                            fromSource: root.command !== "" ? "shell.svg" : "find.svg"
                            size: MIcons.l
                            color: MColors.base05
                            overlay: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Keys.forwardTo: content

                    onTextChanged: {
                        if (text.charAt(0) === ":") {
                            root.command = text;

                            return;
                        }

                        root.command = "";

                        searchApps.exec(["deutils", "search", text.trim()]);
                    }
                }
            }
        }
    }

    function sortApps(data) {
        try {
            return JSON.parse(data.trim()).slice().filter(app => !app.terminal).sort((a, b) => a.name.toUpperCase() > b.name.toUpperCase() ? 1 : -1);
        } catch (e) {
            console.warn("Failed to parse desktop entries:", e);
            return [];
        }
    }

    function openApp(app) {
        if (!app.terminal) {
            Quickshell.execDetached(app.execArgs);

            root.visible = false;
        }
    }

    function runCommand(command) {
        Quickshell.execDetached(["sh", "-c", command.substring(1).trim()]);

        root.visible = false;
    }
}
