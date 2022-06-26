import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: root
    background: Rectangle { radius: 50; border.width: 1; color: root.down ? downcolor : bg }

    property bool solved: false
    property alias value: value_text.text
    property color bg: 'white'
    property alias notice: notice_text.text

    property bool notice_visible: notice_text.visible

    Text {
        id: value_text
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        font.family: 'Arial'
        font.pointSize: 20
        font.bold: true
    }

    Text {
        id: notice_text
        visible: value_text.text != ''
        text: 'Нажмите, чтобы\n' + (parent.solved ? 'отправить':'вычислить')
        font.family: 'Arial'
        font.pointSize: 12
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        horizontalAlignment: Text.AlignHCenter
    }
}
