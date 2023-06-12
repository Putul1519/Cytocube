import QtQuick 2.2
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Window {
    id: main
    visible: true
    width: 1280
    height: 720
    color: "#000000"
    title: qsTr("Main")

    Image {
        id: image
        x: 30
        anchors.right: parent.right
        anchors.rightMargin: 558
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 170
        clip: false
        source: "qrc:/qtquickplugin/images/template_image.png"
    }

    Image {
        id: image1
        x: 30
        y: 30
        width: 50
        height: 50
        fillMode: Image.Stretch
        source: "0.jpg"
    }

    Text {
        id: text1
        x: 86
        y: 30
        width: 442
        height: 50
        color: "#ffffff"
        text: qsTr("ShanMukha Innovations Pvt Ltd")
        verticalAlignment: Text.AlignVCenter
        lineHeight: 5
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 31
    }

    Text {
        id: text2
        x: 260
        y: 135
        color: "#ffffff"
        text: qsTr("Live View of the Slide")
        styleColor: "#d20909"
        fontSizeMode: Text.Fit
        font.pixelSize: 24
    }

    Row {
        id: row
        x: 758
        y: 170
        width: 512
        height: 256
        spacing: 2
        anchors.right: parent.right
        anchors.rightMargin: 30

        Rectangle {
            id: rectangle
            width: 240
            height: 64
            color: "#ffffff"
            radius: 30
            border.color: "#040404"

            Text {
                id: text3
                text: qsTr("Take a Snapshot")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }
        }

        Rectangle {
            id: rectangle1
            width: 240
            height: 64
            color: "#ffffff"
            radius: 30
            anchors.right: parent.right
            anchors.rightMargin: 0

            Text {
                id: text4
                text: qsTr("Auto Focus")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }
        }
    }
}
