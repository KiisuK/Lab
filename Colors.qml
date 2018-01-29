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
        onColorsAnalyzed: {
            rect.color = getDominantColor();
            text.color = getAccentColor(rect.color);
        }
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
        cornerRadius: 25
        spread: 0.0
        color: "white"
    }

    Image {
        id : imageToAnalyze
        source : sourceString

        width : (fond.width < fond.height)?fond.width/2:fond.height/2
        height : this.width

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -bottom_bar.height/2

        fillMode: Image.PreserveAspectCrop

        visible : false
        property string sourceString

        onSourceStringChanged: imageAnalyzer.loadImage(imageToAnalyze.sourceString);
        Component.onCompleted: sourceString = "img/img.jpg"
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

    Text{
        id : text
        z : 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottom_bar.height

        width : parent.width
        height : 100

        font.pointSize: 44
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text : "Your Title Here"
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        focus:true

        onClicked: {
            fileDialog.visible = true
        }
    }
}
