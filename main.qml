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

    Button {
        id: alice_pbtn
        width: 200
        height: width
        background: Rectangle { radius: 50; border.width: 1; color: alice_pbtn.down ? downcolor : 'white' }
        anchors.horizontalCenter: alice_lbl.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        property bool solved: false

        Text {
            id: alice_value
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
            visible: alice_value.text != ''
            text: 'Нажмите, чтобы\n' + (parent.solved ? 'отправить':'вычислить')
            font.family: 'Arial'
            font.pointSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            horizontalAlignment: Text.AlignHCenter
        }

        onReleased: {
            if (!solved)
            {
                alice_value.text = crypter.decrypt_alice(alice_value.text);
                solved = true;
            }
            else if (root.step == 4)
            {
                root.step = 5;
                bob_value.text = alice_value.text;
            }
        }
    }

    ListView {
        id: alice_secrets
        interactive: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true
        anchors.left: alice_pbtn.right
        anchors.right: vline.left
        anchors.margins: 15
        anchors.leftMargin: 30
        spacing: 10
        model: alice_model
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
        anchors.top: alice_pbtn.top
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
        anchors.bottom: alice_pbtn.bottom
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

    Button {
        id: bob_pbtn
        width: 200
        height: width
        background: Rectangle { radius: 50; border.width: 1;
            color: bob_pbtn.down ? downcolor : bob_notice.text == 'Результат' ? '#C6F66F' : 'white' }
        anchors.horizontalCenter: bob_lbl.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        property bool solved: false

        Text {
            id: bob_value
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
            id: bob_notice
            property bool result: false
            visible: bob_value.text != ''
            text: result ? 'Результат' : 'Нажмите, чтобы\n' + (parent.solved ? 'отправить' : "вычислить")
            font.family: 'Arial'
            font.pointSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            horizontalAlignment: Text.AlignHCenter
        }

        onReleased: {
            if (!solved)
            {
                bob_value.text = crypter.crypt_bob(bob_value.text);
                solved = true;
            }
            else if (root.step == 3)
            {
                root.step = 4;
                alice_value.text = bob_value.text;
            }
        }
    }

    ListView {
        id: bob_secrets
        interactive: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true
        anchors.right: bob_pbtn.left
        anchors.left: vline.right
        anchors.margins: 15
        anchors.rightMargin: 30
        spacing: 10
        model: bob_model
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
                    bob_value.text = modelData;
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
        anchors.verticalCenter: bob_pbtn.verticalCenter
        onReleased: {
            bob_value.text = crypter.decrypt_bob(bob_value.text);
            bob_notice.result = true;
        }
    }
}
