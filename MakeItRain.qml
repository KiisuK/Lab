import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Particles 2.0

Rectangle{
    id : fond
    color : "#1d2b44"
    property int angle : 0
    property color night : "#1d2b44"

    Behavior on angle{
        NumberAnimation{
            duration : 1000
            easing.type: Easing.InOutQuad
        }
    }


    MouseArea{
        anchors.fill: parent

        hoverEnabled: true
        focus:true
        onMouseXChanged: {
            //fond.angle = -1*(-30+mouseX/fond.width*60)
        }

        onClicked: {
            if(hidecursor.cursorShape == Qt.BlankCursor)
                hidecursor.cursorShape = Qt.ArrowCursor
            else
                hidecursor.cursorShape = Qt.BlankCursor
        }

        Keys.onPressed: {
            if (event.key == Qt.Key_Return) {
                animOrage.restart()
            }
        }
    }

    Timer
    {
        id : timer_rain_dir
        running : true
        repeat : true

        interval : getInterval()

        function getInterval()
        {
            return Math.random()*20000
        }

        onTriggered: {
            interval = getInterval()
            fond.angle = -1*(-45 + Math.random()*90)
        }
    }

    Timer
    {
        id : timer_orage
        running : true
        repeat : true

        interval : getInterval()

        function getInterval()
        {
            return Math.random()*8000
        }

        onTriggered: {
            interval = getInterval()
            animOrage.restart()
        }
    }

    Timer
    {
        id : timer_emitRate
        running : true
        repeat : true

        interval : getInterval()

        function getInterval()
        {
            return 5000 + Math.random()*20000
        }

        onTriggered: {
            interval = getInterval()
            emitRain.emitRate = Math.random()*2000
        }
    }

    ParticleSystem{
        id : particleSystem
        anchors.fill:parent

        ItemParticle{
            delegate: rain_shape
            fade : true
            groups: ["rain"]
        }

        Emitter{
            id : emitRain
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top : parent.top
            anchors.topMargin: -250
            width : parent.width + 800
            lifeSpan: 700
            lifeSpanVariation: 100
            sizeVariation: 40
            group : "rain"
            emitRate: 1000

            velocity: PointDirection{x : -fond.angle*30; xVariation: 50; y : 1500; yVariation: 200 }
        }
    }


    Component
    {
        id : rain_shape
        Rectangle{
            id : rect
            width : Math.random()*5
            height : 50 + Math.random()*50
            color : pickColor()//"#BDBDBD"
            transform: Rotation{origin.x : rect.width /2; origin.y: rect.height/2; angle : fond.angle}

            function pickColor()
            {
                var r = (Math.random()*3).toFixed(0)
                if(r<1)
                    return "#BDBDBD"
                else if(r<2)
                    return "#9E9E9E"
                else
                    return "#757575"
            }
        }
    }

    SequentialAnimation{
        id : animOrage
        running : false

        ColorAnimation{
            target : fond
            property : "color"
            to : "white"
            duration : 10
        }

        ColorAnimation{
            target : fond
            property : "color"
            to : fond.night
            duration : 1000
        }

    }

}



// gris
/*
  BDBDBD
  9E9E9E
  757575
*/
