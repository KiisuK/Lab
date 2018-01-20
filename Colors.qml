import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0

Item{
    id : fond

    MouseArea{
        anchors.fill: parent

        hoverEnabled: true
        focus:true

        onClicked: {
            //            if(hidecursor.cursorShape == Qt.BlankCursor)
            //                hidecursor.cursorShape = Qt.ArrowCursor
            //            else
            //                hidecursor.cursorShape = Qt.BlankCursor

            console.log("clic")
            mycanvas.loadImage("qrc:/img/img.png")
           // mycanvas.requestPaint()
        }

    }

    Canvas {
        id: mycanvas
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -bottom_bar.height/2

        width: (parent.width<parent.height)?parent.width/2:parent.height/2
        height: this.width

        property string imgFile : "qrc:/img/img.png"
        Component.onCompleted:loadImage(mycanvas.imagefile);

        onPaint: {
            console.log("paint")
            var ctx = getContext("2d");


//            ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
//            ctx.fillRect(0, 0, width, height);
        }

        onImageLoaded: {
            requestPaint()
        }
    }
}
