import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0

import MyFiles.ImageAnalyzer 1.0

Item{
    id : fond

    ImageAnalyzer{ id : imageAnalyzer }

    Image {
        id : imageToAnalyze
        source : sourceString
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -bottom_bar.height/2
        width : (fond.width < fond.height)?fond.width/2:fond.height/2
        height : this.width
        property string sourceString : "img/img.png"
    }

    MouseArea{
        anchors.fill: parent

        hoverEnabled: true
        focus:true

        onClicked: {
            //            if(hidecursor.cursorShape == Qt.BlankCursor)
            //                hidecursor.cursorShape = Qt.ArrowCursor
            //            else
            //                hidecursor.cursorShape = Qt.BlankCursor

            imageAnalyzer.loadImage(imageToAnalyze.sourceString);

            for(var i=0;i<imageToAnalyze.sourceSize.height;i++)
            {
                for(var j=0;j<imageToAnalyze.sourceSize.width;j++)
                {
                    imageAnalyzer.getPixelValues(j , i)
                }
            }

            console.log("clic")
        }

    }

}
