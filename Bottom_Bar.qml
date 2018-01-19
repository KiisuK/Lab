import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Button{
    width : parent.width
    height : 100
    flat : false

    onClicked: {
        root.current_app = "Menu"
        hidecursor.cursorShape = Qt.ArrowCursor
    }

    Text{
        id : title_label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: left_arrow.right
        anchors.leftMargin: 15
        text : "Menu"
        font.family: "Roboto Light"
        font.pointSize:  46
    }

    Image{
        id : left_arrow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left : parent.left
        anchors.leftMargin: 10

        width : this.height
        height : parent.height * 0.5

        source : "qrc:/img/left_Arrow.svg"

    }
}
