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



    Q_INVOKABLE QString getPixelsValues(QString fileName)
    {
        qDebug()<<"File is : " << fileName;


        if(image->load(fileName))
        {

            return "Oui";

        }

        return "Non";
    }

private :
    QImage *image;

};





#endif // IMAGEANALYZER_H
