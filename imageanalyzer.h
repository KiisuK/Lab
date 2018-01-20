#ifndef IMAGEANALYZER_H
#define IMAGEANALYZER_H



#include <QObject>

class ImageAnalyzer : public QObject{
   Q_OBJECT
public:
    explicit ImageAnalyzer (QObject* parent = 0) : QObject(parent) {}

    Q_INVOKABLE QString getPixelsValues(QString fileName)
    {
        unsigned char *data = stbi_load((fileName), &width, &height, &numComponents, 3);

        qDebug()<< data.length;
        return filename;
    }

};





#endif // IMAGEANALYZER_H
