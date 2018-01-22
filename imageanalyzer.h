#ifndef IMAGEANALYZER_H
#define IMAGEANALYZER_H



#include <QObject>
#include <QImage>
#include <QDebug>

class ImageAnalyzer : public QObject{
    Q_OBJECT
public:
    explicit ImageAnalyzer (QObject* parent = 0) : QObject(parent)
    {
        image = new QImage();
    }

    Q_INVOKABLE void loadImage(QString fileName)
    {
        imageLoaded = image->load(fileName);
    }

    Q_INVOKABLE QString getPixelValues(int x , int y)
    {
        QString pixels = "";

        if(imageLoaded)
        {

            QString tmpR = QString::number(image->pixelColor(x,y).red());
            QString tmpG = QString::number(image->pixelColor(x,y).green());
            QString tmpB = QString::number(image->pixelColor(x,y).blue());
            pixels.append(tmpR);
            pixels += ",";
            pixels.append(tmpG);
            pixels += ",";
            pixels.append(tmpB);

        }

        return pixels;
    }

private :
    QImage *image;
    bool imageLoaded = false;

};





#endif // IMAGEANALYZER_H
