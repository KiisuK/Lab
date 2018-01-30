import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id : root
    visible: true
    width: 1180
    height: 600
    title: qsTr("Lab")

    property string current_app : "Menu"

    ListModel{
        id : model_app
        ListElement{
            title : "Make It Rain"
            description : "A stormy night"
        }
        ListElement{
            title : "Make It Snow"
            description : "A snowy day"
        }
        ListElement{
            title : "Colors"
            description : "Extract dominant color"
        }
        ListElement{
            title : "FireWorks"
            description : "Play with particle systems"
        }
    }

    Component
    {
        id : list_delegate

        Button{
            width : parent.width
            height : 100
            flat : false

            onClicked: {
                root.current_app = title

                //hidecursor.cursorShape = Qt.BlankCursor
            }

            Text{
                id : title_label
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.topMargin: 10
                text : title
                font.family: "Roboto Light"
                font.pointSize:  32
            }

            Text{
                id : description_label
                anchors.bottom : parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.bottomMargin: 10
                text : description
                font.family: "Roboto Light"
                font.pointSize:  16
            }

            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right : parent.right
                anchors.rightMargin: 10
                width : this.height
                height : parent.height * 0.5
                source : "qrc:/img/right_Arrow.svg"
            }
        }
    }

    Column
    {
        anchors.fill:parent
        opacity : root.current_app == "Menu" ? 1.0 : 0.0
        visible : opacity == 0.0 ? false : true
        spacing : 0

        Repeater{
            model: model_app
            delegate: list_delegate
        }
    }


    MakeItRain{
        opacity : root.current_app == "Make It Rain" ? 1.0 : 0.0
        visible : opacity == 0.0 ? false : true

        anchors.fill:parent
    }

    Colors{
        opacity : root.current_app == "Colors" ? 1.0 : 0.0
        visible : opacity == 0.0 ? false : true

        anchors.fill:parent
    }

    FireWorks{
        opacity : root.current_app == "FireWorks" ? 1.0 : 0.0
        visible : opacity == 0.0 ? false : true

        anchors.fill:parent    }

    Bottom_Bar{
        id : bottom_bar
        opacity : root.current_app != "Menu" ? 1.0 : 0.0
        visible : opacity == 0.0 ? false : true

        anchors.bottom: parent.bottom
        anchors.bottomMargin: -5
        anchors.horizontalCenter: parent.horizontalCenter
    }


    MouseArea {
        id : hidecursor
        anchors.fill: parent;
        enabled: false ;
        cursorShape: Qt.ArrowCursor//Qt.BlankCursor
    }


}
