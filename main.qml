import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12

Window {
    id: root
    width: 900
    height: 600
    visible: true
    title: qsTr("ANDOS")

    property color downcolor: '#ebebeb'
    property int step: 0
    property int index: -1

    Rectangle {
        id: vline
        width: 1
        color: 'black'
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 15
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: reset
        visible: false
        width: 60
        height: width
        background: Rectangle { radius: reset.width/2; border.width: 1; color: reset.down ? downcolor : 'white' }
        text: 'R'
        font.family: 'Arial'
        font.pointSize: 20
        font.bold: true
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        onReleased: {
            root.step = 0;
            root.index = -1;
            bob_notice.result = false;
            bob_model.clear();
            alice_model.clear();
            alice_value.text = '';
            bob_value.text = '';
            alice_pbtn.solved = false;
            bob_pbtn.solved = false;
        }
    }

    // Alice

    Text {
        id: alice_lbl
        text: 'Alice'
        font.family: 'Arial'
        font.pointSize: 20
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: vline.left
        horizontalAlignment: Text.AlignHCenter
    }

    Flipable {
        id: alice_flip
        property bool flipped: false
        width: 200
        height: width
        anchors.horizontalCenter: alice_lbl.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        front: FlipButton {
            id: alice_pbtn_1
            anchors.fill: parent
            solved: true
            notice_visible: root.step < 5
            onReleased: {
                if (root.step != 5)
                {
                    bob_pbtn_2.value = value;
                    bob_flip.flipped = !bob_flip.flipped;
                    root.step = 5;
                }
            }
        }

        back: FlipButton {
            id: alice_pbtn_2
            notice_visible: root.step < 5
            anchors.fill: parent
            onReleased: {
                if (root.step != 5)
                {
                    alice_flip.flipped = !alice_flip.flipped;
                    alice_pbtn_1.value = crypter.decrypt_alice(value);
                }
            }
        }

         transform: Rotation {
             id: rotation
             origin.x: alice_flip.width/2
             origin.y: alice_flip.height/2
             axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
             angle: 0    // the default angle
         }

         states: State {
             name: "back"
             PropertyChanges { target: rotation; angle: 180 }
             when: alice_flip.flipped
         }

         transitions: Transition {
             NumberAnimation { target: rotation; property: "angle"; duration: 1000 }
         }
    }

    ListView {
        id: alice_secrets
        interactive: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true
        anchors.left: alice_flip.right
        anchors.right: vline.left
        anchors.margins: 15
        anchors.leftMargin: 30
        spacing: 10
        model: alice_model
        add: Transition { PropertyAnimation { properties: 'y'; from: -50; } }
        delegate: Button {
            id: btn
            width: 60
            height: width
            background: Rectangle { radius: btn.width/2; border.width: 1;
                color: btn.down ? downcolor : index === root.index ? '#C6F66F' : 'white' }
            text: modelData
            font.family: 'Arial'
            font.pointSize: 14
            font.bold: true
        }

        ListModel {
            id: alice_model
        }
    }

    Button {
        id: alice_gbtn
        enabled: root.step <= 1
        width: 60
        height: width
        background: Rectangle { radius: alice_gbtn.width/2; border.width: 1; color: alice_gbtn.down ? downcolor : 'white' }
        text: 'G'
        font.family: 'Arial'
        font.pointSize: 20
        font.bold: true
        anchors.left: parent.left
        anchors.top: alice_flip.top
        anchors.margins: 14
        onReleased: {
            root.step = 1;
            var arr = [];
            alice_model.clear();
            for (var i = 0; i < 8; i++) alice_model.append({value: Math.round(Math.random()*400)});
        }
    }

    Button {
        id: alice_sbtn
        enabled: root.step == 1
        width: 60
        height: width
        background: Rectangle { radius: alice_sbtn.width/2; border.width: 1; color: alice_sbtn.down ? downcolor : 'white' }
        text: 'S'
        font.family: 'Arial'
        font.pointSize: 20
        font.bold: true
        anchors.left: parent.left
        anchors.bottom: alice_flip.bottom
        anchors.margins: 20
        onReleased: {
            root.step = 2;
            bob_model.clear();
            for (var i = 0; i < alice_model.count; i++)
                bob_model.append({value: crypter.crypt_alice(alice_model.get(i).value)});
        }
    }

    // BOB

    Text {
        id: bob_lbl
        text: 'Bob'
        font.pointSize: 20
        font.family: 'Arial'
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.left: vline.right
        horizontalAlignment: Text.AlignHCenter
    }

    Flipable {
        id: bob_flip
        property bool flipped: false
        width: 200
        height: width
        anchors.horizontalCenter: bob_lbl.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        front: FlipButton {
            id: bob_pbtn_1
            notice_visible: root.step < 5
            anchors.fill: parent
            solved: true
            onReleased: {
                if (root.step != 5)
                {
                    alice_pbtn_2.value = value;
                    alice_flip.flipped = true;
                }
            }
        }

        back: FlipButton {
            id: bob_pbtn_2
            notice_visible: root.step < 5
            anchors.fill: parent
            onReleased: {
                if (root.step != 5)
                {
                    bob_flip.flipped = !bob_flip.flipped;
                    bob_pbtn_1.value = crypter.crypt_bob(value);
                }
            }
        }

         transform: Rotation {
             id: rotation_2
             origin.x: bob_flip.width/2
             origin.y: bob_flip.height/2
             axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
             angle: 0    // the default angle
         }

         states: State {
             name: "back"
             PropertyChanges { target: rotation_2; angle: 180 }
             when: bob_flip.flipped
         }

         transitions: Transition {
             NumberAnimation { target: rotation_2; property: "angle"; duration: 1000 }
         }
    }

    ListView {
        id: bob_secrets
        interactive: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true
        anchors.right: bob_flip.left
        anchors.left: vline.right
        anchors.margins: 15
        anchors.rightMargin: 30
        spacing: 10
        model: bob_model
        add: Transition { PropertyAnimation { properties: 'y'; from: -50; } }
        delegate: Button {
            id: dbtn
            width: 60
            height: width
            background: Rectangle { radius: dbtn.width/2; border.width: 1; color: dbtn.down ? downcolor : 'white' }
            text: modelData
            font.family: 'Arial'
            font.pointSize: 14
            font.bold: true
            onReleased: {
                if (root.step == 2)
                {
                    bob_flip.flipped = true;
                    bob_pbtn_2.value = modelData;
                    root.step = 3;
                    root.index = index;
                }
            }
        }

        ListModel {
            id: bob_model
        }
    }

    Button {
        enabled: root.step == 5
        id: bob_dbtn
        width: 60
        height: width
        background: Rectangle { radius: bob_dbtn.width/2; border.width: 1; color: bob_dbtn.down ? downcolor : 'white' }
        text: 'D'
        font.family: 'Arial'
        font.pointSize: 20
        font.bold: true
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.verticalCenter: bob_flip.verticalCenter
        onReleased: {
            bob_flip.flipped = !bob_flip.flipped;
            bob_pbtn_1.value = crypter.decrypt_bob(bob_pbtn_2.value);
            bob_pbtn_1.bg = '#C6F66F';
            bob_pbtn_1.notice = 'Результат';
            root.step = 6;
        }
    }
}
