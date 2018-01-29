import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0

import MyFiles.ImageAnalyzer 1.0

Item{
    id : fond

    ImageAnalyzer{
        id : imageAnalyzer
        onColorsAnalyzed: rect.color = getDominantColor();
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        nameFilters: ["Image files (*.jpg *.jpeg *.png)"]

        onAccepted: {
            var fileChoose = fileDialog.fileUrl.toString().split("/");
            fileChoose = fileChoose[fileChoose.length-1]

            imageToAnalyze.sourceString = "img/" + fileChoose;
        }
    }

    RectangularGlow {
        id: rect
        anchors.fill: imageToAnalyze
        glowRadius: 100
        spread: 0.1
        color: "white"
    }

    Image {
        id : imageToAnalyze
        source : sourceString
        anchors.centerIn: parent
        width : (fond.width < fond.height)?fond.width/2:fond.height/1.5
        height : this.width
        anchors.verticalCenterOffset: -bottom_bar.height/2

        property string sourceString

        onSourceStringChanged: imageAnalyzer.loadImage(imageToAnalyze.sourceString);
        Component.onCompleted: sourceString = "img/img.jpg"

        clip : true
        visible : false
    }

    Image{
        id : mask
        anchors.fill:imageToAnalyze
        source : "qrc:/img/mask.png"
        visible : false
    }

    OpacityMask {
        anchors.fill: imageToAnalyze
        source: imageToAnalyze
        maskSource: mask
    }


    MouseArea{
        anchors.fill: parent

        hoverEnabled: true
        focus:true

        property vector2d test

        onClicked: {
            fileDialog.visible = true
        }
    }
}
