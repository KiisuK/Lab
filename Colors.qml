import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0

import MyFiles.ImageAnalyzer 1.0

Item{
    id : fond

    ImageAnalyzer{
        id : imageAnalyzer
        onPixelsRGBChanged: {
            console.log("Image Analysed")
        }

        onColorsAnalyzed: rect.color = getDominantColor();
    }

    Rectangle{
        id : rect
        anchors.fill : parent
        color : "grey"
    }

    Image {
        id : imageToAnalyze
        source : sourceString
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -bottom_bar.height/2
        width : (fond.width < fond.height)?fond.width/2:fond.height/1.5
        height : this.width
        property string sourceString : "img/img.jpg"

        Component.onCompleted: imageAnalyzer.loadImage(imageToAnalyze.sourceString);
    }

    MouseArea{
        anchors.fill: parent

        hoverEnabled: true
        focus:true

        property vector2d test

        onClicked: {
            console.log(imageAnalyzer.getM_Colors(52));
        }
    }
}
